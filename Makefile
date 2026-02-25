.PHONY: all docc server md license check-changes clean

# 문서 생성시 사용해야 하는 Xcode 버전
# 빌드머신의 Xcode 버전과 동일하게 설정해야 합니다.
XCODE_VERSION=16.4

# 기본 타겟: docc, md, license를 순서대로 실행하고 변경사항 확인
all: docc md license check-changes

# DocC API 문서 생성
docc:
	@echo ""; \
	echo "================================================="; \
	echo "Xcode 버전 확인 중..."; \
	echo "================================================="; \
	command -v xcodes >/dev/null 2>&1 || brew install robotsandpencils/made/xcodes; \
	INSTALLED_XCODES=$$(xcodes installed | awk '{print $$1}'); \
	if ! echo "$$INSTALLED_XCODES" | grep -q "^${XCODE_VERSION}$$"; then \
		echo "Xcode ${XCODE_VERSION}이 설치되어 있지 않습니다. 설치를 시작합니다..."; \
		echo "문서 생성에 필요한 Xcode 버전이 변경되었다면 Makefile의 XCODE_VERSION 변수를 업데이트해주세요."; \
		xcodes install ${XCODE_VERSION}; \
	fi; \
	CURRENT_XCODE_VERSION=$$(xcodes installed | grep Selected | awk '{print $$1}'); \
	if [ "$$CURRENT_XCODE_VERSION" != "${XCODE_VERSION}" ]; then \
		echo "Xcode 버전을 ${XCODE_VERSION}로 변경합니다."; \
		xcodes select ${XCODE_VERSION}; \
	fi; \
	echo ""; \
	echo "================================================="; \
	echo "API 문서 생성 중..."; \
	echo "================================================="; \
	set -o pipefail; \
	if ! ./scripts/generate_docc.sh 2>&1 | tee build_docs.log; then \
		echo "[docc] generate_docc.sh 실행 실패 — Xcode 버전을 $$CURRENT_XCODE_VERSION로 재설정합니다."; \
		xcodes select $$CURRENT_XCODE_VERSION; \
		grep -A 20 'error:' build_docs.log; \
		rm build_docs.log; \
		exit 1; \
	fi; \
	rm build_docs.log; \
	xcodes select $$CURRENT_XCODE_VERSION

# DocC 문서 서버 애플리케이션 실행
server:
	@ARCHIVE_PATH=".build/derived_data/Build/Products/Debug-iphoneos/Montage.doccarchive"; \
	if [ ! -d "$$ARCHIVE_PATH" ]; then \
		echo "❌ $$ARCHIVE_PATH 가 존재하지 않습니다. 먼저 'make docc'를 실행하세요."; \
		exit 1; \
	fi; \
	echo "http://localhost:8000/documentation/montage 에서 문서를 확인하세요."; \
	python3 -m http.server --directory "$$ARCHIVE_PATH"


# DocC 문서를 Markdown으로 변환
md:
	@echo ""; \
	echo "================================================="; \
	echo "DocC 문서를 Markdown으로 변환 중..."; \
	echo "================================================="; \
	node scripts/docc_to_md.js

# 3rd Party 라이선스 문서 생성
license:
	@echo ""; \
	echo "================================================="; \
	echo "3rd Party 라이선스 문서 생성 중..."; \
	echo "================================================="; \
	node scripts/generate_third_party_licenses.mjs

# 문서 변경사항 확인
check-changes:
	@echo ""; \
	echo "================================================="; \
	echo "문서 변경사항 확인 중..."; \
	echo "================================================="; \
	if git diff --quiet THIRD_PARTY_LICENSES.md documentation/ 2>/dev/null; then \
		echo "✅ 문서가 모두 최신 상태입니다. 문서 변경사항이 없습니다."; \
	else \
		echo "📝 문서에 변경사항이 있습니다. 다음 명령어로 커밋하세요:"; \
		echo ""; \
		echo "  git add THIRD_PARTY_LICENSES.md documentation/"; \
		echo "  git commit -m \"docs: 문서 업데이트\""; \
		echo ""; \
		echo "변경된 파일:"; \
		git diff --name-only THIRD_PARTY_LICENSES.md documentation/ 2>/dev/null | sed 's/^/  - /'; \
	fi

# 생성된 문서 파일들 정리
clean:
	@echo ""; \
	echo "================================================="; \
	echo "생성된 문서 파일들 정리 중..."; \
	echo "================================================="; \
	rm -rf documentation/ THIRD_PARTY_LICENSES.md .build/ build_docs.log; \
	echo "✅ 정리 완료"