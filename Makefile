.PHONY: all generate docc server md license mcp-data check-changes clean

# 기본 타겟(로컬용): 문서 생성 후 변경사항 가드 실행
# check-changes를 prerequisite가 아닌 recipe에서 호출해야 make -j 병렬 실행 시
# generate가 완료된 뒤 순차적으로 검사된다.
all: generate
	@$(MAKE) check-changes

# 문서/MCP 데이터 생성만 수행 (CI에서 생성 후 자동 커밋할 때 사용)
generate: docc md license mcp-data

# md와 mcp-data는 docc가 생성한 .doccarchive를 입력으로 사용하므로
# 병렬 빌드(make -j)에서도 docc 완료 후 실행되도록 명시한다.
md: docc
mcp-data: docc

# DocC API 문서 생성
# 현재 선택된 Xcode로 생성한다. Xcode 버전에 따라 결과가 달라질 수 있어서,
# PR에 들어가는 최종 문서는 CI(verify-docs → apply-docs)가 빌드머신 Xcode로 다시 생성해 커밋한다.
docc:
	@echo ""; \
	echo "================================================="; \
	echo "API 문서 생성 중... (Xcode: $$(xcodebuild -version | head -1))"; \
	echo "================================================="; \
	set -o pipefail; \
	if ! ./scripts/generate_docc.sh 2>&1 | tee build_docs.log; then \
		echo "[docc] generate_docc.sh 실행 실패"; \
		grep -A 20 'error:' build_docs.log; \
		rm build_docs.log; \
		exit 1; \
	fi; \
	rm build_docs.log

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

# Montage MCP 슬림 인덱스 갱신 (doccarchive + xcassets → packages/montage-mcp/data/)
mcp-data:
	@echo ""; \
	echo "================================================="; \
	echo "Montage MCP 데이터 인덱스 갱신 중..."; \
	echo "================================================="; \
	node scripts/build_mcp_data.js

# 문서 변경사항 확인 (문서 + MCP 데이터)
check-changes:
	@echo ""; \
	echo "================================================="; \
	echo "문서/MCP 데이터 변경사항 확인 중..."; \
	echo "================================================="; \
	if git diff --quiet THIRD_PARTY_LICENSES.md documentation/ packages/montage-mcp/data/ 2>/dev/null; then \
		echo "✅ 문서/MCP 데이터가 모두 최신 상태입니다."; \
	else \
		echo "📝 변경사항이 있습니다. 다음 명령어로 커밋하세요:"; \
		echo ""; \
		echo "  git add THIRD_PARTY_LICENSES.md documentation/ packages/montage-mcp/data/"; \
		echo "  git commit -m \"docs: 문서 업데이트\""; \
		echo ""; \
		echo "변경된 파일:"; \
		git diff --name-only THIRD_PARTY_LICENSES.md documentation/ packages/montage-mcp/data/ 2>/dev/null | sed 's/^/  - /'; \
		exit 1; \
	fi

# 생성된 문서 파일들 정리
clean:
	@echo ""; \
	echo "================================================="; \
	echo "생성된 문서 파일들 정리 중..."; \
	echo "================================================="; \
	rm -rf documentation/ THIRD_PARTY_LICENSES.md .build/ build_docs.log; \
	echo "✅ 정리 완료"