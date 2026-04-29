# Getting Started

This guide covers development environment setup and local documentation hosting for Montage.

## Requirements

| Requirement | Version |
|-------------|---------|
| iOS         | 16.0+   |
| Swift       | 5       |
| Xcode       | 16.2+   |

## Installation

### Swift Package Manager

In Xcode, select **File > Add Packages...** and enter the following URL:

```
https://github.com/wanteddev/montage-ios.git
```

Or add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/wanteddev/montage-ios.git", from: "3.0.0")
]
```

Then import Montage in your Swift files:

```swift
import Montage
```

## Sample App

We provide a Blueprint sample app to showcase the various components and usage examples offered by Montage. Please refer to the [Sources/Blueprint](https://github.com/wanteddev/montage-ios/tree/main/Sources/Blueprint) folder.

## Local Documentation

Design and API guides are available on the [Montage](https://montage.wanted.co.kr) site's [Components](https://montage.wanted.co.kr/docs/components) and [Utilities](https://montage.wanted.co.kr/docs/utilities) pages.

To host the documentation site locally, run the following and follow the instructions:

```bash
make docc
```

## Documentation Generation

When modifying Swift files under `Sources/Montage`, you need to regenerate the documentation before committing:

```bash
make
```

This runs the following steps in order:

1. **DocC** - Generates API documentation from source code
2. **Markdown** - Converts DocC output to Markdown
3. **License** - Generates third-party license documentation
4. **Check** - Verifies documentation is up to date

If there are changes in the `documentation/` folder or `THIRD_PARTY_LICENSES.md`, include them in your commit.

For guidelines on writing documentation comments in source code, please refer to the [Documentation Guidelines](./DOCUMENTATION_GUIDELINES.md).
