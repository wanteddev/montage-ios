# 보안 정책 / Security Policy

## 지원되는 버전 / Supported Versions

현재 지원 중인 버전의 보안 업데이트를 제공합니다. 일반적으로 최신 메이저 버전의 모든 마이너 및 패치 버전에 대해 보안 업데이트를 제공합니다.

*Security updates are provided for the following versions. Generally, security updates are provided for all minor and patch versions of the latest major version.*

| 버전 / Version | 지원 여부 / Supported          |
| -------------- | ------------------------------ |
| 3.x            | :white_check_mark: 지원 / Yes  |
| < 3.0          | :x: 미지원 / No                |

**참고**: 새로운 메이저 버전이 출시되면 이전 메이저 버전에 대한 지원 정책이 변경될 수 있습니다. 자세한 내용은 릴리스 노트를 참고하세요.

***Note**: When a new major version is released, the support policy for previous major versions may change. Please refer to the release notes for details.*

## 취약점 신고 / Reporting a Vulnerability

**중요**: 보안 취약점을 발견하셨다면, **공개 이슈를 생성하지 마세요**. 아래의 비공개 방법으로만 신고해 주세요.

***Important**: If you discover a security vulnerability, **do not create a public issue**. Please report it only through the private methods below.*

### 신고 방법 / How to Report

1. **GitHub Security Advisory 사용 (권장)**
   - 저장소의 "Security" 탭으로 이동
   - "Report a vulnerability" 버튼 클릭
   - 취약점에 대한 상세 정보 제공
   - 이 방법은 비공개로 처리되며, 프로젝트 메인테이너만 확인할 수 있습니다

2. **프로젝트 메인테이너에게 직접 연락**
   - GitHub 프로필을 통해 직접 연락하거나
   - 저장소의 메인테이너에게 비공개로 연락해 주세요

*1. **Using GitHub Security Advisory (Recommended)***
   - *Go to the "Security" tab in the repository*
   - *Click "Report a vulnerability" button*
   - *Provide detailed information about the vulnerability*
   - *This method is handled privately and only project maintainers can see it*

*2. **Contact Project Maintainers Directly***
   - *Contact through GitHub profiles or*
   - *Reach out to repository maintainers privately*

### 신고 시 포함할 정보 / Information to Include

다음 정보를 포함해 주시면 더 빠르게 대응할 수 있습니다:

*Please include the following information to help us respond more quickly:*

- 취약점의 유형 및 설명 / *Type and description of the vulnerability*
- 취약점을 재현하는 단계 / *Steps to reproduce the vulnerability*
- 잠재적 영향 / *Potential impact*
- 제안하는 해결 방법 (있는 경우) / *Suggested fix (if any)*
- 취약점을 발견한 버전 / *Version where the vulnerability was discovered*

### 대응 프로세스 / Response Process

1. **신고 접수 확인**: 48시간 이내에 신고 접수를 확인하고 답변드립니다.
2. **초기 평가**: 취약점의 심각도와 영향 범위를 평가합니다.
3. **수정 작업**: 필요한 경우 수정 작업을 진행합니다.
4. **패치 배포**: 수정 사항이 포함된 새 버전을 배포합니다.
5. **공개 공지**: 취약점이 해결된 후 적절한 시점에 공개 공지를 게시합니다.

*1. **Acknowledgment**: We will acknowledge receipt of your report within 48 hours.*
*2. **Initial Assessment**: We will assess the severity and scope of the vulnerability.*
*3. **Fix Development**: If necessary, we will work on a fix.*
*4. **Patch Release**: We will release a new version containing the fix.*
*5. **Public Disclosure**: We will make a public announcement at an appropriate time after the vulnerability is resolved.*

### 신고자 감사 / Recognition

보안 취약점을 신고해 주신 분께 감사드리며, 원하시는 경우 릴리스 노트에 기여자로 명시해 드릴 수 있습니다.

*We appreciate your efforts to report security vulnerabilities. If you wish, we can acknowledge your contribution in the release notes.*

## 보안 모범 사례 / Security Best Practices

Montage를 사용할 때 다음 보안 모범 사례를 따르는 것을 권장합니다:

*We recommend following these security best practices when using Montage:*

- 최신 버전 사용: 항상 최신 안정 버전을 사용하세요.
- 의존성 업데이트: 정기적으로 의존성을 업데이트하세요.
- 코드 리뷰: 프로덕션 배포 전 코드 리뷰를 수행하세요.
- 최소 권한 원칙: 필요한 최소한의 권한만 부여하세요.

*- Use the latest version: Always use the latest stable version.*
*- Update dependencies: Regularly update your dependencies.*
*- Code review: Perform code reviews before production deployment.*
*- Principle of least privilege: Grant only the minimum necessary permissions.*

## 보안 업데이트 알림 / Security Update Notifications

보안 업데이트가 있을 경우 다음 방법으로 알림을 받을 수 있습니다:

*You can receive notifications about security updates through the following methods:*

- GitHub의 "Watch" 기능을 사용하여 저장소를 구독하세요.
- GitHub Releases를 확인하여 새 버전을 확인하세요.

*- Use GitHub's "Watch" feature to subscribe to the repository.*
*- Check GitHub Releases to see new versions.*

## 문의 / Contact

보안 취약점이 아닌 일반적인 보안 관련 문의사항(예: 보안 모범 사례, 설정 방법 등)은 [이슈](https://github.com/wanteddev/montage-ios/issues)를 통해 문의하실 수 있습니다.

*For general security-related inquiries (e.g., security best practices, configuration methods, etc.) that are not security vulnerabilities, you can contact us through [issues](https://github.com/wanteddev/montage-ios/issues).*

**다시 한 번 강조**: 보안 취약점은 공개 이슈가 아닌 위의 비공개 방법으로만 신고해 주세요.

***Reminder**: Security vulnerabilities must be reported only through the private methods above, not through public issues.*

