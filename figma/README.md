# Figma Code Connect — SwiftUI

Figma 디자인시스템 파일([0-Component](https://www.figma.com/design/7RHtWV3Pw6I98UEDjbx5V1/0-Component))의 Dev Mode에 보이는 **SwiftUI 코드 스니펫**의 원본 템플릿입니다.
Web(React)은 `wanteddev/montage-web`의 `figma/`, Android(Compose)는 `wanteddev/android`의 `core/wanted-library-design-system/figma`에서 따로 관리합니다.

## 구성

| 경로 | 내용 |
|---|---|
| `figma.config.json` | 라벨(`SwiftUI`), 대상 파일, Figma URL 치환표(`<FIGMA_BUTTON>` 등) |
| `swiftui/*.figma.ts` | 컴포넌트별 템플릿 (Figma variant → `Montage.*` 뷰 호출) |
| `swiftui/icons.figma.batch.*` | 아이콘 일괄 매핑 |
| `shared/` | 템플릿 공통 헬퍼. Compose 템플릿과 함께 쓰던 파일을 그대로 가져와 Compose용 코드도 일부 남아 있습니다 |

`.figma.ts`는 SwiftPM 빌드 대상이 아니므로 라이브러리 빌드에 영향이 없습니다.

## 수정 → 확인 → 게시

이 폴더에서 실행합니다. Node.js가 필요합니다.

```bash
# 1. 스니펫이 어떻게 나오는지 확인 (게시하지 않음)
npx -y @figma/code-connect@latest connect parse -c figma.config.json

# 2. 게시
FIGMA_ACCESS_TOKEN=<개인 토큰> npx -y @figma/code-connect@latest connect publish -c figma.config.json
```

게시에 필요한 것:
- Figma main 파일 편집 권한, Dev 또는 Full seat
- `Code Connect: Write` 범위의 개인 access token. 토큰은 커밋하지 않습니다.

## 주의
- **`label`(`SwiftUI`)을 바꾸지 않습니다.** 바꾸면 같은 컴포넌트에 SwiftUI 스니펫이 두 벌 게시되고, Figma MCP가 `clientFrameworks: "swiftui"`로 스니펫을 고르지 못합니다.
- **내릴 때는 `--node`와 `--label`을 함께 씁니다.** 빼면 React·Compose 스니펫까지 지워질 수 있습니다.
  ```bash
  npx -y @figma/code-connect@latest connect unpublish --node "<Figma 노드 URL>" --label SwiftUI
  ```
- 새 컴포넌트를 추가하면 `figma.config.json`의 `documentUrlSubstitutions`에 URL 키를 추가합니다.
- 일부 주석의 `docs/plans/...`는 디자인 쪽 작업 문서 경로입니다. 이 레포에는 없습니다.
