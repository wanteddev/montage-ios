# Contributing to Montage

Thank you for your interest in contributing to Montage. This guide will help you get started.

Montage is an open source project and welcomes all contributions. However, it is primarily maintained and distributed according to the design specifications defined by the Wanted Design System team. Contributions that deviate from these design specifications may be rejected.

## Prerequisites

- iOS 16.0+
- Swift 5
- Xcode 16.2+

## Development Setup

1. Fork and clone the repository:

```bash
git clone https://github.com/<your-username>/montage-ios.git
cd montage-ios
```

2. Open the workspace in Xcode:

```bash
open Montage.xcworkspace
```

3. Build and run the Blueprint sample app to explore available components.

## Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/). Each commit message should be structured as:

```txt
<type>(<scope>): <description>
```

**Types:**

- `feat` - A new feature
- `fix` - A bug fix
- `docs` - Documentation changes
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

## Pull Request Process

1. Create a new branch from `main`:

```bash
git checkout -b feature/your-feature
```

2. Make your changes and commit following the commit convention above.
3. Run the documentation/license update script:

```bash
make
```

4. If there are changes in the `documentation/` folder or `THIRD_PARTY_LICENSES.md`, include them in your commit.
5. Push your branch and open a Pull Request against `main`.
6. Fill out the PR template and ensure all checks pass.
7. A maintainer will review your PR and may request changes.

> **Please check before submitting a PR**
>
> - Contributions that deviate from the design specifications defined by the Wanted Design System team may be rejected.
> - PRs that modify workflow yml files may be rejected.
> - The `verify-docs` workflow runs only when Swift files are modified. If it fails, run `make` locally and include the generated outputs.
> - The `./generate_docc.sh` script executed by `make` produces different results depending on the Xcode version, so the Xcode version specified by `XCODE_VERSION` in the Makefile must be used to generate docc documentation. The `make` script may install that version accordingly.

## Code Style

- Follow the Swift style guide.
- Add documentation comments to public functions, structs, classes, protocols, etc. For more details, please refer to the [DOCUMENTATION_GUIDELINES.md](./DOCUMENTATION_GUIDELINES.md) file.
  - The file name must match the name of the main component (UIView, View, ViewModifier, Layout, etc.) declared in the file.
  - Types, extensions, protocols, etc. related to the main component should be defined in the same file as a general rule.
  - Public View structs should not be defined as Inner Types.

## Reporting Issues

- **Bug Reports** - Use the [Bug Report](https://github.com/wanteddev/montage-ios/issues/new?template=bug_report.md) template
- **Feature Requests** - Use the [Feature Request](https://github.com/wanteddev/montage-ios/issues/new?template=feature_request.md) template
- **Questions** - Use the [Question](https://github.com/wanteddev/montage-ios/issues/new?template=question.md) template

## External Contributor Review Guide (For Internal Developers)

When reviewing Pull Requests from external contributors, please check the following:

### Label Management
- External contributors do not have permission to change labels, so the labeler workflow will not run.
- **Reviewers must manually add labels**.

### Workflow Approval
- Workflow execution for external contributor PRs requires reviewer approval for security reasons.
- **Before approving workflow execution, verify that there are no modifications to workflow yml files**.
- This is because secrets or variables could be leaked through yml modifications.

### Target Branch Change
- Depending on internal work progress, you may request a target branch change to an appropriate branch matching the version for which the external contribution is intended.

## License

By contributing to Montage, you agree that your contributions will be licensed under the [MIT License](./LICENSE).
