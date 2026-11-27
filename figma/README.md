# Figma Code Connect — SwiftUI

Figma 디자인시스템 파일([0-Component](https://www.figma.com/design/7RHtWV3Pw6I98UEDjbx5V1/0-Component))의 Dev Mode에 보이는 **SwiftUI 코드 스니펫**의 원본 템플릿입니다.
Web(React)은 `wanteddev/montage-web`의 `figma/`, Android(Compose)는 `wanteddev/android`의 `core/wanted-library-design-system/figma`에서 따로 관리합니다.

## 구성

| 경로 | 내용 |
|---|---|
| `figma.config.json` | 라벨(`SwiftUI`), 대상 파일, Figma URL 치환표(`<FIGMA_BUTTON>` 등) |
| `package.json`, `tsconfig.json` | Code Connect CLI 버전 고정(`@figma/code-connect` 2.1.1)과 템플릿 타입 체크 설정 |
| `swiftui/*.figma.ts` | 컴포넌트별 템플릿 (Figma variant → `Montage.*` 뷰 호출) |
| `swiftui/icons.figma.batch.*` | 아이콘 일괄 매핑. `.json`은 아이콘 동기화가 만든다([아이콘 batch](#아이콘-batch) 참고) |
| `shared/` | 템플릿 공통 헬퍼. Compose 템플릿과 함께 쓰던 파일을 그대로 가져와 Compose용 코드도 일부 남아 있습니다 |

`.figma.ts`는 SwiftPM 빌드 대상이 아니므로 라이브러리 빌드에 영향이 없습니다.

## 수정 → 확인 → 게시

이 폴더에서 실행합니다. Node.js가 필요합니다. CLI는 `package.json`에 고정한 버전을 씁니다. `@latest`는 실행할 때마다 버전이 바뀔 수 있어 parse 결과를 비교하기 어렵습니다.

```bash
npm install

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

## 아이콘 batch

`swiftui/icons.figma.batch.json`은 아이콘 노드와 `Icon` case를 잇는 목록입니다. **손으로 고치지 않습니다.** 아이콘 동기화가 `Icon.xcassets`, `Icon` enum과 함께 다시 만듭니다.

### 갱신 흐름

1. `/montage-icon-sync`(또는 Actions의 `Figma Icon Sync` 수동 실행)로 아이콘을 동기화합니다.
2. sync job(montage-web 재사용 워크플로)이 Figma API로 아이콘 SVG와 `output/result.json`을 받습니다.
3. `scripts/icon_sync.js`가 SVG로 에셋과 enum을 갱신하고, `result.json`으로 batch를 다시 만듭니다. 결과는 한 커밋에 같이 들어갑니다.
4. 동기화 PR이 머지되면 [게시](#수정--확인--게시)합니다. **게시는 자동이 아닙니다.** 게시 전에는 새 아이콘에 Dev Mode 스니펫이 나오지 않습니다.

### 노드 ID 출처

`result.json`의 `id`는 0-Component 파일 `Icon` 섹션(Normal, Color/Logo, Color/Normal, Navigation)의 **컴포넌트 세트** 노드 ID입니다. 탐색 경로는 montage-web `.github/workflows/figma-icon-sync.yml`의 `ROOT_TRAVERSE_*_IDS`에 있습니다. Figma에서 컴포넌트 세트를 선택하고 링크를 복사하면 URL의 `node-id`와 같습니다.

- 세트 하나에 아이콘이 여러 개면 노드 하나에 variant가 여러 개 붙습니다(예: `arrowDown`, `arrowDownThick`).
- 같은 아이콘이 세트 두 곳에 있으면 노드마다 항목이 생깁니다(예: `blankColor`).
- variant `name`은 Figma `Name` 속성 값이라 `Color` 접미사를 뗍니다. `component`는 `Icon` + 파스칼 케이스입니다.

`result.json`이 없거나 SVG 목록과 어긋나면 `icon_sync.js`는 파일을 하나도 바꾸지 않고 실패합니다.

### 검증

```bash
# 레포 루트에서: batch가 생성기 출력과 같은지, 이름이 Icon enum case와 1:1인지
npm test

# figma/에서: 템플릿 타입 체크와 parse (icons.figma.batch.json은 노드 수가 나옵니다. 아이콘 수와 다릅니다)
npm run typecheck
npm run parse
```

`npm test`는 CI에서 돌지 않습니다. batch나 `Icon` enum을 건드린 PR은 올리기 전에 로컬에서 직접 돌립니다. `Icon` enum에만 case를 손으로 넣으면 1:1 테스트가 실패합니다. 아이콘은 Figma에 올린 뒤 동기화로 추가합니다.

## 주의
- **`label`(`SwiftUI`)을 바꾸지 않습니다.** 바꾸면 같은 컴포넌트에 SwiftUI 스니펫이 두 벌 게시되고, Figma MCP가 `clientFrameworks: "swiftui"`로 스니펫을 고르지 못합니다.
- **내릴 때는 `--node`와 `--label`을 함께 씁니다.** 빼면 React·Compose 스니펫까지 지워질 수 있습니다.
  ```bash
  npx figma connect unpublish --node "<Figma 노드 URL>" --label SwiftUI
  ```
- 템플릿의 근거 주석에는 소스 줄 번호 대신 심볼 이름(`FilterButton.active(_:label:)` 등)을 적습니다. 줄 번호는 소스를 고칠 때마다 어긋납니다.
- 새 컴포넌트를 추가하면 `figma.config.json`의 `documentUrlSubstitutions`에 URL 키를 추가합니다.
- 일부 주석의 `docs/plans/...`는 디자인 쪽 작업 문서 경로입니다. 이 레포에는 없습니다.
