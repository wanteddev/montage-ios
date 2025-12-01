# 문서 생성시 사용해야 하는 Xcode 버전
# 빌드머신의 Xcode 버전과 동일하게 설정해야 합니다.
XCODE_VERSION=16.4

docs:
# 문서 생성 스크립트입니다.
# PR 생성 전에 실행해서 문서 산출물이 최신 상태인지 확인하고 변경 사항이 있다면 커밋해야 합니다.
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
	echo "API 문서 및 3rd Party 라이선스 문서 생성 중..."; \
	echo "================================================="; \
	if ! ./scripts/generate_docc.sh 2>&1 | tee build_docs.log; then \
		echo "[docs] generate_docc.sh 실행 실패 — Xcode 버전을 $$CURRENT_XCODE_VERSION로 재설정합니다."; \
		xcodes select $$CURRENT_XCODE_VERSION; \
		grep -A 20 'error:' build_docs.log; \
		rm build_docs.log; \
		exit 1; \
	fi; \
	xcodes select $$CURRENT_XCODE_VERSION; \
	node scripts/docc_to_md.js; \
	node scripts/generate_third_party_licenses.mjs; \
	echo ""; \
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