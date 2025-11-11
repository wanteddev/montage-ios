# Montage 코드 문서화 가이드라인 (Montage Code Documentation Guidelines)

이 문서는 `docc_to_md.js` 스크립트가 올바르게 동작하기 위해 Montage 코드 작성 시 준수해야 할 사항들을 정리합니다.

*This document outlines the requirements that must be followed when writing Montage code for the `docc_to_md.js` script to work correctly.*

## 1. 접근 제어자 (Access Control)
### ⚠️ 필수: `public` 키워드 사용 (Required: Use `public` Keyword)

**문제점 (Issues):**

- 스크립트는 정규식으로 `public` 키워드를 찾아 타입과 멤버를 인식합니다.
- `public`이 없으면 문서화되지 않습니다.

<!-- -->

- *The script uses regular expressions to find the `public` keyword to recognize types and members.*
- *Without `public`, items will not be documented.*

**영향받는 코드 (Affected Code):**
```swift
// ❌ Not documented
struct MyComponent {
    func myMethod() { }
}

// ✅ Documented
public struct MyComponent {
    public func myMethod() { }
}
```

**참고 코드 (Reference Code):**

```javascript 868:873:Projects/Views/Montage/docc_to_md.js
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
        let match;
        while ((match = typeRegex.exec(content)) !== null) {
          const typeName = match[2];
          swiftFileMap[typeName] = relBase;
        }
```

```javascript 601:608:Projects/Views/Montage/docc_to_md.js
    const funcRegex = /public\s+(?:(static|class|mutating|nonmutating)\s+)?func\s+([^\{]+)/g;
    let result;
    while ((result = funcRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} func` : 'func';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }
```

## 2. 파일명과 타입명 매핑 (Filename and Type Name Mapping)

### ⚠️ 주의: 파일명이 컴포넌트 제목으로 사용됨 (Note: Filename Used as Component Title)

**문제점 (Issues):**

- 파일명(`.swift` 제거)이 컴포넌트 제목으로 사용됩니다.
- 파일 내부의 타입명과 파일명이 다르면 매핑이 복잡해질 수 있습니다.

<!-- -->

- *The filename (without `.swift`) is used as the component title.*
- *If the type name inside the file differs from the filename, mapping can become complex.*

**권장사항 (Recommendations):**

- 파일명과 주요 타입명을 일치시키세요.
- 예: `Button.swift` → `public struct Button`

<!-- -->

- *Match the filename with the main type name.*
- *Example: `Button.swift` → `public struct Button`*

**참고 코드 (Reference Code):**

```javascript 857:862:Projects/Views/Montage/docc_to_md.js
      // Filename-based mapping (keep existing logic)
      const componentTitle = file.replace(/\.swift$/, '');
      swiftFileMap[componentTitle] = relBase;
      if (relPath.includes('1 Components')) {
        convertedSwiftFileMap[componentTitle.toLowerCase()] = { componentTitle, isConverted: false };
      }
```

### 🚨 중요: View Extension만 있는 경우 문서 페이지가 생성되지 않음 (Important: Documentation Page Not Generated When Only View Extensions Exist)

**문제 상황 (Problem Scenario):**

`Popover.swift`처럼 파일 내에 `public enum Popover` 같은 타입이 없고, View extension 함수만 있는 경우:

*When a file like `Popover.swift` has no type like `public enum Popover` and only contains View extension functions:*

```swift
// Popover.swift
import SwiftUI

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```

이 경우 **문서 페이지 자체가 생성되지 않습니다.**

*In this case, **no documentation page is generated at all**.*

**이유 (Reason):**

1. DocC는 파일 내의 `public` 타입(enum, struct, class, protocol, actor)을 기반으로 JSON 문서를 생성합니다.
2. View extension만 있는 경우, DocC가 해당 파일에 대한 독립적인 JSON 파일을 생성하지 않습니다. (SwiftUICore 페이지가 생성되기는 하지만 다른 extension 함수가 많아서 사용자가 찾기에 불편합니다.)
3. 스크립트는 DocC가 생성한 JSON 파일을 기반으로 마크다운을 생성하므로, JSON이 없으면 문서 페이지도 생성되지 않습니다.

<!-- -->

1. *DocC generates JSON documentation based on `public` types (enum, struct, class, protocol, actor) within the file.*
2. *When only View extensions exist, DocC does not generate an independent JSON file for that file. (A SwiftUICore page is generated, but it's inconvenient for users to find among many other extension functions.)*
3. *Since the script generates markdown based on JSON files created by DocC, if there's no JSON, no documentation page is generated either.*

**해결 방법 (Solution):**

파일명과 동일한 이름의 View struct가 정의되지 않은 경우 빈 enum 혹은 struct 타입을 추가하세요:

*If a View struct with the same name as the filename is not defined, add an empty enum or struct type:*

```swift
// Popover.swift
import SwiftUI

