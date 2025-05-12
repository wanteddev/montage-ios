#!/bin/sh

# Xcode 프로젝트/워크스페이스에서 사용할 Scheme 이름
SCHEME_NAME="Montage"

# 사용자 정의 DerivedData 경로 (빌드 아티팩트 및 DocC 아카이브 저장 위치)
CUSTOM_DERIVED_DATA=".build/derived_data"

# 최종적으로 정적 호스팅용으로 변환된 문서가 저장될 경로
FINAL_OUTPUT_PATH="docc"

# 기존 출력 디렉토리 정리
echo "Cleaning output directories..."
rm -rf "$CUSTOM_DERIVED_DATA" # 사용자 정의 DerivedData 삭제
rm -rf "$FINAL_OUTPUT_PATH"
mkdir -p "$CUSTOM_DERIVED_DATA" # 디렉토리 다시 생성
mkdir -p "$FINAL_OUTPUT_PATH"
# xcodebuild docbuild를 사용하여 문서 생성 (-derivedDataPath 로 출력 위치 제어)
xcodebuild docbuild \
  -scheme "$SCHEME_NAME" \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$CUSTOM_DERIVED_DATA"

# docbuild 명령어 실행 결과 확인
if [ $? -ne 0 ]; then
  echo "Error: xcodebuild docbuild failed."
  exit 1
fi

echo "xcodebuild docbuild completed. Searching for .doccarchive in $CUSTOM_DERIVED_DATA..."

# 사용자 정의 DerivedData 경로 내에서 .doccarchive 파일 찾기
# 보통 Build/Products/<Config>-<platform>/ 경로 아래에 생성됨
# find 명령어로 더 안정적으로 검색
DOCC_ARCHIVE_PATH=$(find "$CUSTOM_DERIVED_DATA" -name "${SCHEME_NAME}.doccarchive" -type d -print -quit)

# 찾았는지 확인
if [ -z "$DOCC_ARCHIVE_PATH" ] || [ ! -d "$DOCC_ARCHIVE_PATH" ]; then
  echo "Error: Could not find ${SCHEME_NAME}.doccarchive within $CUSTOM_DERIVED_DATA"
  echo "Please check the output of xcodebuild docbuild or the contents of $CUSTOM_DERIVED_DATA."
  exit 1
fi

echo "DocC archive found at: $DOCC_ARCHIVE_PATH"
echo "Transforming archive for static hosting..."

# 찾은 아카이브를 정적 호스팅용으로 변환
xcrun docc process-archive transform-for-static-hosting \
  "$DOCC_ARCHIVE_PATH" \
  --output-path "$FINAL_OUTPUT_PATH" \
  --hosting-base-path /

# xcrun docc 명령어 실행 결과 확인
if [ $? -ne 0 ]; then
  echo "Error: Failed to transform DocC archive for static hosting."
  exit 1
fi

echo "Documentation transformed successfully for static hosting in $FINAL_OUTPUT_PATH"
exit 0