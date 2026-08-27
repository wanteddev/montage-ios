# Migration Guide

[English](./MIGRATION.md) | [한국어](./MIGRATION.ko.md)

Changes required when upgrading across a major version. The newest version comes first.

Every item is marked as one of three kinds: **a mechanical replacement**, **something you have to restructure**, or **something that changes what you see**. Some items are easy to miss if you only clear the compile errors and never look at the screen, so please read the final [Changes that alter what you see](#changes-that-alter-what-you-see) section.

---

## 4.0

> **In progress.** This document is updated as items land on `release/4.0.0`.

4.0 brings breaking changes along four axes.

1. **Color semantic tokens reorganized** - token names now follow a `usage + role + variant` rule. Most values stay the same; only the names change.
2. **Slot-based APIs** - instead of fixed parameters (`leadingImage:`) and `Model` structs, the call site passes views directly.
3. **Input components split apart** - labels, status messages, and character counts moved out of `TextField`/`TextArea` and into `FormControl` slots.
4. **Component spec refresh** - radius, typography, padding, and icon sizes were retuned to match the design spec. **This is the only axis where the API is unchanged, so nothing fails to compile.**

### Order of work

| Step | Task | Kind | Visual change |
|---|---|---|---|
| 1 | [Color semantic tokens](#1-color-semantic-tokens) | Mechanical | None |
| 2 | [Spacing and Opacity tokens](#2-spacing-and-opacity-tokens) | Mechanical | None |
| 3 | [Global modifiers](#3-global-modifiers) | Mechanical | None |
| 4 | [Input components to FormControl](#4-input-components-to-formcontrol) | Restructure | **Yes** |
| 5 | [Slot-based APIs](#5-slot-based-apis) | Restructure | Mostly none |
| 6 | [Straight API replacements](#6-straight-api-replacements) | Mechanical | Some |
| 7 | [Removed UIKit wrappers](#7-removed-uikit-wrappers) | Restructure | None |
| 8 | [Component spec refresh](#8-component-spec-refresh) | Check the screen | **Yes** |
| 9 | [Review changes that alter what you see](#changes-that-alter-what-you-see) | Check the screen | **Yes** |

**Do not skip step 8.** Those items keep the same API and only change values, so nothing fails to compile. A green build after the replacements does not mean the migration is done.

Finishing the token replacements (1 through 3) first removes most of the compile errors and makes the rest of the work easier to see.

---

### 1. Color semantic tokens

Every token name passed to `Color.semantic(_:)` / `UIColor.semantic(_:)` changes. **Except for two RedOrange entries**, the mappings below keep the same value, so rendering does not change. RedOrange has no 4.0 counterpart, so you have to pick one yourself and the color will change.

#### The new naming rule

```
usage + role + variant

usage    foreground  text and icons
         background  the page beneath everything
         surface     surfaces that sit on the page (cards, fields, buttons)
         line        borders and dividers
         effect      dimming and transparent layers

role     Neutral  Brand  Positive  Cautionary  Negative  Disable  Inactive  Accent{Color}

variant  Primary → Secondary → Tertiary → Quaternary  (decreasing contrast)
         Strong / Heavy   darker
         Subtle           lighter
         Inverse          for use on an inverted background
         Focus            focus ring
         Opaque           the opaque version (the suffix-less one is translucent)
```

The `Solid` suffix from 3.x is inverted to `Opaque` in 4.0. The only thing to watch is that the suffix moves from the front to the back, as in **`lineSolidNormal` → `lineNeutralPrimaryOpaque`**.

#### Foreground - text and icons

| 3.x | 4.0 |
|---|---|
| `.labelNormal` | `.foregroundNeutralPrimary` |
| `.labelStrong` | `.foregroundNeutralStrong` |
| `.labelNeutral` | `.foregroundNeutralSecondary` |
| `.labelAlternative` | `.foregroundNeutralTertiary` |
| `.labelAssistive` | `.foregroundNeutralQuaternary` |
| `.inverseLabel` | `.foregroundNeutralInverse` |
| `.labelDisable` | `.foregroundDisablePrimary` |
| `.interactionInactive` | `.foregroundInactivePrimary` |
| `.inversePrimary` | `.foregroundBrandInverse` |
| `.statusPositive` | `.foregroundPositivePrimary` |
| `.statusCautionary` | `.foregroundCautionaryPrimary` |
| `.statusNegative` | `.foregroundNegativePrimary` |
| `.accentForegroundBlue` | `.foregroundBrandPrimary` |
| `.accentForegroundGreen` | `.foregroundPositivePrimary` |
| `.accentForegroundOrange` | `.foregroundCautionaryPrimary` |
| `.accentForegroundRed` | `.foregroundNegativeStrong` |
| `.accentForegroundRedOrange` | **No counterpart** (see below) |
| `.accentForegroundLime` | `.foregroundAccentLime` |
| `.accentForegroundCyan` | `.foregroundAccentCyan` |
| `.accentForegroundLightBlue` | `.foregroundAccentLightBlue` |
| `.accentForegroundViolet` | `.foregroundAccentViolet` |
| `.accentForegroundPurple` | `.foregroundAccentPurple` |
| `.accentForegroundPink` | `.foregroundAccentPink` |

> Among `accentForeground{Color}`, Blue, Green, Orange, and Red were **promoted from the accent family to semantic colors** (brand/positive/cautionary/negative). Do not just rename them; check that the spot really calls for a semantic color.

#### Background and Surface

| 3.x | 4.0 |
|---|---|
| `.backgroundNormal` | `.backgroundNeutralPrimary` |
| `.backgroundNormalAlternative` | `.backgroundNeutralSecondary` |
| `.backgroundElevated` | `.surfaceElevatedPrimary` |
| `.backgroundElevatedAlternative` | `.surfaceElevatedSecondary` |
| `.fillNormal` | `.surfaceNeutralSecondary` |
| `.fillAlternative` | `.surfaceNeutralTertiary` |
| `.fillStrong` | `.surfaceNeutralStrong` |
| `.fillPrimary` | `.surfaceBrandSubtle` |
| `.fillNegative` | `.surfaceNegativeStrong` |
| `.backgroundStatusPositive` | `.surfacePositivePrimary` |
| `.backgroundStatusCautionary` | `.surfaceCautionaryPrimary` |
| `.backgroundStatusNegative` | `.surfaceNegativePrimary` |
| `.inverseBackground` | `.surfaceNeutralInverse` |
| `.primaryNormal` | `.surfaceBrandPrimary` |
| `.primaryStrong` | `.surfaceBrandStrong` |
| `.primaryHeavy` | `.surfaceBrandHeavy` |
| `.interactionDisable` | `.surfaceDisablePrimary` |
| `.accentBackgroundLime` | `.surfaceAccentLimeOpaque` |
| `.accentBackgroundCyan` | `.surfaceAccentCyanOpaque` |
| `.accentBackgroundLightBlue` | `.surfaceAccentLightBlueOpaque` |
| `.accentBackgroundViolet` | `.surfaceAccentVioletOpaque` |
| `.accentBackgroundPink` | `.surfaceAccentPinkOpaque` |
| `.accentBackgroundRedOrange` | **No counterpart** (see below) |

> Only two `background` tokens remain, for the page itself (Primary and Secondary). Everything else split off: surfaces became `surface`, and the transparent layers `backgroundTransparent*` became `effect` (`backgroundTransparent` → `effectTransparentPrimary`, `backgroundTransparentAlternative` → `effectTransparentSecondary`). The values are unchanged.
>
> `accentBackground{Color}` maps to the **opaque** (`Opaque`) token by default. If the spot was layering a translucent color over something, use the suffix-less `.surfaceAccent{Color}`.
>
> **The RedOrange family is gone from the 4.0 semantics.** There is no 4.0 token matching `accentForegroundRedOrange` or `accentBackgroundRedOrange` (the primitive `redOrange*` tokens are still there). A 1:1 replacement is not possible, so look at what the spot was for and choose deliberately - and whatever you choose, **the color will change.** In the Wanted app all three usages were text or icon colors, so they moved to `.foregroundNegativePrimary`, which turned `redOrange50/60` into `red50/60`. If the spot was a surface color, `.surfaceNegativePrimary` or a direct primitive `redOrange*` will be closer to the original value.

#### Line - borders and dividers

| 3.x | 4.0 |
|---|---|
| `.lineNormal` | `.lineNeutralPrimary` |
| `.lineNeutral` | `.lineNeutralSecondary` |
| `.lineAlternative` | `.lineNeutralTertiary` |
| `.lineSolidNormal` | `.lineNeutralPrimaryOpaque` |
| `.lineSolidNeutral` | `.lineNeutralSecondaryOpaque` |
| `.lineSolidAlternative` | `.lineNeutralTertiaryOpaque` |
| `.linePrimaryStrong` | `.lineBrandStrong` |
| `.lineStatusPositiveNormal` | `.linePositivePrimary` |
| `.lineStatusCautionaryNormal` | `.lineCautionaryPrimary` |
| `.lineStatusNegativeStrong` | `.lineNegativeStrong` |

#### Effect - dimming and transparent layers

| 3.x | 4.0 |
|---|---|
| `.materialDimmer` | `.effectDimmerPrimary` |
| `.backgroundTransparent` | `.effectTransparentPrimary` |
| `.backgroundTransparentAlternative` | `.effectTransparentSecondary` |

#### Tokens not in the tables above

For tokens introduced in 4.0 (`lineBrandFocus`, `lineNegativeFocus`, `foregroundAccent*`, and so on) and for primitive tokens (`neutral*`, `blue*`, `coolNeutral*`, …), check `Color.Semantic` directly. Primitive names did not change.

If you cannot find a 3.x token in the tables, look at the doc comment on each `Color.Semantic` case. Renamed tokens carry their 3.x name after `구` ("former"), as in `/// 기본 전경 색상 (구 labelNormal)`.

#### Bulk replacement

No 3.x token name survives into 4.0, so a word-boundary replacement is safe.

```bash
# check first
grep -rn "\.labelNormal\b" --include="*.swift" .

# replace
find . -name "*.swift" -exec sed -i '' \
  -e 's/\.labelNormal\b/.foregroundNeutralPrimary/g' \
  -e 's/\.labelAlternative\b/.foregroundNeutralTertiary/g' \
  -e 's/\.backgroundNormal\b/.backgroundNeutralPrimary/g' \
  {} +
```

---

### 2. Spacing and Opacity tokens

These were flattened so the value appears directly in the name. The mapping is 1:1, so rendering is identical.

```swift
// 3.x
.padding(.spacing(.pt20))
.opacity(.p043)

// 4.0
.padding(.spacing20)
.opacity(.opacity43)
```

| 3.x | 4.0 |
|---|---|
| `.spacing(.pt02)` … `.spacing(.pt72)` | `.spacing2` … `.spacing72` |
| `.opacity(.p000)` | `.opacity0` |
| `.opacity(.p005)` | `.opacity5` |
| `.opacity(.p008)` | `.opacity8` |
| `.opacity(.p012)` | `.opacity12` |
| `.opacity(.p016)` | `.opacity16` |
| `.opacity(.p022)` | `.opacity22` |
| `.opacity(.p028)` | `.opacity28` |
| `.opacity(.p032)` | `.opacity32` |
| `.opacity(.p035)` | `.opacity35` |
| `.opacity(.p043)` | `.opacity43` |
| `.opacity(.p052)` | `.opacity52` |
| `.opacity(.p061)` | `.opacity61` |
| `.opacity(.p074)` | `.opacity74` |
| `.opacity(.p088)` | `.opacity88` |
| `.opacity(.p097)` | `.opacity97` |
| `.opacity(.p100)` | `.opacity100` |

**The zero padding disappears**, as in `pt08` → `spacing8`. It is not `spacing08`.

Opacity tokens moved to `Double`. Spots that used a raw literal like `withAlphaComponent(0)` can be tidied up to `withAlphaComponent(.opacity0)`.

---

### 3. Global modifiers

| 3.x | 4.0 | Notes |
|---|---|---|
| `.disable(_:)` | `.disabled(_:)` | Absorbed into the standard SwiftUI modifier. Components read the `isEnabled` environment value |
| `scrollStatus.scrolledToMax` | `scrollStatus.reachedEnd` | A `ScrollStatus` property on `Montage.ScrollView` |

`disable()` → `disabled()` is more than a rename. In 3.x the component applied its own `opacity`; in 4.0 it follows SwiftUI's `isEnabled` and expresses the state through color tokens (`foregroundDisablePrimary` and friends). See [Changes that alter what you see](#changes-that-alter-what-you-see).

Input components gained `autocorrectionDisabled(_:)` (an addition, not a breaking change).

---

### 4. Input components to FormControl

This is the change that takes the most work. `TextField`/`TextArea` now handle **only the input itself**, and `FormControl` places the label, status message, and character counter outside the field.

| 3.x (inside the field) | 4.0 (FormControl slot) | Position |
|---|---|---|
| `.heading("Email")` | `.label("Email")` | **Above** the field |
| `.status(.negative(description: msg))` | `.status(.negative)` + `.message(msg)` | **Below** the field |
| `.bottomResources(trailing: [.characterCount(limit:)])` | `.accessory { … }` | Below the field, **trailing** |
| `.disable(_:)` | `.disabled(_:)` | - |

`TextField.Status` lost its associated values: `.normal()` → `.normal`, `.negative(description:)` → `.negative`.

#### TextField

```swift
// 3.x
Montage.TextField(text: $email)
    .heading(String(localized: "Email"))
    .placeholder(String(localized: "Enter your email."))
    .status(isInvalidated ? .negative(description: errorMessage) : .normal())
    .disable(isDisabled)

// 4.0
FormControl { context in
    Montage.TextField(text: $email)
        .status(context.status.textFieldStatus)
        .placeholder(String(localized: "Enter your email."))
}
.label(String(localized: "Email"))
.status(isInvalidated ? .negative : .normal)
.message(isInvalidated ? errorMessage : nil)
.disabled(isDisabled)
```

**`FormControl` owns the status** and passes it down to the field through `context.status.textFieldStatus`. If you set the status on the field directly, the label and message colors will drift out of sync.

#### TextArea and the character counter

```swift
// 3.x
TextArea(text: $feedback, focus: $focus)
    .resize(.fixed(min: 116, max: 116))
    .placeholder("Tell us what you liked or what fell short.")
    .bottomResources(trailing: [.characterCount(limit: 1000)])

// 4.0
FormControl { _ in
    TextArea(text: $feedback, focus: $focus)
        .maxLength(1000)
        .resize(.fixed(min: 116, max: 116))
        .placeholder(String(localized: "Tell us what you liked or what fell short."))
}
.accessory {
    Text(verbatim: "\(feedback.count)/1000")
        .typography(variant: .label2, weight: .medium, semantic: .foregroundNeutralTertiary)
}
```

The `.characterCount` resource was removed from `bottomResources`. The call site now draws the counter itself (`bottomResources` itself is still there). Two things to keep in mind.

- **The input limit goes on the field via `maxLength(_:)`.** Displaying the count and enforcing the limit are now separate.
- **Use `Text(verbatim:)`.** `Text("\(count)/\(limit)")` goes through `LocalizedStringKey` interpolation, which adds a locale thousands separator once the limit reaches 1000 (`5,000`). With `verbatim:` you get `5000`.

The remaining `FormControl` modifiers: `size(.large/.medium)`, `labelPlacement(.top/.leading)`, `labelWidth(_:)`, `label(_:required:)`. To align several fields together, use `FormControlGroup`.

#### Attaching directly to the input

You can also skip the `FormControl` wrapper and put the modifiers straight on `TextField`, `TextArea`, or `Select`. All three have the same five.

`.label(_:required:)` · `.message(_:)` · `.labelPlacement(_:)` · `.labelWidth(_:)` · `.accessory { }`

```swift
Montage.TextField(text: $email)
    .placeholder(String(localized: "Enter your email."))
    .label(String(localized: "Email"), required: true)
    .message(isInvalidated ? errorMessage : nil)
    .status(isInvalidated ? .negative : .normal)
```

Using any one of them wraps the input in a `FormControl` internally, so the result is the same as the `FormControl { … }` form above. The label is wired up as the input's accessibility label and the message as its accessibility hint.

`size` and `status` resolve in this order: **the value set at the call site, then the value propagated from `FormControl`, then the default** (`.large` / `.normal`). For the common case of one input with just a label and a message, this form is shorter; when you need `FormControlGroup` or have to compose several inputs, reach for `FormControl` directly.

---

#### If you have your own input wrapper

For a wrapper that contains a `TextField` internally, such as `AutoCompleteTextInput`, it is better to **wrap the wrapper itself in a `FormControl`** and expose the status and message as parameters on the wrapper's interface. Putting `FormControl` inside the wrapper makes it hard to supply the label from outside.

---

### 5. Slot-based APIs

`Model` structs and fixed image parameters are gone; the call site passes views directly.

#### ActionArea

```swift
// 3.x
.actionArea(
    variant: .neutral(main: .init(text: "OK", action: { … }))
)
// or
.bottomSheet(isPresented: $isPresented, actionAreaModel: .init(variant: …)) {
    Content()
}

// 4.0
.actionArea {
    ActionArea(variant: .neutral(main: .init(text: "OK", action: { … })))
}
// or
.bottomSheet(
    isPresented: $isPresented,
    actionArea: { ActionArea(variant: …) },
    { Content() }
)
```

The `actionArea` slot closure is **not** annotated with `@ViewBuilder`. An `if` statement turns it into `_ConditionalContent`, which breaks the `ActionArea` type constraint. Handle branching with a ternary or a modifier chain.

```swift
// does not work
.actionArea { if isEditing { ActionArea(variant: a) } else { ActionArea(variant: b) } }

// do this instead
.actionArea { ActionArea(variant: isEditing ? a : b) }
```

The transparent-background API is gone. The background is always opaque, and only the **top gradient** turns on and off as a signal that there is content hidden below (a 0.5 second fade).

| 3.x | 4.0 |
|---|---|
| `.transparentBackground(_:)` | Removed |
| `ActionArea.BackgroundTransparencyControl` (`.automatic` / `.manual`) | Removed |
| `actionArea(backgroundTransparency:)` | Removed |
| `.gradientColor(_:)` | `.backgroundColor(_:)` (applies to both the background and the gradient's start color) |
| - | `.scrollReachedEnd(_:)` added |

With `Montage.ScrollView`, reaching the bottom is reported automatically, so passing nothing is equivalent to 3.x's `.automatic`. Only when you use a container that does not report it, such as `SwiftUI.ScrollView` or `List`, do you need to pass it yourself via `actionArea(scrollReachedEnd:)`.

**Wherever you used `.manual` to force a transparent background, pass the bottom-reached signal instead.** A screen with no scroll container at all (fixed-height content inside a popup or sheet) has nothing to raise the signal, so ActionArea assumes there is hidden content below and draws the gradient and background. Passing `true` hides the gradient and lets the background show through.

There are two places to pass it.

```swift
// as a modifier on a view
content
    .actionArea(scrollReachedEnd: true) { ActionArea(variant: …) }

// when passing through an actionArea: argument, as with BottomSheet and Popup - chain it on ActionArea itself
.popup(isPresented: $isPresented, actionArea: {
    ActionArea(variant: …)
        .scrollReachedEnd(true)
})
```

To change the background color itself, use `backgroundColor(_:)`. If neither approach fits, check with your designer whether that treatment is really needed.

The ActionArea spec was retuned in 4.0 as well.

| Item | 3.x | 4.0 |
|---|---|---|
| `extra` slot horizontal padding | 20 | **24** |
| `extra` slot bottom padding | 24 | **20** |
| `extra` divider color | `lineNeutralSecondary` | `lineNeutralTertiary` (lighter) |
| Caption typography | `label2` | `label2` + `weight: .medium` (heavier) |
| Caption icon | None | New 16pt slot via `.caption(_:icon:)` |

The horizontal padding of 20 on the main button row is unchanged.

#### ScreenScaffold

A new container assembles `TopNavigation`, the body, and `ActionArea` into one screen. The scroll-offset plumbing and bottom-inset math you used to hand-tune per screen are handled by the scaffold.

```swift
ScreenScaffold(
    navigation: { TopNavigation(title: title) },
    actionArea: { ActionArea(variant: .neutral(main: .init(text: "OK", action: submit))) }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

`ActionArea` goes in through `safeAreaInset(edge: .bottom)`, so the scroll container reserves that much content inset. **Remove the padding you used to add by hand to keep the last element from hiding under the button when scrolled to the bottom.**

| `scrollContainer` | When |
|---|---|
| `.builtIn` (default) | The scaffold lays down a `Montage.ScrollView` and measures scroll state itself |
| `.custom` | When you cannot swap the container, as with `List`. The content has to raise signals via `reportsScrollOffset(_:)` and `reportsScrollReachedEnd(_:)` |

The `navigation` and `actionArea` slot closures are **also not annotated with `@ViewBuilder`.** An `if` statement turns them into `_ConditionalContent` and breaks the type constraint, so to include one conditionally, branch on the closure itself, as in `actionArea: isEditing ? slot : nil`.

Do not put it inside `BottomSheet` or `Popup`. Those two do the same job and use the `ActionArea` height in their own height calculation, so pass it to their `actionArea:` argument instead. A full-screen cover or a pushed destination is a screen rather than a sheet, so it does not fall under this.

With `List`, you have to clear **both** the row background and the scroll background. Clearing only one hides the color you set with `backgroundColor(_:)`, and the seam shows when `ActionArea` goes transparent at the bottom.

---

#### ListCell

The `title*` family became `label*`, `fillWidth()` became `variant(_:)`, and `leadingContent {}` became `leadingResources([…])`.

| 3.x | 4.0 |
|---|---|
| `ListCell(title:)` | `ListCell(label:)` |
| `.titleVariant(_:)` / `.titleWeight(_:)` / `.titleColor(_:)` | `.labelVariant(_:)` / `.labelWeight(_:)` / `.labelColor(_:)` |
| `.caption(_:)` | `.description(_:)` |
| `.fillWidth(false)` | `.variant(.inset)` (default) |
| `.fillWidth(true)` | `.variant(.full)` |
| `.leadingContent { … }` | `.leadingResources([.slot { … }])` |
| `.interactionPadding(_:)` | Removed - folded into `variant` |
| `.verticalAlign(.bottom)` | Removed - only `.top` and `.center` remain |

```swift
// 3.x
ListCell(title: option.title) { onSelect() }
    .fillWidth()
    .leadingContent {
        Avatar(option.imageUrl, variant: .company, size: .xsmall)
    }

// 4.0
ListCell(label: option.title) { onSelect() }
    .variant(.full)
    .leadingResources([.slot {
        Avatar(option.imageUrl, variant: .company, size: .xsmall)
    }])
```

`inset` extends only the interaction background by 12 on each side with a corner radius of 16; `full` gives the cell its own horizontal padding of 20. The values line up with the old `fillWidth(false/true)`.

There are now four slots: `leadingResources`, `labelTrailingResources`, `trailingResources`, and `extraResources`. Common combinations ship as presets.

```swift
.leadingResources([.icon(.search), .checkbox(checked: isChecked)])
.leadingResources([.radio(checked: isSelected)])
.leadingResources([.avatar(url, variant: .company)])
.leadingResources([.thumbnail(url)])
.leadingResources([.slot { AnyCustomView() }])   // use slot when there is no preset
```

`verticalPadding` gained `.custom(CGFloat)`.

#### Chip

The image parameters became content slots.

| 3.x | 4.0 |
|---|---|
| `leadingImage:` / `trailingImage:` | `.leadingContent { … }` / `.trailingContent { … }` |
| `.imageColor(_:)` | Set it inside the slot |
| `.iconOnly(_:)` | Removed - just fill `leadingContent` |

The component no longer decides the icon size and color, so **the call site has to supply them.** Here is what 3.x used per size.

| Chip size | Icon size |
|---|---|
| `.large` | 16 |
| `.medium` · `.small` | 14 |
| `.xsmall` | 12 |

```swift
// 4.0
Chip(text: skill.name, variant: .outlined, size: .medium)
    .trailingContent {
        Image.icon(.close)
            .resizable()
            .frame(width: 14, height: 14)
            .foregroundStyle(Color.semantic(.foregroundNeutralTertiary))
    }
```

#### Slot preset names

Presets now follow a consistent `Component.Resource.SlotName` pattern.

```swift
// 3.x
TopNavigation.LeadingButton(TopNavigation.Resource.LeadingButtonInfo.back(action: { dismiss() }))

// 4.0
TopNavigation.LeadingButton(TopNavigation.Resource.Leading.back(action: { dismiss() }))
```

---

### 6. Straight API replacements

#### Button · TextButton

`fill(horizontal:vertical:)` was **removed** and replaced by `fillWidth(_:)`. There is no deprecation period; it is gone in 4.0, so move every call site.

| 3.x | 4.0 |
|---|---|
| `.fill(horizontal: true)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: false)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: true)` | `.fillWidth(true)` |

`vertical` already did nothing in 3.x. It existed only in the signature and was never used in the function body, so even the spots calling it with `vertical: true` never filled vertically. All three cases render the same, so a mechanical replacement is safe.

`TextButton` had no `fillWidth(_:)` in 3.x. It was added in 4.0, matching `Button`.

#### IconButton

The size of the `normal` variant changed from `Int` to a `NormalSize` enum.

| 3.x | 4.0 | Icon glyph | Container |
|---|---|---|---|
| `.normal(size: 16)` | `.normal(size: .small)` | 16 | 24 |
| `.normal(size: 18)` | `.normal(size: .medium)` | 18 | 28 |
| `.normal(size: 20)` | `.normal(size: .large)` | 20 | 32 |
| `.normal(size: 24)` | `.normal(size: .xlarge)` | 24 | 36 |

The glyph size is unchanged and **only the touch container grows**. Since this variant has no background or border, the effect is roughly a trailing icon shifting about 6px or a row growing about 8px taller.

#### Skeleton

It takes a typography variant instead of an array of variable widths. Line height and line count are derived from the variant.

```swift
// 3.x
Skeleton.SkeletonView(.text(lengths: [._25, ._50, ._75]))

// 4.0
Skeleton.SkeletonView(.text(variant: .body1))
```

Placeholder bar widths go from variable (25/50/75/100%) to uniform. To suggest multiple lines, place several `SkeletonView`s.

#### PushBadge

The variants were consolidated.

| 3.x | 4.0 |
|---|---|
| `.new` | `.text("N")` |
| `.number(count)` | `.maxCount(count, max: 99)` |

Instead of a minimum width plus padding for a single character, it is now a fixed `badgeSize` square (xsmall 16 / small 20 / medium 24). Narrow glyphs like `N` are pixel-identical, and a single CJK character or an `M`/`W` now keeps the circle round. Dynamic Type stops at `xxxLarge`.

#### FallbackView

It gained a padding interface, and **the minimum vertical padding is now built into the component.**

```swift
public enum Padding {
    case normal   // 160 (default)
    case compact  // 80
}
```

```swift
// 3.x - the padding came from outside
FallbackView(…)
    .padding(.vertical, 80)

// 4.0 - leave it to the component
FallbackView(…)
    .padding(.compact)
```

**Be sure to clear the padding and fixed heights you were applying from outside.** Leaving them in place double-applies them. In particular, `frame(height:)` overflows because the content does not fit within the minimum padding of 160 (or 80).

| 3.x | 4.0 |
|---|---|
| `.padding(.vertical, 160)` | Remove (the default `.normal` is 160) |
| `.padding(.vertical, 120)` | Remove |
| `.padding(.vertical, 80)` | `.padding(.compact)` |
| `.padding(.vertical, 48)` | `.padding(.compact)` |
| `.frame(height: 200)` | `.padding(.compact)` and remove the fixed height |

The button area goes through `buttonActionArea(_:)` (`.single` / `.horizontal` / `.vertical`).

---

### 7. Removed UIKit wrappers

The deprecated UIKit wrappers were removed. Bridge the SwiftUI components with `UIHostingController`.

| Removed | Replacement |
|---|---|
| `Montage.Button.SolidUIButton` | `Montage.Button(variant: .solid, …)` |
| `Montage.Button.OutlinedUIButton` | `Montage.Button(variant: .outlined, …)` |
| `ContentBadgeUIView` | `ContentBadge(…)` |

The specs are identical, so there is no difference in what gets rendered.

---

### 8. Component spec refresh

This is the section that is easy to miss because nothing fails to compile. **The API is unchanged and only the values moved**, so it only shows up when you look at the screen after the replacements are done.

#### Button

| Item | 3.x | 4.0 |
|---|---|---|
| radius | large 12 / medium 10 / small 8 | large **14** / medium **12** / small **10** / xsmall 8 |
| Height constraint | fixed `.frame(height:)` | `.frame(minHeight:)` |
| Icon size | large 24 / medium 24·22 / small 20·18 | large 22 / medium 22·20 / small 20·16 / xsmall 16 |
| Sizes | large · medium · small | **+ xsmall** |
| color | primary · assistive | **+ negative** |
| Typography | one step up per size | adjusted one step down per size |

**The height constraint going from fixed to a minimum has the widest impact.** In 3.x a long label was truncated onto one line (`Text...`); in 4.0 it **wraps and the button grows taller.** If you have buttons with long labels, the surrounding layout will shift.

#### Chip · FilterButton

Typography drops one step per size and padding was reduced, so **chips get smaller overall.**

| Chip size | 3.x typography | 4.0 typography |
|---|---|---|
| `large` | `body2` | `label1` |
| `medium` | `label1` | `label2` |
| `small` | `label1` | `caption1` |
| `xsmall` | `caption1` | `caption2` |

FilterButton gets a larger radius and less padding, so it ends up rounder and smaller.

#### Select

| Item | 3.x | 4.0 |
|---|---|---|
| Sizes | None | New `size(.large / .medium)` |
| min-height | - | Increased (the field gets taller) |
| Border color | - | Lighter |
| `heading` · `requiredBadge` | Built into the component | Removed - moved to `FormControl` |
| Vertical alignment | Always `top` | `top` only on `overflow`, `center` otherwise |

The alignment change is only noticeable at larger Dynamic Type sizes. Because 3.x always aligned to `top`, once the text grew taller than the leading icon and chevron (24pt), **only the icons appeared pushed up.** 4.0 uses `top` only in the `overflow` state where text wraps onto multiple lines, and centers it on a single line. The `ListCell` in the option list also got `verticalAlign(.center)`, so radios and checkboxes sit centered against the label.

#### TopNavigation · ModalNavigation

The background tint that appears while scrolling got denser.

| Item | 3.x and early 4.0 | 4.0 |
|---|---|---|
| Scroll background tint | `backgroundOpacity * 0.7` | `backgroundOpacity * 0.88` |

**The background gets darker** in the range where scrolling brings the navigation background in. There is no API change, only a value change, so nothing fails to compile. Please eyeball the screens where content passes under the navigation.

#### SegmentedControl

| Item | 3.x | 4.0 |
|---|---|---|
| variant | `solid` · `outlined` | **`outlined` removed** |
| Icon | `icon` toggle | `leadingIcon` + `iconOnly` |

#### Avatar · AvatarGroup

The cornerRadius of the company and academy variants goes up by **2** at every size.

| size | 3.x | 4.0 |
|---|---|---|
| `xsmall` | 6 | 8 |
| `small` | 8 | 10 |
| `medium` | 10 | 12 |
| `large` | 12 | 14 |
| `xlarge` | 14 | 16 |
| `custom(v)` | `ceil(v * 0.25 / 2) * 2` | `ceil(v * 0.25 / 2) * 2 + 2` |

The default border color moved from `lineAlternative` to `lineNeutralTertiary`, and the push-badge inset was retuned per size.

#### Everything else

The `Shadow`, `Typography`, `Opacity`, and `Spacing` definitions were adjusted, as were `Toast`, `SnackBar`, `Popup`, `Popover`, `Tooltip`, `Thumbnail`, `Accordion`, `Category`, and `ProgressTracker`. The new `Radius`, `Dimension`, `Primitive`, and `MaterialBackground` are additions.

---

## Changes that alter what you see

These compile fine but change the screen. **After migrating, please look at the screens in this list.**

| Target | What changes |
|---|---|
| **Button** | The height constraint went from fixed to a minimum, so **long labels wrap instead of truncating.** The button grows taller and pushes the surrounding layout. radius is also +2 per size |
| **Chip · FilterButton** | Typography drops one step and padding shrinks, so they **get smaller.** Wrap points change for chips and filter bars laid out horizontally |
| **Select** | min-height went up, so **the field gets taller.** The border also gets lighter. At larger Dynamic Type sizes, the leading icon and chevron that used to sit high are now centered |
| **SegmentedControl** | The `outlined` variant was removed. Places that used outlined become solid |
| **ActionArea** | The transparent background is now **tied to the scroll-reached-bottom signal.** In containers that do not raise it (`SwiftUI.ScrollView`, `List`, a popup with no scrolling), the background looks opaque, so you have to pass `scrollReachedEnd(_:)` yourself. The `extra` slot's horizontal padding went 20→24 and bottom 24→20, the divider got lighter, and the caption is heavier at `medium` weight |
| **Avatar · AvatarGroup** | company and academy cornerRadius +2 at every size. Company logos get slightly rounder |
| **FallbackView** | A minimum vertical padding of 160 is built in. Not clearing the outer padding and fixed height double-applies them. The description typography goes from `body2` to `body2Reading`, increasing line spacing |
| **Input components** | The label moves above the field, errors below it, and the counter below and trailing. Field height and overall form height change |
| **Character counter** | `Text("...")` interpolation adds a thousands separator at limits of 1000 and up (`5,000`). Use `Text(verbatim:)` |
| **disabled appearance** | The component's own `opacity` gave way to `isEnabled`-based color tokens. The double-applied opacity is gone, so it **looks less faded**. Custom views placed in ListCell slots (company logos and the like) no longer fade |
| **PlayBadge** | A 28% `coolNeutral40` tint was added to the background. The badge stays visible on bright thumbnails |
| **Toast · SnackBar** | Background opacity light 50% → 52%, dark 46% → 43% |
| **BottomSheet** | Background opacity 80% → 88% |
| **SearchField** | Two layers of solid tint; the inactive outlined background becomes `surfaceNeutralTertiary` |
| **TopNavigation · ModalNavigation** | The scroll background tint went from `0.7` to `0.88`, so **the navigation background gets darker while scrolling** |
| **Typography `caption2`** | The Dynamic Type scale curve moved from `.caption2` to `.caption`. The base size is unchanged, and the inversion where `caption2` grew larger than `caption1` at bigger sizes is resolved |
| **Avatar · Thumbnail** | `opacity43` is applied when disabled |
| **Skeleton** | Text placeholder bar widths go from variable to uniform (only while loading) |
| **IconButton** | Same glyph, larger touch container (about 6\~8px of layout shift) |
| **RedOrange tokens** | There is no counterpart for `accentForegroundRedOrange` and `accentBackgroundRedOrange`, so **the color changes** no matter what you move to. Find and check every spot that used them |

---

## Checklist

- [ ] After replacing color semantic tokens, check for leftovers with `grep -rn "\.label\(Normal\|Alternative\|Assistive\|Strong\|Neutral\|Disable\)\b"`
- [ ] Check for leftover `spacing(.pt` and `opacity(.p`
- [ ] Check for leftover `.disable(` (`.disabled(` is the correct one)
- [ ] Every `TextField`/`TextArea` is wrapped in a `FormControl`
- [ ] Character counters use `Text(verbatim:)` - prioritize spots with a limit of 1000 or more
- [ ] Outer `padding(.vertical,)` and `frame(height:)` removed wherever `FallbackView` is used
- [ ] No `if` statements inside `.actionArea {}` slots
- [ ] Chip slot icons have their size and color set at the call site
- [ ] Buttons with long labels do not wrap and push the layout
- [ ] Wherever `transparentBackground` was used with `.manual`, `scrollReachedEnd(_:)` is passed
- [ ] The ActionArea background looks as intended in popups and sheets with no scroll container
- [ ] Check the screens listed in [Component spec refresh](#8-component-spec-refresh) and [Changes that alter what you see](#changes-that-alter-what-you-see) on a device or simulator

> The fastest way to verify spec changes is to build Blueprint at both versions and compare.
>
> ```bash
> git worktree add --detach ../baseline v3.15.2   # the version you are coming from
> xcodebuild -workspace ../baseline/Montage.xcworkspace -scheme Blueprint \
>   -configuration Debug -destination 'id=<simulator udid>' \
>   -derivedDataPath /tmp/dd-before build
> ```

---

## 3.0

If you are coming from a version older than 3.0, see the [release notes](https://github.com/wanteddev/montage-ios/releases).
