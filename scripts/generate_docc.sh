#!/bin/sh

# Xcode 프로젝트/워크스페이스에서 사용할 Scheme 이름
SCHEME_NAME="Montage"

# 사용자 정의 DerivedData 경로 (빌드 아티팩트 및 DocC 아카이브 저장 위치)
CUSTOM_DERIVED_DATA=".build/derived_data"

# 기존 출력 디렉토리 정리
echo "Cleaning output directories..."
rm -rf "$CUSTOM_DERIVED_DATA" # 사용자 정의 DerivedData 삭제
mkdir -p "$CUSTOM_DERIVED_DATA" # 디렉토리 다시 생성

# Xcode의 Build Location을 Custom(워크스페이스 상대)으로 바꿔 둔 환경에서는 그 설정이
# -derivedDataPath보다 우선해서 산출물이 워크스페이스 밑 Build/Products로 빠져나간다.
# 명령줄로 넘긴 빌드 설정은 그보다 우선하므로, SYMROOT/OBJROOT를 절대경로로 못 박아
# 사람마다 다른 Xcode 환경설정과 무관하게 같은 자리에 쌓이게 한다.
DERIVED_DATA_ABS=$(cd "$CUSTOM_DERIVED_DATA" && pwd)

# xcodebuild docbuild를 사용하여 문서 생성
xcodebuild docbuild \
  -scheme "$SCHEME_NAME" \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "$CUSTOM_DERIVED_DATA" \
  SYMROOT="$DERIVED_DATA_ABS/Build/Products" \
  OBJROOT="$DERIVED_DATA_ABS/Build/Intermediates.noindex"

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
  echo "산출물이 다른 곳에 생겼다면 Xcode의 Build Location 설정을 확인해주세요:"
  echo "  defaults read com.apple.dt.Xcode IDEBuildLocationStyle"
  exit 1
fi

echo "DocC archived: $DOCC_ARCHIVE_PATH"
echo "You can now host the documentation using the following command:"
echo "---------------------------------------------------------"
echo "  python3 -m http.server --directory $DOCC_ARCHIVE_PATH"
echo "---------------------------------------------------------"
echo "And access the documentation at http://localhost:8000/documentation/montage"
exit 0