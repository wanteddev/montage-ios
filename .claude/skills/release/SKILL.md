---
name: montage-release
description: Montage GitHub Release 생성 및 취소 (릴리즈/태그 관리, Slack 알림)
---

# Montage Release

Montage 디자인 시스템(wanteddev/montage-ios)의 GitHub Release를 생성하거나 취소합니다.

## 입력

$ARGUMENTS

## 0단계 — 액션 선택

- `$ARGUMENTS`에 "취소" 또는 "cancel"이 포함되면 → **릴리즈 취소 플로우**로 진입
- 그 외 → **릴리즈 생성 플로우**로 진입

---

## [릴리즈 생성 플로우]

### 1단계 — 버전 선택

1. `gh release list --repo wanteddev/montage-ios --limit 1`로 최신 버전(latest) 확인
2. `$ARGUMENTS`에 버전(`v`로 시작)이 있으면 사용, 없으면 AskUserQuestion으로 bump 유형 질문:
   - Patch (v3.3.1 → v3.3.2)
   - Minor (v3.3.1 → v3.4.0)
   - Major (v3.3.1 → v4.0.0)
   - Other (직접 입력)
3. **버전 입력 검증**: 입력된 버전이 semver 형식(`v{major}.{minor}.{patch}`)인지 확인. `v` 접두사가 없으면 자동 추가. 형식이 잘못되면 재입력 요청

### 2단계 — Release 브랜치 확인

`git ls-remote --heads origin release/{version_without_v}`로 release 브랜치 존재 여부 확인

- **브랜치 있음**:
  1. `gh pr list --repo wanteddev/montage-ios --head release/{version_without_v} --base main`으로 PR 상태 확인
  2. PR이 이미 merged → 3단계(릴리즈 생성)로 진행
  3. PR이 open → PR URL을 알려주고 "PR이 머지된 후 다시 실행해주세요." 안내 후 **중단**
  4. PR 없음 → PR 생성(`release/{ver} → main`) 후 **중단**
- **브랜치 없음** → main에서 릴리즈할지 AskUserQuestion으로 확인. 거부 시 중단

### 3단계 — GitHub Release 생성

1. **`--latest` 플래그 조건부 적용**: 선택한 버전이 현재 latest 버전보다 높은 경우에만 `--latest` 추가. 낮은 버전(hotfix 등)이면 `--latest` 생략
2. `gh release create {version} --repo wanteddev/montage-ios --target main --generate-notes [--latest] --title "{version}"`
3. `gh release view {version} --repo wanteddev/montage-ios --json url,body`로 릴리즈 URL과 body 가져오기

### 4단계 — Slack 알림

1. Slack MCP 사용 가능 여부 확인 (`mcp__plugin_slack_slack__slack_send_message` 도구 존재 여부)
2. **사용 불가 시**: "Slack MCP가 설정되어 있지 않습니다. 아래 명령어로 설정해주세요:" 안내 후 메시지 텍스트 출력
   ```
   claude plugin add slack
   ```
3. **사용 가능 시**:
   - body를 Slack standard markdown으로 변환하여 **메시지 미리보기를 사용자에게 표시**
   - AskUserQuestion으로 확인: "아래 메시지를 #design_system_updates, #ios-developers 채널에 발송할까요?"
     - 옵션: "발송", "수정 후 발송", "발송하지 않음"
   - 확인 후 두 채널에 발송:
     - `C068KCRS2LD` (#design_system_updates)
     - `C0136G84N87` (#ios-developers)

**메시지 형식**:
```
:appleinc:**Montage {version} Release 되었습니다.**
{release_url}

**What's Changed**
• {changes... (PR 링크는 [#번호](url) 형식으로 변환)}

Full Changelog: [{old_version}...{new_version}]({compare_url})
```

---

## [릴리즈 취소 플로우]

### 1단계 — 취소할 버전 선택

1. `gh release list --repo wanteddev/montage-ios --limit 5`로 최근 릴리즈 목록 표시
2. `$ARGUMENTS`에 버전이 있으면 사용, 없으면 AskUserQuestion으로 취소할 버전 선택
   - 최근 5개 릴리즈를 옵션으로 제시

### 2단계 — 경고 및 확인

AskUserQuestion으로 경고 메시지 표시:
- 질문: "`{version}` 릴리즈를 취소하면 해당 태그와 릴리즈가 모두 삭제됩니다. 이미 이 버전을 의존성으로 사용 중인 프로젝트가 있다면 빌드가 깨질 수 있습니다. 정말 취소하시겠습니까?"
- 옵션: "취소 진행", "중단"
- "중단" 선택 시 작업 종료

### 3단계 — 릴리즈 및 태그 삭제

1. `gh release delete {version} --repo wanteddev/montage-ios --yes`로 릴리즈 삭제
2. `git push origin --delete {version}`으로 원격 태그 삭제
3. **latest 복원**: 삭제한 버전이 latest였으면, 이전 릴리즈를 latest로 설정
   - `gh release list --repo wanteddev/montage-ios --limit 1`로 현재 최신 확인
   - `gh release edit {prev_version} --repo wanteddev/montage-ios --latest`

### 4단계 — Slack 취소 알림

1. Slack MCP 사용 가능 여부 확인 (생성 플로우와 동일한 방식)
2. 두 채널에 취소 메시지 발송 (미리보기 없이 바로 발송):
   - `C068KCRS2LD` (#design_system_updates)
   - `C0136G84N87` (#ios-developers)

**메시지 형식**:
```
:warning:**Montage {version} 릴리즈가 취소되었습니다.**
해당 버전의 태그와 릴리즈가 삭제되었습니다.
```
