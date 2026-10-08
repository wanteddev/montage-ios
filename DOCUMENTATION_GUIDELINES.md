# Montage Code Documentation Guidelines

[English](./DOCUMENTATION_GUIDELINES.md) | [한국어](./DOCUMENTATION_GUIDELINES.ko.md)

This document outlines the requirements that must be followed when writing Montage code for the `scripts/docc_to_md.js` script to work correctly.


## 1. Access Control
### Required: Use the `public` Keyword


- The script uses regex to find the `public` keyword to recognize types and members.
- Without `public`, they will not be documented.



```swift
// Not documented
struct MyComponent {
    func myMethod() { }
}

// Documented
public struct MyComponent {
    public func myMethod() { }
}
```


```javascript 868:873:Projects/Views/Montage/scripts/docc_to_md.js
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
        let match;
        while ((match = typeRegex.exec(content)) !== null) {
          const typeName = match[2];
          swiftFileMap[typeName] = relBase;
        }
```

```javascript 601:608:Projects/Views/Montage/scripts/docc_to_md.js
    const funcRegex = /public\s+(?:(static|class|mutating|nonmutating)\s+)?func\s+([^\{]+)/g;
    let result;
    while ((result = funcRegex.exec(body)) !== null) {
      const modifier = (result[1] || '').trim();
      const signatureBody = (result[2] || '').trim().replace(/\s+$/g, '');
      const kind = modifier ? `${modifier} func` : 'func';
      recordComponentExtensionSignature(componentTitle, typeName, kind, signatureBody);
    }
```

## 2. File Name and Type Name Mapping

### Note: File Name Is Used as the Component Title


- The file name (without `.swift`) is used as the component title.
- If the type name inside the file differs from the file name, mapping can become complicated.




- Match the file name with the primary type name.
- Example: `Button.swift` -> `public struct Button`




```javascript 857:862:Projects/Views/Montage/scripts/docc_to_md.js
      // Filename-based mapping (keep existing logic)
      const componentTitle = file.replace(/\.swift$/, '');
      swiftFileMap[componentTitle] = relBase;
      if (relPath.includes('1 Components')) {
        convertedSwiftFileMap[componentTitle.toLowerCase()] = { componentTitle, isConverted: false };
      }
```

### Important: No Documentation Page Is Generated When Only View Extensions Exist


If a file like `Popover.swift` contains only View extension functions without a `public enum Popover` or similar type:


```swift
// Popover.swift
import SwiftUI

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```

In this case, **no documentation page will be generated.**



1. DocC generates JSON documentation based on `public` types in the file.
2. When only View extensions exist, DocC does not generate an independent JSON file for that file. (A SwiftUICore page is generated, but it contains many other extension functions, making it difficult for users to find.)
3. Since the script generates Markdown based on DocC-generated JSON files, no JSON means no documentation page.




If no View struct with the same name as the file is defined, add an empty enum or struct type:


```swift
// Popover.swift
import SwiftUI

// Add type for documentation page generation
public enum Popover {
    // Empty enum is sufficient (namespace role)
}

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```

Or:


```swift
// Popover.swift
import SwiftUI

// Or use struct
public struct Popover {
    // Empty struct is sufficient
}

extension View {
    public func popover(...) -> some View {
        // Implementation
    }
}
```


- Extension functions of other associated types are automatically included in the "Associated Extensions" section of that type.
- The type itself can be empty. It only serves as an "anchor" for generating the documentation page.



### Important: Component Subtypes Must Be Defined Within a Namespace


If subtypes related to a component (e.g., `Style`, `Size`, `Configuration`) are defined as separate top-level types, each will be generated as an independent documentation page.


```swift
// Button.swift
public struct Button { }

// Defined as separate top-level type in separate file or same file
public enum ButtonStyle { }
public enum ButtonSize { }
```

In this case, `ButtonStyle` and `ButtonSize` are each generated as separate documentation pages and are not consolidated into a single component document.



Define subtypes within an enum namespace of the component name:


```swift
// Button.swift
public struct Button { }

// Defined within component namespace
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


1. The script does not generate separate documents for nested types with dots (`.`) in their type names (`Button.Style`, `Button.Size`).
2. Instead, it includes them in the parent type's Topics section, consolidating them into a single component document.
3. This logically groups related types, making them easier for users to find.




```javascript 380:387:Projects/Views/Montage/scripts/docc_to_md.js
      json.metadata.roleHeading === 'Enumeration' && json.metadata.title.split('.').length > 1 ||
      json.metadata.roleHeading === 'Case' ||
      json.metadata.roleHeading === 'Extended Class' ||
      json.metadata.roleHeading === 'Extended Structure' ||
      json.metadata.roleHeading === 'Extended Enumeration' ||
      json.metadata.roleHeading === 'Extended Protocol' ||
      json.metadata.roleHeading === 'API Collection' ||
      json.metadata.roleHeading === 'Structure' && json.metadata.title.split('.').length > 1) {
```

```swift
// Correct example: Integrated into a single component document
public struct Button {
    // Button implementation
}

public enum Button {
    public enum Style { }
    public enum Size { }
    public struct Configuration { }
}

// Incorrect example: Each generated as separate document
public struct Button { }
public enum ButtonStyle { }  // Separate document
public enum ButtonSize { }    // Separate document
```

## 3. Extension Writing Rules for Types Associated with Components

### Required: Functions/Properties Inside Associated Extensions Must Be Declared as `public`


- Functions or properties inside extensions will not be documented without the `public` keyword.
- The script uses regex to find the `public` keyword before each member declaration to recognize extension members.



```swift
extension View {
    // Not documented
    func button() -> some View { }

    // Documented
    public func button() -> some View { }
}

// Even if extension is public, members without public are not documented
public extension View {
    func button() -> some View { }  // No public -> Not documented
}

// Both extension and members must be public
public extension View {
    public func button() -> some View { }  // Has public -> Documented
}
```

### Required: Only Specific Patterns Are Recognized for Associated Extensions


- Only `public func` and `public var` inside extensions are recognized.
- `public subscript`, `public init`, etc. are not included in the regex and may not be recognized.
- Complex signatures or special patterns may fail to parse.



```swift
// Recognized
extension SomeType {
    public func myMethod() { }
    public static func myStaticMethod() { }
    public class func myClassMethod() { }
    public mutating func myMutatingMethod() { }
    public var myProperty: String { }
    public static var myStaticProperty: String { }
}

// May not be recognized
extension SomeType {
    func privateMethod() { }  // No public
    public subscript(index: Int) -> Element { }  // subscript not in regex
    public init() { }  // init not in regex
}
```


```javascript 601:616:Projects/Views/Montage/scripts/docc_to_md.js
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

### Note: Associated Extension Body Parsing Limitations


- Extension bodies are extracted using brace matching.
- Parsing may fail with deeply nested braces or complex structures.



```javascript 577:596:Projects/Views/Montage/scripts/docc_to_md.js
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

## 4. Associated Extension Signature Considerations

### Issue: Associated Extension Not Appearing in Component Documentation


If you write `extension View { func button(...) }` in `Button.swift`, but the function does not appear in the "Associated Extensions" section of the generated `Button` component documentation:



When the script compares Swift file extension signatures with DocC-generated signatures, some information may be removed during normalization, causing matching to fail.



   ```swift
   // May cause issues: Matching fails if type names differ
   extension View {
       public func button(title: String) -> some View { }
   }
   // Matching fails if DocC recognizes different type names
   ```


   - When generic constraints are present
   - When there are many parameter attributes (`@escaping`, `@ViewBuilder`, etc.)
   - When there are many parameters with default values




- Whitespace differences are automatically cleaned up, so they are not a problem.
- Attributes like `@escaping`, `@ViewBuilder` are removed during normalization, so these alone do not cause matching failure.
- Problems mainly arise from differences in type names, parameter names, and function names.




Signature Normalization Function:
```javascript 515:563:Projects/Views/Montage/scripts/docc_to_md.js
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

Signature Comparison When Rendering Extension Members from DocC JSON:
```javascript 628:633:Projects/Views/Montage/scripts/docc_to_md.js
function renderExtensionMemberMarkdown(ref, dataRoot, mdPath = 'documentation/utilities/ios-extensions') {
  if (!ref) return null;

  const signatureRaw = (ref.fragments || []).map((f) => f.text).join('') || ref.title || '';
  const canonicalSignature = canonicalizeSignature(signatureRaw);
  const hash = generateHash(canonicalSignature);
```

## 5. Directory Structure Dependency

### Required: "1 Components" Directory Structure


- Associated extension collection only applies to files within the `1 Components` directory.
- Extensions in files from other directories may not be documented.




```javascript 860:877:Projects/Views/Montage/scripts/docc_to_md.js
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

## 6. Type Recognition Limitations

### Note: Only Specific Types Are Recognized

**Recognized types:**

- `public enum`
- `public struct`
- `public class`
- `public protocol`
- `public actor`

**Not recognized:**

- `typealias`
- `associatedtype` (inside protocols)
- Nested types (no separate handling)



```javascript 868:868:Projects/Views/Montage/scripts/docc_to_md.js
        const typeRegex = /public\s+(enum|struct|class|protocol|actor)\s+(\w+)/g;
```

## 7. UIKit-Related Filtering

### Note: UIKit-Related Documentation Is Excluded


- Files with names starting with `ui` or ending with `montage.json` are excluded.
- UIKit-related types are not documented.




```javascript 49:49:Projects/Views/Montage/scripts/docc_to_md.js
    if (ref.title === 'UIKit') continue;
```

```javascript 152:156:Projects/Views/Montage/scripts/docc_to_md.js
      const urlPathLastComponent = url.split('/').at(-1);
      if (urlPathLastComponent.startsWith('UI')) {
        // Exclude UIKit-related documentation
        return;
      }
```

```javascript 394:397:Projects/Views/Montage/scripts/docc_to_md.js
    const jsonFileName = jsonPath.split('/').at(-1);
    if (jsonFileName.startsWith('ui') || jsonFileName.endsWith('montage.json')) {
      // Exclude UIKit-related documentation
      return;
```

## 8. Specific Roles Excluded

### Note: Documents for Specific Roles Are Not Generated as Standalone Pages

However, enums and structs defined at the top level are generated as standalone pages.

- `Initializer`
- `Instance Method`
- `Instance Property`
- `Type Method`
- `Type Property`
- `Operator`
- `Class`
- `Enumeration` (top-level depth excluded)
- `Case`
- `Extended Class`
- `Extended Structure`
- `Extended Enumeration`
- `Extended Protocol`
- `API Collection`
- `Structure` (top-level depth excluded)


```javascript 373:390:Projects/Views/Montage/scripts/docc_to_md.js
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

## 9. Markdown Inline Formatting in Docstrings

DocC parses docstrings as Markdown (GFM). `**bold**`, `*italic*`, symbol links (` ``TypeName`` `), and strikethrough are preserved in the generated md. Using them intentionally is fine, but watch out for characters that get **interpreted as formatting unintentionally**.

### Important: `~` (tilde) Is Parsed as Strikethrough — Escape It in Ranges

The DocC parser treats **even a single `~` as strikethrough**. If a paragraph contains two `~`, they pair up and strike through the text between them, corrupting the output. The most common trap is using `~` as a **numeric range separator**.

```swift
// ❌ Broken — two ~ on one line, so "90%, last line 40" gets struck through
/// Middle lines 65~90%, last line 40~55% are generated automatically.

// ✅ Escape the tilde with a backslash (DocC treats it as a literal ~)
/// Middle lines 65\~90%, last line 40\~55% are generated automatically.

// ✅ Or use a hyphen / en-dash
/// Middle lines 65-90%, last line 40-55% are generated automatically.
```

- **Always escape `~` in ranges as `\~`.** Even if a line has only one `~` today (e.g. `24\~64pt`), adding another range to the same paragraph later would break it, so escape without exception.
- Unless strikethrough is intended, make sure `~`/`~~` does not remain literally in the docstring.

### Backstop: The Converter Warns on Strikethrough

`scripts/docc_to_md.js` prints a warning whenever it encounters a strikethrough node. Montage does not use strikethrough intentionally, so if you see the warning below in the `make` log, escape the `~` in that docstring.

```
⚠️ strikethrough(취소선) 감지: "..." — docstring에서 범위 구분자 '~'를 '\~'로 이스케이프했는지 확인하세요
```

## Summary: Troubleshooting

If documentation is not generated correctly:

1. Check for `public` keyword
2. Verify file name and type name match
3. Check if associated extensions are in the `1 Components` directory
4. Verify functions/properties inside associated extensions are declared as `public`
5. Check if the type is not UIKit-related
6. Check that `~` range separators in docstrings are escaped as `\~` (avoids strikethrough mis-parsing)
7. Check the script execution log for error/warning messages