// ✅ Add type for documentation page generation
public enum Popover {
    // Empty enum is sufficient (namespace role)
}

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```

또는:

*Or:*

```swift
// Popover.swift
import SwiftUI

// ✅ Or use struct
public struct Popover {
    // Empty struct is sufficient
}

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```

**참고 (Note):**

- 연관된 다른 타입의 Extension 함수들은 해당 타입의 "Associated Extensions" 섹션에 자동으로 포함됩니다.
- 타입 자체는 비어있어도 상관없습니다. 단지 문서 페이지를 생성하기 위한 "앵커" 역할만 합니다.

<!-- -->

- *Extension functions of other associated types are automatically included in the "Associated Extensions" section of that type.*
- *The type itself can be empty. It only serves as an "anchor" to generate the documentation page.*

### 🚨 중요: 컴포넌트 하위 타입은 네임스페이스 안에 정의해야 함 (Important: Component Subtypes Must Be Defined Within Namespace)

**문제 상황 (Problem Scenario):**

컴포넌트와 관련된 하위 타입(예: `Style`, `Size`, `Configuration` 등)을 별도의 최상위 타입으로 정의하면, 각각이 독립적인 문서 페이지로 생성됩니다.

*When related subtypes of a component (e.g., `Style`, `Size`, `Configuration`, etc.) are defined as separate top-level types, each becomes an independent documentation page.*

```swift
// Button.swift
public struct Button { }

// ❌ Defined as separate top-level type in separate file or same file
public enum ButtonStyle { }
public enum ButtonSize { }
```

이 경우 `ButtonStyle`과 `ButtonSize`가 각각 별도의 문서 페이지로 생성되어, 하나의 컴포넌트 문서로 통합되지 않습니다.

*In this case, `ButtonStyle` and `ButtonSize` are each generated as separate documentation pages and are not integrated into a single component document.*

**해결 방법 (Solution):**

컴포넌트 이름의 enum 네임스페이스 안에 하위 타입을 정의하세요:

*Define subtypes within the enum namespace of the component name:*

```swift
// Button.swift
public struct Button { }

// ✅ Defined within component namespace
public enum Button {
    public enum Style {
        case primary
        case secondary
    }
    
