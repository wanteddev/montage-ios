#!/bin/bash

# DocC 아카이브 경로
DOCC_ARCHIVE="docs"

# 서버 실행
echo "DocC 아카이브 서버를 시작합니다..."
echo "접속 URL: http://localhost:8000/documentation/montage"
echo "서버를 종료하려면 Ctrl+C를 누르세요."
echo "----------------------------------------"

python3 -m http.server --directory "$DOCC_ARCHIVE"
