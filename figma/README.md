# Figma Code Connect — SwiftUI

Figma 디자인시스템 파일([0-Component](https://www.figma.com/design/7RHtWV3Pw6I98UEDjbx5V1/0-Component))의 Dev Mode에 보이는 **SwiftUI 코드 스니펫**의 원본 템플릿입니다.
Web(React)은 `wanteddev/montage-web`의 `figma/`, Android(Compose)는 `wanteddev/android`의 `core/wanted-library-design-system/figma`에서 따로 관리합니다.

## 구성

| 경로 | 내용 |
|---|---|
| `figma.config.json` | 라벨(`SwiftUI`), 대상 파일, Figma URL 치환표(`<FIGMA_BUTTON>` 등) |
| `package.json`, `package-lock.json`, `tsconfig.json` | Code Connect CLI 버전 고정(`@figma/code-connect` 2.1.1, 하위 의존성은 lock)과 템플릿 타입 체크 설정 |
| `swiftui/*.figma.ts` | 컴포넌트별 템플릿 (Figma variant → `Montage.*` 뷰 호출) |
| `swiftui/icons.figma.batch.*` | 아이콘 일괄 매핑 |
| `shared/` | 템플릿 공통 헬퍼 |

`.figma.ts`는 SwiftPM 빌드 대상이 아니므로 라이브러리 빌드에 영향이 없습니다.

## 수정 → 확인 → 게시

이 폴더에서 실행합니다. Node.js가 필요합니다. CLI와 하위 의존성은 `package-lock.json`에 고정한 버전을 쓰므로 `npm ci`로 설치합니다. `npm install`은 lock을 다시 쓸 수 있고, `@latest`는 실행할 때마다 버전이 바뀌어 parse 결과를 비교하기 어렵습니다. 의존성을 올릴 때만 `npm install`로 lock을 갱신해 함께 커밋합니다.

```bash
npm ci

# 1. 템플릿 타입 체크
npm run typecheck

# 2. 스니펫이 어떻게 나오는지 확인 (게시하지 않음)
npm run parse

# 3. 게시 전 점검 (게시하지 않음)
FIGMA_ACCESS_TOKEN=<개인 토큰> npm run publish:dry-run

# 4. 게시
FIGMA_ACCESS_TOKEN=<개인 토큰> npx figma connect publish -c figma.config.json
```

게시에 필요한 것:
- Figma main 파일 편집 권한, Dev 또는 Full seat
- `Code Connect: Write` 범위의 개인 access token. 토큰은 커밋하지 않습니다.

## 주의
- **`label`(`SwiftUI`)을 바꾸지 않습니다.** 바꾸면 같은 컴포넌트에 SwiftUI 스니펫이 두 벌 게시되고, Figma MCP가 `clientFrameworks: "swiftui"`로 스니펫을 고르지 못합니다.
- **내릴 때는 `--node`와 `--label`을 함께 씁니다.** 빼면 React·Compose 스니펫까지 지워질 수 있습니다.
  ```bash
  npx figma connect unpublish --node "<Figma 노드 URL>" --label SwiftUI
  ```
- 템플릿의 근거 주석에는 소스 줄 번호 대신 심볼 이름(`FilterButton.active(_:label:)` 등)을 적습니다. 줄 번호는 소스를 고칠 때마다 어긋납니다.
- 새 컴포넌트를 추가하면 `figma.config.json`의 `documentUrlSubstitutions`에 URL 키를 추가합니다.
- 일부 주석의 `docs/plans/...`는 디자인 쪽 작업 문서 경로입니다. 이 레포에는 없습니다.