    public enum Size {
        case small
        case medium
        case large
    }
}
```

**이유 (Reason):**

1. 스크립트는 타입명에 점(`.`)이 있는 중첩 타입(`Button.Style`, `Button.Size`)을 별개의 문서로 생성하지 않습니다.
2. 대신 부모 타입(`Button`)의 Topics 섹션에 포함시켜 하나의 컴포넌트 문서로 통합합니다.
3. 이렇게 하면 관련 타입들이 논리적으로 그룹화되어 사용자가 찾기 쉽습니다.

<!-- -->

1. *The script does not generate nested types with dots (`.`) in their names (`Button.Style`, `Button.Size`) as separate documents.*
2. *Instead, it includes them in the Topics section of the parent type (`Button`) to integrate into a single component document.*
3. *This logically groups related types, making them easier for users to find.*

**참고 코드 (Reference Code):**

```javascript 380:387:Projects/Views/Montage/docc_to_md.js
      json.metadata.roleHeading === 'Enumeration' && json.metadata.title.split('.').length > 1 ||
      json.metadata.roleHeading === 'Case' ||
      json.metadata.roleHeading === 'Extended Class' ||
      json.metadata.roleHeading === 'Extended Structure' ||
      json.metadata.roleHeading === 'Extended Enumeration' ||
      json.metadata.roleHeading === 'Extended Protocol' ||
      json.metadata.roleHeading === 'API Collection' ||
      json.metadata.roleHeading === 'Structure' && json.metadata.title.split('.').length > 1) {
```

**예시 (Example):**
```swift
// ✅ Correct example: Integrated into a single component document
public struct Button {
    // Button implementation
}

public enum Button {
    public enum Style { }
    public enum Size { }
    public struct Configuration { }
}

// ❌ Incorrect example: Each generated as separate document
public struct Button { }
public enum ButtonStyle { }  // Separate document
public enum ButtonSize { }    // Separate document
```

## 3. 컴포넌트와 연관된 다른 타입의 Extension 작성 규칙 (Extension Writing Rules for Types Associated with Components)

### ⚠️ 필수: 연관 Extension 내부의 함수/프로퍼티는 `public`으로 선언해야 함 (Required: Functions/Properties Inside Associated Extensions Must Be Declared as `public`)

**문제점 (Issues):**

- Extension 내부의 함수나 프로퍼티에 `public` 키워드가 없으면 문서화되지 않습니다.
- 스크립트는 정규식으로 각 멤버 선언 앞의 `public` 키워드를 찾아 extension 멤버를 인식합니다.
- **Extension 자체가 `public`이어도 내부 멤버에 `public`이 없으면 인식되지 않습니다.**

<!-- -->

- *Functions or properties inside extensions without the `public` keyword will not be documented.*
- *The script uses regular expressions to find the `public` keyword before each member declaration to recognize extension members.*
- ***Even if the extension itself is `public`, members without `public` will not be recognized.***

**영향받는 코드 (Affected Code):**
```swift
extension View {
    // ❌ Not documented
    func button() -> some View { }
    
    // ✅ Documented
    public func button() -> some View { }
}

// ❌ Even if extension is public, members without public are not documented
public extension View {
    func button() -> some View { }  // No public → Not documented
}

// ✅ Both extension and members must be public
public extension View {
    public func button() -> some View { }  // Has public → Documented
}
```

### ⚠️ 필수: 연관 Extension은 특정 패턴만 인식됨 (Required: Associated Extensions Only Recognize Specific Patterns)

**문제점 (Issues):**

- Extension 내부의 `public func`와 `public var`만 인식됩니다.
- `public subscript`, `public init` 등은 정규식에 포함되지 않아 인식되지 않을 수 있습니다.
- 복잡한 시그니처나 특수한 패턴은 파싱에 실패할 수 있습니다.

<!-- -->

- *Only `public func` and `public var` inside extensions are recognized.*
- *`public subscript`, `public init`, etc. may not be recognized as they are not included in the regular expression.*
- *Parsing may fail with complex signatures or special patterns.*

**인식되는 패턴 (Recognized Patterns):**
```swift
// ✅ Recognized
extension SomeType {
    public func myMethod() { }
    public static func myStaticMethod() { }
    public class func myClassMethod() { }
    public mutating func myMutatingMethod() { }
    public var myProperty: String { }
    public static var myStaticProperty: String { }
}

// ❌ May not be recognized
extension SomeType {
    func privateMethod() { }  // No public
    public subscript(index: Int) -> Element { }  // subscript not in regex
    public init() { }  // init not in regex
}
```

**참고 코드 (Reference Code):**

```javascript 601:616:Projects/Views/Montage/docc_to_md.js
    const funcRegex = /public\s+(?:(static|class|mutating|nonmutating)\s+)?func\s+([^\{]+)/g;
    let result;
    while ((result = funcRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} func` : 'func';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }

    const varRegex = /public\s+(?:(static|class)\s+)?var\s+([^=\{]+)/g;
    while ((result = varRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} var` : 'var';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }
```

### ⚠️ 주의: 연관 Extension 본문 파싱 제한 (Note: Associated Extension Body Parsing Limitations)

**문제점 (Issues):**

- 중괄호 매칭으로 extension 본문을 추출합니다.
- 중첩된 중괄호가 많거나 복잡한 구조에서는 파싱이 실패할 수 있습니다.

<!-- -->

- *Extension bodies are extracted using brace matching.*
- *Parsing may fail with many nested braces or complex structures.*

**참고 코드:**
```javascript 577:596:Projects/Views/Montage/docc_to_md.js
function extractExtensionBodies(content) {
  const bodies = [];
  const extRegex = /extension\s+(?:[A-Za-z0-9_]+\.)?([A-Za-z0-9_]+)\s*\{/g;
  let match;
  while ((match = extRegex.exec(content)) !== null) {
    const typeName = match[1];
    let braceDepth = 1;
    let idx = extRegex.lastIndex;
    while (idx < content.length && braceDepth > 0) {
      const char = content[idx];
      if (char === '{') braceDepth++;
      else if (char === '}') braceDepth--;
      idx++;
    }
    const body = content.slice(extRegex.lastIndex, idx - 1);
    bodies.push({ typeName, body });
    extRegex.lastIndex = idx;
  }
  return bodies;
}
```

## 4. 연관 Extension 시그니처 주의사항 (Associated Extension Signature Notes)

### ⚠️ 문제: 연관 Extension이 컴포넌트 문서에 나타나지 않는 경우 (Problem: Associated Extensions Not Appearing in Component Documentation)

**발생 상황 (Occurrence):**

`Button.swift` 파일에 `extension View { func button(...) }`를 작성했는데, 생성된 `Button` 컴포넌트 문서의 "Associated Extensions" 섹션에 이 함수가 나타나지 않습니다.

*When `extension View { func button(...) }` is written in `Button.swift`, but this function does not appear in the "Associated Extensions" section of the generated `Button` component documentation.*

**원인 (Cause):**

스크립트가 Swift 파일의 extension 시그니처와 DocC가 생성한 시그니처를 비교할 때, 정규화 과정에서 일부 정보가 제거되어 매칭이 실패할 수 있습니다.

*When the script compares extension signatures from Swift files with signatures generated by DocC, matching may fail because some information is removed during the normalization process.*

**주의해야 할 경우 (Cases to Watch Out For):**

1. **타입명이나 파라미터명이 다르게 작성된 경우**
   ```swift
   // ❌ May cause issues: Matching fails if type names differ
   extension View {
       public func button(title: String) -> some View { }
   }
   // Matching fails if DocC recognizes different type names
   ```

   *When type names or parameter names are written differently*

2. **시그니처가 복잡하거나 특수한 경우**
   - 제네릭 제약이 있는 경우
   - 파라미터 속성(`@escaping`, `@ViewBuilder` 등)이 많은 경우
   - 기본값이 있는 파라미터가 많은 경우

   *When signatures are complex or special*
   <!-- -->
   *- Cases with generic constraints*
   *- Cases with many parameter attributes (`@escaping`, `@ViewBuilder`, etc.)*
   *- Cases with many parameters with default values*

**해결 방법 (Solutions):**

1. **문서 생성 후 확인**: 컴포넌트 문서의 "Associated Extensions" 섹션에 extension이 나타나는지 확인하세요.
2. **시그니처 단순화**: 가능하면 시그니처를 단순하게 유지하세요. 복잡한 제네릭 제약이나 많은 파라미터 속성은 매칭을 어렵게 만들 수 있습니다.
3. **문제 발생 시**: Extension이 문서에 나타나지 않으면, Swift 파일의 시그니처를 확인하고 필요시 수정하세요.

<!-- -->

1. *Check after documentation generation: Verify that the extension appears in the "Associated Extensions" section of the component documentation.*
2. *Simplify signatures: Keep signatures as simple as possible. Complex generic constraints or many parameter attributes can make matching difficult.*
3. *When problems occur: If the extension does not appear in the documentation, check the signature in the Swift file and modify it if necessary.*

**참고 (Note):**

- 공백 차이는 자동으로 정리되므로 문제가 되지 않습니다.
- `@escaping`, `@ViewBuilder` 같은 속성은 정규화 과정에서 제거되므로, 이것만으로는 매칭이 실패하지 않습니다.
- 문제는 주로 타입명, 파라미터명, 함수명의 차이에서 발생합니다.

<!-- -->

- *Whitespace differences are automatically normalized, so they are not a problem.*
- *Attributes like `@escaping`, `@ViewBuilder` are removed during normalization, so matching does not fail solely because of these.*
- *Problems mainly occur due to differences in type names, parameter names, and function names.*

**참고 코드 (Reference Code):**

시그니처 정규화 함수 (Signature Normalization Function):
```javascript 515:563:Projects/Views/Montage/docc_to_md.js
function canonicalizeSignature(signature) {
  let normalized = signature
    .replace(/\s+/g, ' ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')')
    .replace(/\s*,\s*/g, ', ')
    .replace(/\s*:\s*/g, ': ')
    .replace(/\s*->\s*/g, ' -> ')
    .replace(/\s+where\s+/g, ' where ');

  // Remove parameter attributes (e.g., @escaping, @ViewBuilder, etc.)
  normalized = normalized.replace(/@\w+\s+/g, '');

  if (signature.includes('func')) {
    // Remove generic constraints (<T: Foo, U: Bar> -> <T, U>)
    normalized = normalized.replace(/<([^>]+)>/g, (_, contents) => {
      const cleaned = contents
        .split(',')
        .map((part) => part.trim().replace(/([A-Za-z0-9_]+)\s*:\s*[^,]+/, '$1'))
        .join(', ');
      return `<${cleaned}>`;
    });


    // Normalize external/internal parameter names
    normalized = normalized
      // Remove internal name when external label + internal name exist
      .replace(/([A-Za-z0-9_]+)\s+[A-Za-z0-9_]+\s*:/g, '$1:')
      // Remove label when external label is _
      .replace(/_\s*:\s*/g, '');

    // Remove parameter default values
    normalized = stripParameterDefaults(normalized);
  }

  // Remove unnecessary whitespace
  normalized = normalized
    .replace(/,\s+\)/g, ')')
    .replace(/\s*,\s*/g, ', ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')')
    .replace(/\s{2,}/g, ' ')
    .replace(/\s+,/g, ',')
    .replace(/:\s+/g, ': ')
    .replace(/\(\s+/g, '(')
    .replace(/\s+\)/g, ')');

  return normalized.trim();
}
```

DocC JSON에서 extension 멤버 렌더링 시 시그니처 비교 (Signature Comparison When Rendering Extension Members from DocC JSON):
```javascript 628:633:Projects/Views/Montage/docc_to_md.js
function renderExtensionMemberMarkdown(ref, dataRoot, mdPath = 'documentation/utilities/ios-extensions') {
  if (!ref) return null;

  const signatureRaw = (ref.fragments || []).map((f) => f.text).join('') || ref.title || '';
  const canonicalSignature = canonicalizeSignature(signatureRaw);
  const hash = generateHash(canonicalSignature);
```

## 5. 디렉토리 구조 의존성 (Directory Structure Dependency)

### ⚠️ 필수: "1 Components" 디렉토리 구조 (Required: "1 Components" Directory Structure)

**문제점 (Issues):**

- 연관 Extension 수집은 `1 Components` 디렉토리 내의 파일에만 적용됩니다.
- 다른 디렉토리의 파일은 extension이 문서화되지 않을 수 있습니다.

<!-- -->

- *Associated Extension collection only applies to files within the `1 Components` directory.*
- *Extensions in files from other directories may not be documented.*

**참고 코드 (Reference Code):**

```javascript 860:877:Projects/Views/Montage/docc_to_md.js
      if (relPath.includes('1 Components')) {
        convertedSwiftFileMap[componentTitle.toLowerCase()] = { componentTitle, isConverted: false };
      }

      // Extract public type names from Swift files
      try {
        const content = fs.readFileSync(fullPath, 'utf-8');
        // Find public enum, struct, class, protocol, actor, etc.
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
        let match;
        while ((match = typeRegex.exec(content)) !== null) {
          const typeName = match[2];
          swiftFileMap[typeName] = relBase;
        }

        if (/\b1 Components\b/.test(relBase)) {
          collectComponentExtensionHashes(componentTitle, content);
        }
```

## 6. 타입 인식 제한 (Type Recognition Limitations)

### ⚠️ 주의: 특정 타입만 인식됨 (Note: Only Specific Types Are Recognized)

**인식되는 타입 (Recognized Types):**

- `public enum`
- `public struct`
- `public class`
- `public protocol`
- `public actor`

<!-- -->

- *`public enum`*
- *`public struct`*
- *`public class`*
- *`public protocol`*
- *`public actor`*

**인식되지 않는 타입 (Unrecognized Types):**

- `typealias`
- `associatedtype` (프로토콜 내부)
- 중첩 타입 (별도 처리 없음)

<!-- -->

- *`typealias`*
- *`associatedtype` (inside protocols)*
- *Nested types (no separate processing)*

**참고 코드 (Reference Code):**

```javascript 868:868:Projects/Views/Montage/docc_to_md.js
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
```

## 7. UIKit 관련 필터링 (UIKit-Related Filtering)

### ⚠️ 주의: UIKit 관련 문서는 제외됨 (Note: UIKit-Related Documentation Excluded)

**문제점 (Issues):**

- 파일명이 `ui`로 시작하거나 `montage.json`으로 끝나는 파일은 제외됩니다.
- UIKit 관련 타입은 문서화되지 않습니다.

<!-- -->

- *Files with names starting with `ui` or ending with `montage.json` are excluded.*
- *UIKit-related types are not documented.*

**참고 코드 (Reference Code):**

```javascript 49:49:Projects/Views/Montage/docc_to_md.js
    if (ref.title === 'UIKit') continue;
```

```javascript 152:156:Projects/Views/Montage/docc_to_md.js
      const urlPathLastComponent = url.split('/').at(-1);
      if (urlPathLastComponent.startsWith('UI')) {
        // Exclude UIKit-related documentation
        return;
      }
```

```javascript 394:397:Projects/Views/Montage/docc_to_md.js
    const jsonFileName = jsonPath.split('/').at(-1);
    if (jsonFileName.startsWith('ui') || jsonFileName.endsWith('montage.json')) {
      // Exclude UIKit-related documentation
      return;
```

## 8. 특정 Role 제외 (Specific Role Exclusion)

### ⚠️ 주의: 특정 Role의 문서는 단독 페이지로는 생성되지 않음. 단, 최상위 레벨에 정의된 enum과 struct는 단독 페이지로 생성함 (Note: Documents for Specific Roles Are Not Generated as Standalone Pages. However, enums and structs defined at the top level are generated as standalone pages.)

**제외되는 Role (Excluded Roles):**

- `Initializer`
- `Instance Method`
- `Instance Property`
- `Type Method`
- `Type Property`
- `Operator`
- `Class`
- `Enumeration` (최상위 뎁스는 제외 *top-level depth excluded)*
- `Case`
- `Extended Class`
- `Extended Structure`
- `Extended Enumeration`
- `Extended Protocol`
- `API Collection`
- `Structure` (최상위 뎁스는 제외 *top-level depth excluded)*

**참고 코드 (Reference Code):**

```javascript 373:390:Projects/Views/Montage/docc_to_md.js
    if (json.metadata.roleHeading === 'Initializer' ||
      json.metadata.roleHeading === 'Instance Method' ||
      json.metadata.roleHeading === 'Instance Property' ||
      json.metadata.roleHeading === 'Type Method' ||
      json.metadata.roleHeading === 'Type Property' ||
      json.metadata.roleHeading === 'Operator' ||
      json.metadata.roleHeading === 'Class' ||
      json.metadata.roleHeading === 'Enumeration' && json.metadata.title.split('.').length > 1 ||
      json.metadata.roleHeading === 'Case' ||
      json.metadata.roleHeading === 'Extended Class' ||
      json.metadata.roleHeading === 'Extended Structure' ||
      json.metadata.roleHeading === 'Extended Enumeration' ||
      json.metadata.roleHeading === 'Extended Protocol' ||
      json.metadata.roleHeading === 'API Collection' ||
      json.metadata.roleHeading === 'Structure' && json.metadata.title.split('.').length > 1) {
      // Exclude Topic section items from separate document generation
      return;
    }
```

## 요약: 문제 발생 시 (Summary: When Problems Occur)

문서화가 제대로 되지 않는다면:

*If documentation is not generated correctly:*

1. `public` 키워드 확인
2. 파일명과 타입명 일치 확인
3. **View extension만 있는 파일인 경우, 파일명과 동일한 `public enum` 또는 `public struct` 타입이 있는지 확인**
4. **하위 타입이 별도 문서로 생성되는 경우, 컴포넌트 이름의 enum 네임스페이스 안에 정의되어 있는지 확인** (예: `Button.Style`이 아닌 `ButtonStyle`로 정의되어 있지 않은지)
5. **Extension이 컴포넌트 문서의 "Associated Extensions" 섹션에 나타나지 않는 경우, Swift 파일의 시그니처를 확인하고 필요시 단순화**
6. 연관 Extension이 `1 Components` 디렉토리에 있는지 확인
7. 연관 Extension 내부의 함수/프로퍼티는 `public`으로 선언되어 있는지 확인
8. UIKit 관련 타입이 아닌지 확인
9. 스크립트 실행 로그에서 에러 메시지 확인

<!-- -->

1. *Check for `public` keyword*
2. *Verify that filename and type name match*
3. ***If a file only has View extensions, check if there is a `public enum` or `public struct` type with the same name as the filename***
4. ***If subtypes are generated as separate documents, verify they are defined within the enum namespace of the component name*** (e.g., not defined as `ButtonStyle` instead of `Button.Style`)
5. ***If extensions do not appear in the "Associated Extensions" section of the component documentation, check the signature in the Swift file and simplify if necessary***
6. *Check if associated extensions are in the `1 Components` directory*
7. *Verify that functions/properties inside associated extensions are declared as `public`*
8. *Check if it's not a UIKit-related type*
9. *Check error messages in the script execution log*

