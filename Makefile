docs:
# 문서 생성 스크립트입니다.
# PR 생성 전에 실행해서 문서 산출물이 최신 상태인지 확인하고 변경 사항이 있다면 커밋해야 합니다.
# 빌드머신의 Xcode 버전이 로컬과 달라서 자동으로 맞춥니다.
# 빌드머신의 Xcode가 업데이트되면 수정이 필요합니다.
	xcodes select 16.4
	./generate_docc.sh
	xcodes select 26.0.1
	node docc_to_md.js
	node generate_third_party_licenses.mjs
