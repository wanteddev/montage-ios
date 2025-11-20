# GitHub 저장소 설정 가이드 / GitHub Repository Setup Guide

이 문서는 Montage 프로젝트의 GitHub 저장소를 설정하고 브랜치 보호 규칙을 구성하는 방법을 안내합니다.

*This guide explains how to set up the GitHub repository and configure branch protection rules for the Montage project.*

## 목차 / Table of Contents

1. [저장소 기본 설정](#1-저장소-기본-설정--1-basic-repository-settings)
2. [브랜치 보호 규칙 설정](#2-브랜치-보호-규칙-설정--2-branch-protection-rules)
3. [추가 권장 설정](#3-추가-권장-설정--3-additional-recommended-settings)

---

## 1. 저장소 기본 설정 / 1. Basic Repository Settings

### 1.1 저장소 설명 및 메타데이터 / Repository Description and Metadata

#### 저장소 설명 / Repository Description

1. GitHub 저장소 메인 페이지로 이동합니다.
2. 저장소 이름 옆에 있는 **✏️ 연필 아이콘**을 클릭합니다.
3. 설명을 입력합니다:
   ```
   Wanted Lab Design System for iOS - SwiftUI/UIKit UI Components Library
   ```
4. **Save** 버튼을 클릭합니다.

*1. Go to your GitHub repository main page.*
*2. Click the **✏️ pencil icon** next to the repository name.*
*3. Enter the description:*
   ```
   Wanted Lab Design System for iOS - SwiftUI/UIKit UI Components Library
   ```
*4. Click the **Save** button.*

#### Topics/태그 추가 / Add Topics

1. 저장소 메인 페이지에서 저장소 설명 아래의 **⚫⚫⚫ Add topics** 버튼을 클릭합니다.
2. 다음 태그들을 입력하고 **Enter**를 눌러 추가합니다:

*1. On the repository main page, click the **⚫⚫⚫ Add topics** button below the repository description.*
*2. Enter the following tags and press **Enter** to add them:*

- `swift`
- `swiftui`
- `uikit`
- `design-system`
- `ios`
- `ui-components`
- `wantedlab`
- `montage`

3. 모든 태그 추가 후 **Save changes** 버튼을 클릭합니다.

*3. After adding all tags, click the **Save changes** button.*

#### 저장소 웹사이트 URL / Repository Website URL

1. 저장소 메인 페이지에서 **⚙️ Settings** 버튼을 클릭합니다.
2. **General** 섹션으로 스크롤합니다.
3. **Features** 섹션에서 **Website** 필드에 다음 URL을 입력합니다:
   ```
   https://montage.wanted.co.kr
   ```
4. **Save changes** 버튼을 클릭합니다.

*1. On the repository main page, click the **⚙️ Settings** button.*
*2. Scroll to the **General** section.*
*3. In the **Features** section, enter the following URL in the **Website** field:*
   ```
   https://montage.wanted.co.kr
   ```
*4. Click the **Save changes** button.*

#### 저장소 소셜 미리보기 이미지 / Social Preview Image

1. 저장소 메인 페이지에서 **⚙️ Settings** 버튼을 클릭합니다.
2. **General** 섹션으로 스크롤합니다.
3. **Social preview** 섹션에서 **Upload an image** 버튼을 클릭합니다.
4. 저장소를 대표하는 이미지를 업로드합니다 (권장 크기: 1280x640px).
5. 이 이미지는 소셜 미디어 공유 시 표시됩니다.

*1. On the repository main page, click the **⚙️ Settings** button.*
*2. Scroll to the **General** section.*
*3. In the **Social preview** section, click the **Upload an image** button.*
*4. Upload an image representing the repository (recommended size: 1280x640px).*
*5. This image will be displayed when sharing on social media.*

### 1.2 기능 활성화 / Feature Activation

**Settings > General** 섹션에서 다음 기능들을 활성화합니다:

*In **Settings > General**, enable the following features:*

- ✅ **Issues** - 이슈 트래킹 활성화
- ✅ **Projects** - 프로젝트 보드 사용 (선택사항)
- ✅ **Wiki** - 위키 사용 (선택사항, 일반적으로 비활성화 권장)
- ✅ **Discussions** - 토론 기능 사용 (선택사항)
- ✅ **Sponsorships** - 스폰서십 표시 (선택사항)

*- ✅ **Issues** - Enable issue tracking*
*- ✅ **Projects** - Use project boards (optional)*
*- ✅ **Wiki** - Use wiki (optional, generally recommended to disable)*
*- ✅ **Discussions** - Use discussions (optional)*
*- ✅ **Sponsorships** - Show sponsorships (optional)*

### 1.3 기본 브랜치 설정 / Default Branch Settings

**Settings > Branches** 섹션에서:

*In **Settings > Branches**:*

1. **Default branch**를 `main`으로 설정합니다.
2. 필요시 기본 브랜치 이름을 변경할 수 있습니다.

*1. Set **Default branch** to `main`.*
*2. You can change the default branch name if needed.*

---

## 2. 브랜치 보호 규칙 설정 / 2. Branch Protection Rules

브랜치 보호 규칙은 중요한 브랜치(예: `main`)를 보호하여 실수로 인한 문제를 방지합니다.

*Branch protection rules protect important branches (e.g., `main`) from accidental issues.*

### 2.1 기본 브랜치 보호 규칙 생성 / Create Branch Protection Rule

1. **Settings > Branches**로 이동합니다.
2. **Branch protection rules** 섹션에서 **Add rule** 버튼을 클릭합니다.
3. **Branch name pattern**에 `main`을 입력합니다.

*1. Go to **Settings > Branches**.*
*2. In the **Branch protection rules** section, click **Add rule**.*
*3. Enter `main` in the **Branch name pattern**.*

### 2.2 보호 규칙 옵션 설정 / Configure Protection Options

다음 옵션들을 활성화합니다:

*Enable the following options:*

#### 필수 옵션 / Required Options

- ✅ **Require a pull request before merging**
  - ✅ **Require approvals**: `1` (최소 1명의 승인 필요)
  - ✅ **Dismiss stale pull request approvals when new commits are pushed**
  - ✅ **Require review from Code Owners** (CODEOWNERS 파일이 있는 경우)
  - ✅ **Require status checks to pass before merging**
    - ✅ **Require branches to be up to date before merging**
    - CI/CD 워크플로우를 선택합니다 (예: `ci.yml`, `docs.yml`)

*- ✅ **Require a pull request before merging***
  - *✅ **Require approvals**: `1` (minimum 1 approval required)*
  - *✅ **Dismiss stale pull request approvals when new commits are pushed***
  - *✅ **Require review from Code Owners** (if CODEOWNERS file exists)*
  - *✅ **Require status checks to pass before merging***
    - *✅ **Require branches to be up to date before merging***
    - *Select CI/CD workflows (e.g., `ci.yml`, `docs.yml`)*

#### 추가 권장 옵션 / Additional Recommended Options

- ✅ **Require conversation resolution before merging**
  - PR의 모든 대화가 해결되어야 머지 가능
- ✅ **Require linear history**
  - 선형 히스토리 유지 (선택사항, 팀 정책에 따라)
- ✅ **Require signed commits** (선택사항)
  - 서명된 커밋만 허용
- ✅ **Require lock branch**
  - 브랜치 잠금 (필요시 수동으로 잠금)
- ✅ **Do not allow bypassing the above settings**
  - 관리자도 위 규칙을 우회할 수 없도록 설정

*- ✅ **Require conversation resolution before merging***
  - *All conversations in PR must be resolved before merging*
*- ✅ **Require linear history** (optional, depends on team policy)*
  - *Maintain linear history*
*- ✅ **Require signed commits** (optional)*
  - *Only allow signed commits*
*- ✅ **Require lock branch***
  - *Lock branch (lock manually when needed)*
*- ✅ **Do not allow bypassing the above settings***
  - *Even administrators cannot bypass these rules*

#### 비활성화할 옵션 / Options to Disable

- ❌ **Allow force pushes**
- ❌ **Allow deletions**

*- ❌ **Allow force pushes***
*- ❌ **Allow deletions***

### 2.3 설정 예시 / Configuration Example

```
Branch name pattern: main

✅ Require a pull request before merging
   ✅ Require approvals: 1
   ✅ Dismiss stale pull request approvals when new commits are pushed
   ✅ Require review from Code Owners
   ✅ Require status checks to pass before merging
      ✅ Require branches to be up to date before merging
      Selected status checks:
        - ci.yml
        - docs.yml
   ✅ Require conversation resolution before merging
   ✅ Do not allow bypassing the above settings

❌ Allow force pushes
❌ Allow deletions
```

### 2.4 추가 브랜치 보호 규칙 (선택사항) / Additional Branch Protection Rules (Optional)

개발 브랜치나 릴리스 브랜치에도 보호 규칙을 추가할 수 있습니다:

*You can add protection rules for development or release branches:*

- **개발 브랜치** (예: `develop`)
  - PR 필수, 승인 1명, 상태 체크 필수
- **릴리스 브랜치** (예: `release/*`)
  - PR 필수, 승인 2명, 상태 체크 필수, Code Owner 승인 필수

*- **Development branch** (e.g., `develop`)*
  - *PR required, 1 approval, status checks required*
*- **Release branch** (e.g., `release/*`)*
  - *PR required, 2 approvals, status checks required, Code Owner approval required*

---

## 3. 추가 권장 설정 / 3. Additional Recommended Settings

### 3.1 Actions 설정 / Actions Settings

**Settings > Actions > General**에서:

*In **Settings > Actions > General**:*

- ✅ **Allow all actions and reusable workflows**
- ✅ **Allow actions created by GitHub**
- ✅ **Allow Marketplace actions by verified creators**
- ✅ **Allow actions by select actions and reusable workflows** (더 엄격한 정책 원하는 경우)

*- ✅ **Allow all actions and reusable workflows***
*- ✅ **Allow actions created by GitHub***
*- ✅ **Allow Marketplace actions by verified creators***
*- ✅ **Allow actions by select actions and reusable workflows** (if you want stricter policy)*

### 3.2 Secrets 및 Variables / Secrets and Variables

**Settings > Secrets and variables > Actions**에서:

*In **Settings > Secrets and variables > Actions**:*

필요한 시크릿을 추가합니다 (예: 배포 키, API 토큰 등)

*Add necessary secrets (e.g., deployment keys, API tokens, etc.)*

### 3.3 Pages 설정 (문서 사이트용) / Pages Settings (for Documentation Site)

**Settings > Pages**에서:

*In **Settings > Pages**:*

- **Source**: GitHub Actions를 선택
- 문서 사이트를 자동으로 배포하는 워크플로우가 있는 경우 활성화

*- **Source**: Select GitHub Actions*
*- Enable if you have a workflow that automatically deploys the documentation site*

### 3.4 Security 설정 / Security Settings

**Settings > Security**에서:

*In **Settings > Security**:*

- ✅ **Dependabot alerts** 활성화
- ✅ **Dependabot security updates** 활성화
- ✅ **Private vulnerability reporting** 활성화 (SECURITY.md 파일이 있으면 자동 활성화)

*- ✅ Enable **Dependabot alerts***
*- ✅ Enable **Dependabot security updates***
*- ✅ Enable **Private vulnerability reporting** (automatically enabled if SECURITY.md exists)*

### 3.5 Collaborators 및 Teams / Collaborators and Teams

**Settings > Collaborators** 또는 **Settings > Teams**에서:

*In **Settings > Collaborators** or **Settings > Teams**:*

- 프로젝트 메인테이너 및 기여자 권한 설정
- CODEOWNERS 파일과 연동하여 코드 리뷰 권한 관리

*- Set permissions for project maintainers and contributors*
*- Manage code review permissions in conjunction with CODEOWNERS file*

---

## 체크리스트 / Checklist

저장소 설정 완료 후 다음을 확인하세요:

*After completing the repository setup, verify the following:*

### 기본 설정 / Basic Settings
- [ ] 저장소 설명 작성
- [ ] Topics/태그 추가
- [ ] 웹사이트 URL 설정
- [ ] 소셜 미리보기 이미지 업로드
- [ ] Issues 활성화

*- [ ] Repository description added*
*- [ ] Topics/tags added*
*- [ ] Website URL set*
*- [ ] Social preview image uploaded*
*- [ ] Issues enabled*

### 브랜치 보호 / Branch Protection
- [ ] main 브랜치 보호 규칙 생성
- [ ] PR 필수 설정
- [ ] 승인 1명 이상 필수 설정
- [ ] 상태 체크 필수 설정
- [ ] Code Owner 승인 필수 설정 (CODEOWNERS 파일 있는 경우)
- [ ] Force push 비활성화
- [ ] 브랜치 삭제 비활성화

*- [ ] Branch protection rule created for main*
*- [ ] PR required*
*- [ ] Minimum 1 approval required*
*- [ ] Status checks required*
*- [ ] Code Owner approval required (if CODEOWNERS file exists)*
*- [ ] Force push disabled*
*- [ ] Branch deletion disabled*

### 보안 설정 / Security Settings
- [ ] Dependabot alerts 활성화
- [ ] Dependabot security updates 활성화
- [ ] Private vulnerability reporting 활성화

*- [ ] Dependabot alerts enabled*
*- [ ] Dependabot security updates enabled*
*- [ ] Private vulnerability reporting enabled*

---

## 참고 자료 / References

- [GitHub Branch Protection Rules Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Repository Settings Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features)
- [GitHub CODEOWNERS Documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)

---

## 문제 해결 / Troubleshooting

### 브랜치 보호 규칙이 적용되지 않는 경우 / Branch Protection Rule Not Applied

1. 브랜치 이름 패턴이 정확한지 확인 (대소문자 구분)
2. 저장소 관리자 권한이 있는지 확인
3. 규칙 저장 후 브랜치에 실제로 적용되는지 확인

*1. Verify the branch name pattern is correct (case-sensitive)*
*2. Check if you have repository administrator permissions*
*3. Verify the rule is actually applied to the branch after saving*

### 상태 체크가 표시되지 않는 경우 / Status Checks Not Appearing

1. CI/CD 워크플로우가 최소 한 번 실행되었는지 확인
2. 워크플로우 파일이 올바른 경로에 있는지 확인 (`.github/workflows/`)
3. 워크플로우가 올바르게 실행되고 있는지 확인

*1. Verify the CI/CD workflow has run at least once*
*2. Check if the workflow file is in the correct path (`.github/workflows/`)*
*3. Verify the workflow is running correctly*

---

이 가이드를 따라 설정하면 Montage 프로젝트의 GitHub 저장소가 안전하고 체계적으로 관리될 수 있습니다.

*By following this guide, you can set up the GitHub repository for the Montage project in a safe and organized manner.*

