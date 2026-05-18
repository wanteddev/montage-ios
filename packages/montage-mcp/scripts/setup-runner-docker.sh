#!/usr/bin/env bash
# self-hosted runner(macOS) 에서 montage-mcp 배포에 필요한 Docker 환경을 멱등하게 셋업한다.
# - Colima (headless Linux VM)
# - docker CLI + buildx
# - linux/amd64 cross-build 용 QEMU binfmt
# - 전용 buildx builder
#
# 사용:
#   bash packages/montage-mcp/scripts/setup-runner-docker.sh
# 재실행해도 안전하다. 이미 설정된 항목은 skip 한다.

set -euo pipefail

log() { printf "\033[1;34m[setup]\033[0m %s\n" "$*"; }

if [[ "$(uname)" != "Darwin" ]]; then
  echo "이 스크립트는 macOS self-hosted runner 전용입니다." >&2
  exit 1
fi

# 1) Homebrew 확인
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew 가 설치되어 있지 않습니다. https://brew.sh 참고." >&2
  exit 1
fi

# 2) 필수 패키지 (idempotent)
for pkg in colima docker docker-buildx; do
  if brew list "$pkg" >/dev/null 2>&1; then
    log "$pkg already installed"
  else
    log "installing $pkg"
    brew install "$pkg"
  fi
done

# 3) docker-buildx plugin 등록 (brew 설치 시 자동 링크 안 되는 케이스 대응)
mkdir -p "$HOME/.docker/cli-plugins"
BUILDX_BIN="$(brew --prefix)/opt/docker-buildx/bin/docker-buildx"
if [[ ! -f "$BUILDX_BIN" ]]; then
  echo "docker-buildx 바이너리를 찾을 수 없습니다: $BUILDX_BIN" >&2
  exit 1
fi
if [[ ! -L "$HOME/.docker/cli-plugins/docker-buildx" ]]; then
  ln -sfn "$BUILDX_BIN" "$HOME/.docker/cli-plugins/docker-buildx"
  log "linked docker-buildx plugin"
fi

# 4) Colima 기동 — brew services 로 등록해 재부팅 후에도 자동 시작
if colima status >/dev/null 2>&1; then
  log "colima already running"
else
  log "starting colima (cpu=4, memory=8GB, disk=60GB)"
  colima start --cpu 4 --memory 8 --disk 60
fi
brew services start colima >/dev/null 2>&1 || true

# 5) docker daemon 응답 확인
if ! docker info >/dev/null 2>&1; then
  echo "docker daemon 에 연결할 수 없습니다. colima status 확인 필요." >&2
  exit 1
fi
log "docker daemon reachable: $(docker version --format '{{.Server.Version}}')"

# 6) 전용 buildx builder
if docker buildx inspect montage-builder >/dev/null 2>&1; then
  log "buildx builder 'montage-builder' already exists"
else
  log "creating buildx builder 'montage-builder'"
  docker buildx create --name montage-builder --use --bootstrap
fi
docker buildx use montage-builder

# 7) linux/amd64 cross-build 용 QEMU binfmt 등록
#    Apple Silicon 호스트에서 amd64 이미지를 빌드하려면 필수.
#    montage-builder 의 Platforms 라인을 검사해 정확히 linux/amd64 토큰이 있는지 확인.
if ! docker buildx inspect montage-builder --bootstrap \
      | awk -F': ' '/^Platforms:/ {print $2}' \
      | tr ',' '\n' | tr -d ' *' \
      | grep -qx 'linux/amd64'; then
  log "registering QEMU binfmt for linux/amd64"
  docker run --privileged --rm tonistiigi/binfmt --install amd64
fi

log "setup complete ✅"
