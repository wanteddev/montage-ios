#!/usr/bin/env bash
# TextArea fixed 리사이즈 + 바깥 ScrollView 중첩 시, 코드로 주입된 텍스트가 내부 스크롤되는지 검증한다.
# (WRP-2846 회귀 방지 E2E)
#
# 판정 방식: 스와이프 전/후 스크린샷을 영역별로 잘라 비교한다.
#   - TextArea 영역(세로 19~43%)은 달라져야 한다  → 내부가 스크롤됨
#   - Options 영역(세로 46~62%)은 같아야 한다     → 바깥 ScrollView가 움직이지 않음
#
# 사용법:
#   Tests/E2E/textarea-scroll/run.sh [--skip-build] [--udid <UDID>]
# 요구사항: Xcode, Maestro(~/.maestro/bin 또는 PATH), Java 17+ (Homebrew openjdk@21 자동 탐지)
# iPhone 시뮬레이터 레이아웃 기준 좌표를 사용한다.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"
BUNDLE_ID="com.wantedlab.Blueprint"
WORK="${TMPDIR:-/tmp}/montage-e2e-textarea-scroll"
DERIVED="$WORK/DerivedData"
SKIP_BUILD=0
UDID=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-build) SKIP_BUILD=1; shift ;;
    --udid) UDID="$2"; shift 2 ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

mkdir -p "$WORK"

# --- Java / Maestro -----------------------------------------------------------
export PATH="$HOME/.maestro/bin:$PATH"
if [[ -z "${JAVA_HOME:-}" ]]; then
  if JH="$(/usr/libexec/java_home -v 17+ 2>/dev/null)"; then
    export JAVA_HOME="$JH"
  else
    for c in /opt/homebrew/opt/openjdk@21 /opt/homebrew/opt/openjdk@17 /opt/homebrew/opt/openjdk; do
      if [[ -d "$c/libexec/openjdk.jdk/Contents/Home" ]]; then
        export JAVA_HOME="$c/libexec/openjdk.jdk/Contents/Home"; break
      fi
    done
  fi
fi
[[ -n "${JAVA_HOME:-}" ]] && export PATH="$JAVA_HOME/bin:$PATH"
command -v maestro >/dev/null || { echo "maestro가 없습니다. https://maestro.dev 참고" >&2; exit 2; }
java -version >/dev/null 2>&1 || { echo "Java 17+가 필요합니다 (brew install openjdk@21)" >&2; exit 2; }

# --- Simulator ----------------------------------------------------------------
if [[ -z "$UDID" ]]; then
  UDID="$(xcrun simctl list devices booted | grep -Eo '[0-9A-F-]{36}' | head -1 || true)"
fi
[[ -n "$UDID" ]] || { echo "부팅된 iOS 시뮬레이터가 없습니다. --udid로 지정하거나 먼저 부팅하세요." >&2; exit 2; }
echo "▶ simulator: $UDID"

# --- Build & install ----------------------------------------------------------
if [[ $SKIP_BUILD -eq 0 ]]; then
  echo "▶ building Blueprint..."
  xcodebuild -workspace "$ROOT/Montage.xcworkspace" -scheme Blueprint \
    -destination "id=$UDID" -derivedDataPath "$DERIVED" -configuration Debug build \
    2>&1 | grep -E "error:|BUILD (SUCCEEDED|FAILED)" || true
fi
APP="$(find "$DERIVED/Build/Products" -maxdepth 2 -name Blueprint.app | head -1 || true)"
[[ -n "$APP" ]] || { echo "Blueprint.app을 찾을 수 없습니다 (빌드 실패 또는 --skip-build 전 빌드 필요)" >&2; exit 2; }
xcrun simctl terminate "$UDID" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl install "$UDID" "$APP"

# --- Drive --------------------------------------------------------------------
snap() { xcrun simctl io "$UDID" screenshot "$1" >/dev/null 2>&1; }
# 상대 좌표(세로 %)로 스크린샷을 잘라 md5를 돌려준다.
crop_md5() { # file top% bottom%
  local f="$1" top="$2" bottom="$3"
  local w h y0 y1
  w="$(sips -g pixelWidth "$f" | awk '/pixelWidth/{print $2}')"
  h="$(sips -g pixelHeight "$f" | awk '/pixelHeight/{print $2}')"
  y0=$(( h * top / 100 )); y1=$(( h * bottom / 100 ))
  local x0=$(( w * 5 / 100 )) cw=$(( w * 90 / 100 ))
  local out="$WORK/$(basename "$f" .png)-$top-$bottom.png"
  sips --cropOffset "$y0" "$x0" -c $(( y1 - y0 )) "$cw" "$f" --out "$out" >/dev/null 2>&1
  md5 -q "$out"
}

echo "▶ setup flow (navigate → Fixed → inject)..."
maestro --device "$UDID" test "$HERE/setup.yaml" >"$WORK/setup.log" 2>&1 || { tail -30 "$WORK/setup.log"; exit 1; }
sleep 1
snap "$WORK/before.png"

echo "▶ swipe inside TextArea..."
maestro --device "$UDID" test "$HERE/swipe-up.yaml" >"$WORK/swipe.log" 2>&1 || { tail -30 "$WORK/swipe.log"; exit 1; }
sleep 1
snap "$WORK/after.png"

# --- Verify -------------------------------------------------------------------
inner_before="$(crop_md5 "$WORK/before.png" 19 43)"
inner_after="$(crop_md5 "$WORK/after.png" 19 43)"
outer_before="$(crop_md5 "$WORK/before.png" 46 62)"
outer_after="$(crop_md5 "$WORK/after.png" 46 62)"

status=0
if [[ "$inner_before" == "$inner_after" ]]; then
  echo "✗ TextArea 내부 텍스트가 스크롤되지 않았습니다 (isScrollEnabled 미적용 의심)"; status=1
else
  echo "✓ TextArea 내부 텍스트가 스크롤되었습니다"
fi
if [[ "$outer_before" != "$outer_after" ]]; then
  echo "✗ 바깥 ScrollView가 스크롤되었습니다 (외부 스크롤이 제스처를 가로챔)"; status=1
else
  echo "✓ 바깥 ScrollView는 움직이지 않았습니다"
fi

echo "스크린샷: $WORK/before.png, $WORK/after.png"
[[ $status -eq 0 ]] && echo "PASS" || echo "FAIL"
exit $status
