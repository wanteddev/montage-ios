# Migration Guide

[English](./MIGRATION.md) | [한국어](./MIGRATION.ko.md)

Changes required to move between major versions. Newest first.

**This document covers breaking changes only.** New components and modifiers are listed by name under [Added APIs](#added-apis); see the [release notes](https://github.com/wanteddev/montage-ios/releases) for details.

Each major section is written against the **last release tag of the previous major**. APIs that appeared and disappeared during development are not listed, since nobody upgrading from the previous release ever saw them.

---

## 4.0

**Baseline: v3.15.2 → 4.0.0**

Breaking changes fall into four groups. Working top to bottom clears compile errors fastest.

| Order | Section | Kind | What you do |
|---|---|---|---|
| 1 | [Renamed](#1-renamed) | Mechanical | `sed` handles it |
| 2 | [Removed, needs rework](#2-removed-needs-rework) | Restructure | Move to the replacement API |
| 3 | [No replacement](#3-no-replacement) | Judgement call | You have to choose |
| 4 | [Visual changes](#4-visual-changes) | Eyeball it | **No compile errors** |

**Do not skip section 4.** Those entries keep the same API and change only values, so the build passes while the screen changes. A clean build does not mean the migration is done.

---

## 1. Renamed

### 1.1 Semantic color tokens

Every token name passed to `Color.semantic(_:)` / `UIColor.semantic(_:)` changes. Most are pure renames, but **14 also change the rendered color.** Check [Tokens whose value also changes](#tokens-whose-value-also-changes).

#### Naming rule

```
purpose + role + variant

purpose  foreground  text and icons
         background  page background
         surface     backgrounds of elements on the page (cards, fields, buttons)
         line        borders and dividers
         effect      dim and translucent layers

role     Neutral  Brand  Positive  Cautionary  Negative  Disable  Inactive  Accent{Color}

variant  Primary → Secondary → Tertiary → Quaternary  (decreasing contrast)
         Strong / Heavy   darker
         Subtle           lighter
         Inverse          for use on inverted backgrounds
         Focus            focus ring
         Opaque           opaque version (the suffix-less one is translucent)
```

The 3.x `Solid` prefix became the `Opaque` suffix in 4.0. The only thing to watch is that the marker moves from front to back: **`lineSolidNormal` → `lineNeutralPrimaryOpaque`**.

#### Foreground - text and icons

| 3.x | 4.0 | Value |
|---|---|---|
| `.labelNormal` | `.foregroundNeutralPrimary` | same |
| `.labelStrong` | `.foregroundNeutralStrong` | same |
| `.labelNeutral` | `.foregroundNeutralSecondary` | same |
| `.labelAlternative` | `.foregroundNeutralTertiary` | same |
| `.labelAssistive` | `.foregroundNeutralQuaternary` | same |
| `.inverseLabel` | `.foregroundNeutralInverse` | **slightly different** |
| `.labelDisable` | `.foregroundDisablePrimary` | same |
| `.interactionInactive` | `.foregroundInactivePrimary` | same |
| `.inversePrimary` | `.foregroundBrandInverse` | same |
| `.statusPositive` | `.foregroundPositivePrimary` | same |
| `.statusCautionary` | `.foregroundCautionaryPrimary` | same |
| `.statusNegative` | `.foregroundNegativePrimary` | same |
| `.accentForegroundBlue` | `.foregroundBrandPrimary` | **changed** |
| `.accentForegroundGreen` | `.foregroundPositivePrimary` | **changed** |
| `.accentForegroundOrange` | `.foregroundCautionaryPrimary` | **changed** |
| `.accentForegroundRed` | `.foregroundNegativeStrong` | **dark changed** |
| `.accentForegroundLime` | `.foregroundAccentLime` | **dark changed** |
| `.accentForegroundCyan` | `.foregroundAccentCyan` | **dark changed** |
| `.accentForegroundLightBlue` | `.foregroundAccentLightBlue` | **dark changed** |
| `.accentForegroundViolet` | `.foregroundAccentViolet` | **dark changed** |
| `.accentForegroundPurple` | `.foregroundAccentPurple` | **dark changed** |
| `.accentForegroundPink` | `.foregroundAccentPink` | **dark changed** |
| `.accentForegroundRedOrange` | none | see [3.1](#31-redorange-tokens) |

> Among `accentForeground{Color}`, Blue, Green, Orange, and Red **changed role from `Accent{Color}` to `Brand`, `Positive`, `Cautionary`, and `Negative`.** Do not just swap the name - confirm the spot really carries that role.

#### Background · Surface - page and element backgrounds

| 3.x | 4.0 | Value |
|---|---|---|
| `.backgroundNormal` | `.backgroundNeutralPrimary` | same |
| `.backgroundNormalAlternative` | `.backgroundNeutralSecondary` | same |
| `.backgroundElevated` | `.surfaceElevatedPrimary` | same |
| `.backgroundElevatedAlternative` | `.surfaceElevatedSecondary` | same |
| `.fillNormal` | `.surfaceNeutralSecondary` | same |
| `.fillAlternative` | `.surfaceNeutralTertiary` | same |
| `.fillStrong` | `.surfaceNeutralStrong` | same |
| `.backgroundStatusPositive` | `.surfacePositivePrimary` | same |
| `.backgroundStatusCautionary` | `.surfaceCautionaryPrimary` | same |
| `.backgroundStatusNegative` | `.surfaceNegativePrimary` | same |
| `.inverseBackground` | `.surfaceNeutralInverse` | same |
| `.primaryNormal` | `.surfaceBrandPrimary` | same |
| `.primaryStrong` | `.surfaceBrandStrong` | same |
| `.primaryHeavy` | `.surfaceBrandHeavy` | same |
| `.interactionDisable` | `.surfaceDisablePrimary` | same |
| `.accentBackgroundLime` | `.surfaceAccentLimeOpaque` | same |
| `.accentBackgroundCyan` | `.surfaceAccentCyanOpaque` | same |
| `.accentBackgroundLightBlue` | `.surfaceAccentLightBlueOpaque` | same |
| `.accentBackgroundViolet` | `.surfaceAccentVioletOpaque` | same |
| `.accentBackgroundPurple` | `.surfaceAccentPurpleOpaque` | same |
| `.accentBackgroundPink` | `.surfaceAccentPinkOpaque` | same |
| `.accentBackgroundRedOrange` | none | see [3.1](#31-redorange-tokens) |

> Only two `background` tokens remain (Primary and Secondary) for the page background. The rest moved to `surface`, and the translucent `backgroundTransparent*` pair moved to `effect`.
>
> `accentBackground{Color}` maps to the **opaque** variant by default. If you were layering it over something translucent, use the suffix-less `.surfaceAccent{Color}` (8% alpha).

#### Line - borders and dividers

| 3.x | 4.0 | Value |
|---|---|---|
| `.lineNormal` | `.lineNeutralPrimary` | same |
| `.lineNeutral` | `.lineNeutralSecondary` | same |
| `.lineAlternative` | `.lineNeutralTertiary` | same |
| `.lineSolidNormal` | `.lineNeutralPrimaryOpaque` | same |
| `.lineSolidNeutral` | `.lineNeutralSecondaryOpaque` | same |
| `.lineSolidAlternative` | `.lineNeutralTertiaryOpaque` | same |
| `.linePrimaryNormal` | `.lineBrandPrimary` | same |
| `.linePrimaryStrong` | `.lineBrandStrong` | same |
| `.lineStatusPositiveNormal` | `.linePositivePrimary` | same |
| `.lineStatusCautionaryNormal` | `.lineCautionaryPrimary` | same |
| `.lineStatusNegativeNormal` | `.lineNegativePrimary` | same |
| `.lineStatusNegativeStrong` | `.lineNegativeStrong` | same |

#### Effect - dim and translucent layers

| 3.x | 4.0 | Value |
|---|---|---|
| `.materialDimmer` | `.effectDimmerPrimary` | **dark changed** |
| `.backgroundTransparent` | `.effectTransparentPrimary` | same |
| `.backgroundTransparentAlternative` | `.effectTransparentSecondary` | same |

#### Tokens whose value also changes

Renaming these **changes the color.** Look at these spots after the substitution.

| 3.x → 4.0 | Light | Dark |
|---|---|---|
| `accentForegroundBlue` → `foregroundBrandPrimary` | `blue45` `#005EEB` → `blue50` `#0066FF` | `blue45` → `blue60` `#3385FF` |
| `accentForegroundGreen` → `foregroundPositivePrimary` | `green40` `#009632` → `green50` `#00BF40` | `green40` → `green60` `#1ED45A` |
| `accentForegroundOrange` → `foregroundCautionaryPrimary` | `orange39` `#D17600` → `orange50` `#FF9200` | `orange39` → `orange60` `#FFA938` |
| `accentForegroundRed` → `foregroundNegativeStrong` | same (`red40`) | `red40` `#E52222` → `red60` `#FF6363` |
| `accentForegroundLime` → `foregroundAccentLime` | same (`lime37`) | `lime37` `#429E00` → `lime50` `#58CF04` |
| `accentForegroundCyan` → `foregroundAccentCyan` | same (`cyan40`) | `cyan40` `#0098B2` → `cyan50` `#00BDDE` |
| `accentForegroundLightBlue` → `foregroundAccentLightBlue` | same (`lightBlue40`) | `lightBlue40` `#008DCF` → `lightBlue50` `#00AEFF` |
| `accentForegroundViolet` → `foregroundAccentViolet` | same (`violet45`) | `violet45` `#5B37ED` → `violet70` `#9E86FC` |
| `accentForegroundPurple` → `foregroundAccentPurple` | same (`purple40`) | `purple40` `#AD36E3` → `purple60` `#D478FF` |
| `accentForegroundPink` → `foregroundAccentPink` | same (`pink46`) | `pink46` `#E846CD` → `pink60` `#FA73E3` |
| `materialDimmer` → `effectDimmerPrimary` | same | `coolNeutral5` `#0F0F10` → `coolNeutral10` `#171719` (dim gets slightly lighter) |
| `inverseLabel` → `foregroundNeutralInverse` | `neutral99` `#F7F7F7` → `coolNeutral99` `#F7F7F8` | `neutral10` `#171717` → `coolNeutral10` `#171719` |

`accentForegroundBlue`, `Green`, and `Orange` **change in light mode too.** The other accent tokens move one step brighter in dark mode, and `inverseLabel` shifts by about 1/255, which is invisible in practice.

#### Tokens not in the tables

Primitive tokens (`neutral*`, `blue*`, `coolNeutral*`, …) keep both their names and their values.

Tokens introduced in 4.0 (`lineBrandFocus`, `lineNegativeFocus`, `surfaceBrandSubtle`, `surfaceNegativeStrong`, `foregroundAccent*`, …) have no 3.x counterpart, so they are absent from these tables. Look them up in `Color.Semantic`.

> The doc comments on `Color.Semantic` carry the old name as `(구 …)`, but a few of those names only ever existed during 4.0 development (`fillPrimary`, `fillNegative`, `interactionFocus`, `interactionNegative`). **If you are coming from 3.x, trust the tables in this document.**

#### Bulk substitution

No 3.x token name survives into 4.0, so anchoring on `\b` is enough to keep the substitution from hitting anything it shouldn't.

```bash
# check first
grep -rn "\.labelNormal\b" --include="*.swift" .

# substitute
find . -name "*.swift" -exec sed -i '' \
  -e 's/\.labelNormal\b/.foregroundNeutralPrimary/g' \
  -e 's/\.labelAlternative\b/.foregroundNeutralTertiary/g' \
  -e 's/\.backgroundNormal\b/.backgroundNeutralPrimary/g' \
  {} +
```

---

### 1.2 Spacing and Opacity tokens

The enum plus lookup function collapsed into a single static property, and the value now appears directly in the name.

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
| `.spacing(.pt01)` | `.spacing1` |
| `.spacing(.pt02)` | `.spacing2` |
| `.spacing(.pt04)` | `.spacing4` |
| `.spacing(.pt08)` | `.spacing8` |
| `.spacing(.pt12)` | `.spacing12` |
| `.spacing(.pt16)` | `.spacing16` |
| `.spacing(.pt20)` | `.spacing20` |
| `.spacing(.pt24)` | `.spacing24` |
| `.spacing(.pt28)` | **none** (see [3.2](#32-spacing-pt28-and-pt36)) |
| `.spacing(.pt32)` | `.spacing32` |
| `.spacing(.pt36)` | **none** (see [3.2](#32-spacing-pt28-and-pt36)) |
| `.spacing(.pt40)` | `.spacing40` |
| `.spacing(.pt48)` | `.spacing48` |
| `.spacing(.pt56)` | `.spacing56` |
| `.spacing(.pt64)` | `.spacing64` |
| `.spacing(.pt72)` | `.spacing72` |
| `.spacing(.pt80)` | `.spacing80` |

Note that **the leading zero disappears**: `pt08` becomes `spacing8`, not `spacing08`.

All 16 opacity tokens map one to one with identical values.

| 3.x | 4.0 |
|---|---|
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

Opacity tokens are now `Double`. Spots that used raw literals like `withAlphaComponent(0)` can be tidied to `withAlphaComponent(.opacity0)`.

The `Color.spacing(_:)` and `Color.opacity(_:)` static functions were removed.

---

### 1.3 Global modifiers

| 3.x | 4.0 | Note |
|---|---|---|
| `.disable(_:)` | `.disabled(_:)` | Absorbed into the standard SwiftUI modifier; components read the `isEnabled` environment value |
| `scrollStatus.scrolledToMax` | `scrollStatus.reachedEnd` | `ScrollStatus` property on `Montage.ScrollView` |

`disable()` → `disabled()` is more than a rename. In 3.x components dimmed the whole view by lowering its opacity; in 4.0 they read SwiftUI's `isEnabled` and swap in color tokens such as `foregroundDisablePrimary`. See [4. Visual changes](#4-visual-changes).

`Chip` and `FilterButton` already spelled it `disabled(_:)` in 3.x, but that was their own modifier returning `Self`. In 4.0 it is gone and the standard modifier takes over, which returns `some View`. **Chaining a component-specific modifier after `.disabled()` no longer compiles, so move `.disabled()` to the end of the chain.**

```swift
// 3.x
Chip(variant: variant, size: size, text: text)
    .disabled(disable)
    .active(active)

// 4.0 - .disabled() returns some View, not Chip
Chip(variant: variant, size: size, text: text)
    .active(active)
    .disabled(disable)
```

A `.disabled(true)` set on an ancestor view now changes the colors of both components too. In 3.x they picked colors from their own property, so an inherited `.disabled()` blocked touches but left the colors alone.

---

### 1.4 Component renames

#### ListCell

| 3.x | 4.0 |
|---|---|
| `ListCell(title:)` | `ListCell(label:)` |
| `.titleVariant(_:)` | `.labelVariant(_:)` |
| `.titleWeight(_:)` | `.labelWeight(_:)` |
| `.titleColor(_:)` | `.labelColor(_:)` |
| `.caption(_:)` | `.description(_:)` |
| `.fillWidth(false)` | `.variant(.inset)` (default) |
| `.fillWidth(true)` | `.variant(.full)` |

`inset` extends only the interaction background by 12 on each side with a corner radius of 16; `full` gives the cell its own horizontal padding of 20. These are the same values 3.x used for `fillWidth(false)` and `fillWidth(true)`, so renaming alone leaves the screen unchanged.

Slot changes are in [2.5 ListCell slots](#25-listcell-slots).

#### TopNavigation slot presets

Preset namespaces were unified to `Component.Resource.SlotName`.

| 3.x | 4.0 |
|---|---|
| `TopNavigation.Resource.LeadingButtonInfo` | `TopNavigation.Resource.Leading` |
| `TopNavigation.Resource.TrailingButtonInfo` | `TopNavigation.Resource.Trailing` |

```swift
// 3.x
TopNavigation.LeadingButton(TopNavigation.Resource.LeadingButtonInfo.back(action: { dismiss() }))

// 4.0
TopNavigation.LeadingButton(TopNavigation.Resource.Leading.back(action: { dismiss() }))
```

#### Input components

| 3.x | 4.0 | Applies to |
|---|---|---|
| `.heading(_:)` | `.label(_:required:)` | `TextField`, `TextArea`, `Select` |
| `.requiredBadge(_:)` | the `required` argument of `.label(_:required:)` | `TextField`, `TextArea`, `Select` |
| `.description(_:)` | `.message(_:)` | `TextArea`, `Select` |
| `.inputCharacterLimit(_:)` | `.maxLength(_:)` | `TextArea` |
| `.status(.negative(description:))` | `.status(.negative)` + `.message(_:)` | `TextField` |

`TextField.Status` lost its associated values: `.normal()` → `.normal`, `.negative(description:)` → `.negative`.

The structural part of this change is in [2.1 Input labels, messages, and counters](#21-input-labels-messages-and-counters).

#### Button and TextButton

`fill(horizontal:vertical:)` was removed in favour of `fillWidth(_:)`.

| 3.x | 4.0 |
|---|---|
| `.fill(horizontal: true)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: false)` | `.fillWidth(true)` |
| `.fill(horizontal: true, vertical: true)` | `.fillWidth(true)` |

`vertical` never did anything in 3.x either. The function took the parameter and threw it away, so even `vertical: true` call sites never got a taller button. All three cases render identically, so the substitution is purely mechanical.

#### IconButton

The size of the `normal` variant moved from `Int` to the `NormalSize` enum.

| 3.x | 4.0 | Icon glyph | Container |
|---|---|---|---|
| `.normal(size: 16)` | `.normal(size: .small)` | 16 | 24 |
| `.normal(size: 18)` | `.normal(size: .medium)` | 18 | 28 |
| `.normal(size: 20)` | `.normal(size: .large)` | 20 | 32 |
| `.normal(size: 24)` | `.normal(size: .xlarge)` | 24 | 36 |

The glyph stays the same size and **only the touch container grows.** Since this variant has no background or border, the visible effect is a trailing icon shifting by about 6pt or a row growing by about 8pt.

For any other size, see [3.3 IconButton non-standard sizes](#33-iconbutton-non-standard-sizes).

#### PushBadge

| 3.x | 4.0 |
|---|---|
| `.new` | `.text("N")` |
| `.number(count)` | `.maxCount(count, max: 99)` |

Instead of a minimum width plus padding for a single character, the badge is now a `badgeSize` square (xsmall 16 / small 20 / medium 24). Narrow glyphs like `N` are pixel-identical, and a single wide character (CJK, `M`, `W`) no longer squashes the badge.

There is also a scaling cap. In 3.x the badge kept growing all the way into the accessibility text sizes; 4.0 stops it at `xxxLarge`. The icon or avatar underneath does not scale with Dynamic Type, so a badge that kept growing would cover it.

#### SegmentedControl

| 3.x | 4.0 |
|---|---|
| `Item(image:title:)` | `Item(leadingIcon:title:)` |
| `icon` toggle | `.iconOnly(_:)` |

For the removal of `variant(_:)`, see [3.4](#34-segmentedcontrol-outlined-variant).

#### Accordion

The no-argument `trailingContent` overload is gone; only the one taking the expanded flag (`Bool`) remains.

```swift
// 3.x
.trailingContent { Chevron() }

// 4.0
.trailingContent { _ in Chevron() }
```

#### Parameters dropped from init

Disabled state and background color moved out of `init` into modifiers.

| 3.x | 4.0 |
|---|---|
| `TopNavigation(scrollOffset:backgroundColor:)` | `TopNavigation(scrollOffset:)` + `.backgroundColor(_:)` |
| `TopNavigation.TrailingIconButton(icon:disable:showPushBadge:action:)` | `(icon:showPushBadge:action:)` + `.disabled(_:)` |
| `TopNavigation.TrailingTextButton(text:disable:action:)` | `(text:action:)` + `.disabled(_:)` |
| `framedStyle(status:borderRadius:shadowLevel:disabled:)` | `framedStyle(status:borderRadius:shadowLevel:)` + `.disabled(_:)` |

Anywhere you passed `disable:`, use the standard SwiftUI `.disabled(_:)` the same way as in [1.3 Global modifiers](#13-global-modifiers).

#### Skeleton

It now takes a typography variant instead of an array of widths, deriving line height and line count from the variant.

```swift
// 3.x
Skeleton.SkeletonView(.text(lengths: [._25, ._50, ._75]))

// 4.0
Skeleton.SkeletonView(.text(variant: .body1))
```

Placeholder bar widths change from variable (25/50/75/100%) to uniform. To mimic multiple lines, place several `SkeletonView`s.

#### Avatar

The default for `border(color:)` changed from `.lineAlternative` to `.lineNeutralTertiary`. That is the new name for the same color, so nothing renders differently.

---

## 2. Removed, needs rework

### 2.1 Input labels, messages, and counters

In 3.x the `TextField` drew its own label and error message. In 4.0 `TextField`, `TextArea`, and `Select` draw just the input field, and attaching `label`, `message`, or `accessory` **wraps it in a `FormControl` that places the label and message instead.**

```swift
// what .label() / .message() build for you in 4.0
FormControl {
    TextField(text: $email)   // draws the input only
}
.label("Email")               // label goes above the field
.message(errorMessage)        // message goes below it
```

The wrapping is automatic, so call sites only swap modifiers. But **the view hierarchy changes, so field height and overall form height change with it.** This is not a rename-and-done substitution.

| 3.x (inside the field) | 4.0 | Position |
|---|---|---|
| `.heading("Email")` | `.label("Email")` | **above** the field |
| `.requiredBadge(true)` | `.label("Email", required: true)` | next to the label |
| `.status(.negative(description: msg))` | `.status(.negative)` + `.message(msg)` | **below** the field |
| `.bottomResources(trailing: [.characterCount(limit:)])` | `.accessory { … }` | below the field, **trailing** |
| `.disable(_:)` | `.disabled(_:)` | - |

#### TextField

```swift
// 3.x
Montage.TextField(text: $email)
    .heading(String(localized: "Email"))
    .placeholder(String(localized: "Enter your email."))
    .status(isInvalidated ? .negative(description: errorMessage) : .normal())
    .disable(isDisabled)

// 4.0
Montage.TextField(text: $email)
    .label(String(localized: "Email"))
    .placeholder(String(localized: "Enter your email."))
    .status(isInvalidated ? .negative : .normal)
    .message(isInvalidated ? errorMessage : nil)
    .disabled(isDisabled)
```

The label becomes the input's accessibility label and the message its accessibility hint.

#### TextArea with a character counter

```swift
// 3.x
TextArea(text: $feedback, focus: $focus)
    .resize(.fixed(min: 116, max: 116))
    .placeholder("Tell us what worked and what didn't.")
    .bottomResources(trailing: [.characterCount(limit: 1000)])

// 4.0
TextArea(text: $feedback, focus: $focus)
    .maxLength(1000)
    .resize(.fixed(min: 116, max: 116))
    .placeholder(String(localized: "Tell us what worked and what didn't."))
    .accessory {
        Text(verbatim: "\(feedback.count)/1000")
            .typography(variant: .label2, weight: .medium, semantic: .foregroundNeutralTertiary)
    }
```

The `.characterCount` resource was removed - the call site now draws the counter. Two things to watch:

- **Set the input limit on the field with `maxLength(_:)`.** Displaying the counter and enforcing the limit are now separate.
- **Use `Text(verbatim:)`.** `Text("\(count)/\(limit)")` goes through `LocalizedStringKey` interpolation, which adds a locale thousands separator once the limit reaches 1000 (`5,000`). With `verbatim:` you get `5000`.

All three share the same five modifiers:

`.label(_:required:)` · `.message(_:)` · `.labelPlacement(_:)` · `.labelWidth(_:)` · `.accessory { }`

#### When to wrap in FormControl

Using any one of those modifiers wraps the input in a `FormControl` internally, so most screens never need to write one. Reach for it directly in three cases:

- wrapping an input component you built yourself
- which input component goes in changes at runtime and you want the wrapper settings in one place
- aligning label widths across several fields with `FormControlGroup`

```swift
FormControl { context in
    Montage.TextField(text: $email)
        .status(context.status.textFieldStatus)
        .placeholder(String(localized: "Enter your email."))
}
.label(String(localized: "Email"))
.status(isInvalidated ? .negative : .normal)
.message(isInvalidated ? errorMessage : nil)
```

`size` and `status` resolve in this order: **value set on the component → value propagated from `FormControl` → default** (`.large` / `.normal`). They propagate into the slot, so setting them once on the `FormControl` is usually enough. Setting the status separately on the component can leave the label and message colors out of sync, so pass it down through `context.status` as shown above.

The remaining `FormControl` modifiers: `size(.large/.medium)`, `labelPlacement(.top/.leading)`, `labelWidth(_:)`, `label(_:required:)`.

#### If you have your own input wrapper

For a wrapper like `AutoCompleteTextInput` that hides a `TextField` inside, **wrap the wrapper in a `FormControl`** and expose status and message through the wrapper's own interface. Putting `FormControl` inside the wrapper makes it hard to supply the label from outside.

---

### 2.2 TextArea bottom resources

Both the signature and the resource types of `bottomResources` changed.

```swift
// 3.x - one Resource type for both slots
public func bottomResources(
    leading leadingResources: [Resource] = [],
    trailing trailingResources: [Resource] = [],
    leadingResourceSpacing: CGFloat = 4,
    trailingResourceSpacing: CGFloat = 4
) -> Self

// 4.0 - the type differs per slot
public func bottomResources(
    leading: [Resource.Leading] = [],
    trailing: [Resource.Trailing] = [],
    leadingResourceSpacing: CGFloat? = nil,
    trailingResourceSpacing: CGFloat? = nil
) -> Self
```

- The argument label changed from `leading leadingResources:` to `leading:`.
- The default spacing between resources moved from a fixed `4` to **a size-dependent default (large 8 / medium 6)**. If you never passed it explicitly, the gap widens.

Preset mapping:

| 3.x `Resource` | 4.0 |
|---|---|
| `.icon` | `Resource.Leading.icon` / `Resource.Trailing.icon` |
| `.iconButton` | `Resource.Leading.iconButton` / `Resource.Trailing.iconButton` |
| `.characterCount` | removed - use `accessory` from [2.1](#21-input-labels-messages-and-counters) |
| `.textButton`, `.chip`, `.filterButton`, `.badge` | **no replacement** (see [3.6](#36-textarea-bottom-resource-presets)) |
| - | `.contentBadge` and `.segmentedControl` added; `.button` and `.primaryIconButton` added for trailing only |
| no `.slot` | `Resource.Leading.slot { }` / `Resource.Trailing.slot { }` |

Anything without a preset goes through `slot(_:)`.

---

### 2.3 ActionArea

The `Model` struct and the fixed parameters are gone; the call site supplies the view.

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

`modalActionArea(_:)` on `BottomSheet` and `Popup` also changed from `ActionArea.Model?` to `(() -> ActionArea)?`.

The `actionArea` slot closure is **not** `@ViewBuilder`. An `if` statement produces `_ConditionalContent` and breaks the `ActionArea` type constraint. Use a ternary or a modifier chain instead.

```swift
// does not work
.actionArea { if isEditing { ActionArea(variant: a) } else { ActionArea(variant: b) } }

// do this
.actionArea { ActionArea(variant: isEditing ? a : b) }
```

#### Transparent background control

The API for driving the transparent background directly is gone. In 4.0 the background and the top gradient are both derived from one signal: whether the scroll view reached its end (`scrollReachedEnd`).

| 3.x | 4.0 |
|---|---|
| `.transparentBackground(_:)` | removed |
| `ActionArea.BackgroundTransparencyControl` (`.automatic` / `.manual`) | removed |
| `actionArea(backgroundTransparency:)` | removed - use `actionArea(scrollReachedEnd:)` |

| `scrollReachedEnd` | `extra` slot | Top gradient | Background |
|---|---|---|---|
| not passed, or `false` | any | shown | opaque |
| `true` | empty | hidden | **transparent** |
| `true` | non-empty | hidden | opaque |

The gradient signals "there is content hidden below" and fades in and out over 0.5 seconds.

With `Montage.ScrollView` the reached-end signal propagates automatically, so passing nothing is equivalent to 3.x's `.automatic`. Pass it yourself only for containers that do not report it, such as `SwiftUI.ScrollView` or `List`.

**Where you used `.manual` to force a transparent background, pass the reached-end signal directly.** A screen with no scroll container at all (fixed-height content inside a popup or sheet) has nothing to report, so the ActionArea assumes content is hidden below and draws the gradient and background. Passing `true` hides the gradient and lets the background show through.

There are two places to pass it.

```swift
// as a view modifier
content
    .actionArea(scrollReachedEnd: true) { ActionArea(variant: …) }

// via an actionArea: argument, as on BottomSheet and Popup - chain it on the ActionArea itself
.popup(isPresented: $isPresented, actionArea: {
    ActionArea(variant: …)
        .scrollReachedEnd(true)
})
```

To change the background color itself, use `backgroundColor(_:)` (it applies to both the background and the gradient's start color). If neither approach covers your screen, [open an issue](https://github.com/wanteddev/montage-ios/issues).

Spec changes are in [4. Visual changes](#4-visual-changes).

---

### 2.4 View.topNavigation(...) removed

Both `View.topNavigation(...)` modifiers were removed. Place the `TopNavigation` component yourself, or assemble the screen with the new `ScreenScaffold`.

```swift
// 3.x
content
    .topNavigation(
        title: "Settings",
        leadingContent: { TopNavigation.LeadingButton(.back(action: { dismiss() })) },
        withBottom: .init(variant: .neutral(main: .init(text: "Save", action: save)))
    )

// 4.0
ScreenScaffold(
    navigation: {
        TopNavigation(title: "Settings")
            .leadingContent { TopNavigation.LeadingButton(.back(action: { dismiss() })) }
    },
    actionArea: {
        ActionArea(variant: .neutral(main: .init(text: "Save", action: save)))
    }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

`ScreenScaffold` assembles `TopNavigation` + content + `ActionArea` into one screen and takes over the scroll-offset plumbing and bottom-inset math you used to wire up per screen.

It inserts the `ActionArea` with `safeAreaInset(edge: .bottom)`, so the scroll container reserves that much content inset. **Remove any manual bottom padding you added so the last row would clear the buttons.**

| `scrollContainer` | When |
|---|---|
| `.builtIn` (default) | The scaffold lays down a `Montage.ScrollView` and measures scroll state itself |
| `.custom` | When the container cannot be swapped, e.g. `List`. The content must report through `reportsScrollOffset(_:)` and `reportsScrollReachedEnd(_:)` |

The `navigation` and `actionArea` slot closures are **not `@ViewBuilder` either.** To include one conditionally, split the closure itself: `actionArea: isEditing ? slot : nil`.

Do not put it inside `BottomSheet` or `Popup`. Those do the same job and use the `ActionArea` height in their own height calculation, so pass it through their `actionArea:` argument instead. A full-screen cover or a pushed destination is a screen, not a sheet, so this does not apply there.

With `List`, strip **both** the row background and the scroll background. Handling only one hides the color set via `backgroundColor(_:)`, and the seam shows once the `ActionArea` turns transparent at the bottom.

---

### 2.5 ListCell slots

`leadingContent {}` and `trailingContent {}` were replaced by four slot modifiers taking preset arrays.

| 3.x | 4.0 |
|---|---|
| `.leadingContent { … }` | `.leadingResources([.slot { … }])` |
| `.trailingContent { _ in … }` | `.trailingResources([.slot { … }])` |
| `.interactionPadding(_:)` | removed - folded into `variant(_:)` |
| `.verticalAlign(_:)` taking `VerticalAlignment` | `ListCell.VerticalAlign` |

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

There are now four slots: `leadingResources`, `labelTrailingResources`, `trailingResources`, and `extraResources`. Common combinations ship as presets.

```swift
.leadingResources([.icon(.search), .checkbox(checked: isChecked)])
.leadingResources([.radio(checked: isSelected)])
.leadingResources([.avatar(url, variant: .company)])
.leadingResources([.thumbnail(url)])
.leadingResources([.slot { AnyCustomView() }])   // slot when no preset fits
```

For `.verticalAlign(.bottom)`, see [3.5](#35-listcell-verticalalignbottom).

---

### 2.6 Chip image slots

Image parameters became content slots.

| 3.x | 4.0 |
|---|---|
| `leadingImage:` / `trailingImage:` | `.leadingContent { … }` / `.trailingContent { … }` |
| `.imageColor(_:)` | set it inside the slot |
| `.iconOnly(_:)` | removed - just fill `leadingContent` |

The component no longer decides the icon size and color, so **the call site has to supply them.** These are the values 3.x applied per size.

| Chip size | Icon size |
|---|---|
| `.large` | 16 |
| `.medium`, `.small` | 14 |
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

---

### 2.7 FallbackView padding

`image:` and `button:` were dropped from `init`.

| 3.x | 4.0 |
|---|---|
| `FallbackView(image:title:description:button:)` | `FallbackView(title:description:)` |
| the `button:` slot | `buttonActionArea(_:)` |
| the `image:` slot | **no replacement** ([3.7](#37-fallbackview-image-slot)) |

A `Padding` enum was also added, and **the minimum vertical padding is now built into the component.**

```swift
public enum Padding {
    case normal   // 160 (default)
    case compact  // 80
}
```

```swift
// 3.x - padding came from outside
FallbackView(…)
    .padding(.vertical, 80)

// 4.0 - the component owns it
FallbackView(…)
    .padding(.compact)
```

**Remove the outer padding and any fixed height.** Leaving them in place doubles the padding. A `frame(height:)` in particular will overflow, since the content no longer fits inside the built-in 160 (or 80) minimum.

| 3.x | 4.0 |
|---|---|
| `.padding(.vertical, 160)` | remove (default `.normal` = 160) |
| `.padding(.vertical, 120)` | remove |
| `.padding(.vertical, 80)` | `.padding(.compact)` |
| `.padding(.vertical, 48)` | `.padding(.compact)` |
| `.frame(height: 200)` | `.padding(.compact)` and drop the fixed height |

The button area goes through `buttonActionArea(_:)` (`.single` / `.horizontal` / `.vertical`).

---

### 2.8 Removed UIKit wrappers

The deprecated UIKit wrappers were removed. Bridge the SwiftUI components with `UIHostingController`.

| Removed | Replacement |
|---|---|
| `Montage.Button.SolidUIButton` | `Montage.Button(variant: .solid, …)` |
| `Montage.Button.OutlinedUIButton` | `Montage.Button(variant: .outlined, …)` |
| `ContentBadgeUIView` | `ContentBadge(…)` |
| `InteractionUIView` | the `Interaction` modifier |

The specs are identical, so nothing renders differently.

---

## 3. No replacement

There is no mechanical equivalent for these, so **you have to choose.** Substituting something that looks close will hide the fact that the result changed.

### 3.1 RedOrange tokens

There is no 4.0 token for `accentForegroundRedOrange` or `accentBackgroundRedOrange`. The `redOrange*` primitives are still there.

A one-to-one substitution is impossible, so look at what the spot meant and pick deliberately - and **whatever you pick, the color changes.**

In the Wanted app all three usages were text or icon colors, so they moved to `.foregroundNegativePrimary`, turning `redOrange50/60` into `red50/60`. If you used it as a surface color, `.surfaceNegativePrimary` or the `redOrange*` primitive directly stays closer to the original value.

### 3.2 Spacing pt28 and pt36

The 4.0 spacing scale has no `28` or `36`. The new scale is `0, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 24, 32, 40, 48, 56, 64, 72, 80`.

Anywhere you used `.spacing(.pt28)` or `.spacing(.pt36)` you have to pick between `spacing24`, `spacing32`, and `spacing40`, and **the layout shifts by 4pt.** If you truly need an off-scale value, use a literal. But literals piling up across a screen is a sign its spacing needs another look.

```bash
grep -rn "spacing(\.pt28\|spacing(\.pt36" --include="*.swift" .
```

### 3.3 IconButton non-standard sizes

Sizes other than the four standard ones (16, 18, 20, 24) move to `NormalSize.custom(size:)`, where **`size` changes meaning from icon size to container size.**

In 3.x `.normal(size: n)` made the container the same `n` as the icon. In 4.0 `.custom(size: n)` treats `n` as the container edge and derives the icon from the dimension token nearest to two thirds of it. The container is clamped to `[24, 64]`.

```swift
// 3.x - n is the icon size
IconButton(variant: .normal(size: 22), icon: .search)

// 4.0 - n is the container size and the icon is derived from it
IconButton(variant: .normal(size: .custom(size: 32)), icon: .search)  // icon 20
```

Reusing the 3.x number shrinks the icon: `.custom(size: 22)` clamps the container to 24, giving a 16pt icon. Pick the container value that yields the icon size you want.

| Container | 24 | 28 | 32 | 36 | 40 | 48 | 56 | 64 |
|---|---|---|---|---|---|---|---|---|
| Icon | 16 | 18 | 20 | 24 | 28 | 32 | 36 | 40 |

### 3.4 SegmentedControl outlined variant

The `Variant` enum and the `variant(_:)` modifier were removed entirely. Everything collapses to `solid`, so **the outlined appearance is gone.**

### 3.5 ListCell verticalAlign(.bottom)

Only `.top` and `.center` remain. Anywhere that needed bottom alignment has to be restructured or settle for `.top`.

### 3.6 TextArea bottom resource presets

`Resource.textButton`, `.chip`, `.filterButton`, and `.badge` were removed. Draw them yourself with `Resource.Leading.slot { }` / `Resource.Trailing.slot { }`, or check whether the new `.button` and `.contentBadge` (trailing) match your intent.

### 3.7 FallbackView image slot

3.x let you pass an illustration through `image:`, but 4.0's `FallbackView` has no image API at all. Only the title, description, and button area remain.

If you need the illustration, assemble the empty state yourself instead of using `FallbackView`. Leave it as is and **the illustration disappears from those screens.**

### 3.8 AvatarGroup variant

`variant:` was dropped from `AvatarGroup(_:variant:size:onTap:)`, which is now fixed to `.person`. Anywhere 3.x grouped company or academy logos with `company` / `academy`, 4.0 renders **circles instead of rounded rectangles.**

You will delete the argument to fix the compile error - check what that spot renders while you are there.

### 3.9 TextField trailing button color

`variant: Button.Color` was dropped from `TextField.TrailingButtonInfo(variant:title:disable:handler:)`. 4.0 fixes the button to outlined, so a verification button you had emphasised with `primary` changes color.

### 3.10 Other removals

| Removed | Note |
|---|---|
| `ModalNavigation.Variant.extended` | no replacement |
| `ModalNavigation.Variant.floating(alternative:background:)` | only the argument-less `.floating` remains |
| `Select.shadowBackgroundColor(_:)` | no replacement |
| `Skeleton.Length` (`_25`/`_50`/`_75`/`_100`) | widths are now uniform |

---

## 4. Visual changes

**These compile cleanly but change the screen.** The API is unchanged, so they only surface once you look at the result of the migration.

### 4.1 Component specs

#### Button

| Item | 3.x | 4.0 |
|---|---|---|
| radius | large 12 / medium 10 / small 8 | large **14** / medium **12** / small **10** / xsmall 8 |
| height constraint | fixed `.frame(height:)` | `.frame(minHeight:)` |
| icon size | large 24 / medium 24·22 / small 20·18 | large 22 / medium 22·20 / small 20·16 / xsmall 16 |
| typography | one step up per size | adjusted one step down per size |

**The height constraint moving from fixed to minimum has the widest blast radius.** 3.x truncated a long label to one line (`Some text...`); 4.0 **wraps it and the button grows taller.** Any button with a long label will push the surrounding layout.

#### Chip and FilterButton

Typography drops one step per size and padding shrinks, so **chips get smaller overall.**

| Chip size | 3.x typography | 4.0 typography |
|---|---|---|
| `large` | `body2` | `label1` |
| `medium` | `label1` | `label2` |
| `small` | `label1` | `caption1` |
| `xsmall` | `caption1` | `caption2` |

FilterButton gets a larger radius and less padding, making it rounder and smaller.

#### Select

| Item | 3.x | 4.0 |
|---|---|---|
| min-height | - | increased (the field gets taller) |
| border color | - | lighter |
| vertical alignment | always `top` | `top` only on `overflow`, `center` otherwise |

The alignment change is only visible at larger Dynamic Type sizes. 3.x always aligned to the top, so once the text grew past the leading icon and chevron (24pt), **the icons looked stuck to the top.** 4.0 uses `top` only when the text overflows onto multiple lines and centers it otherwise. The `ListCell`s in the option list also got `verticalAlign(.center)`, so radios and checkboxes sit centered on the label.

#### ActionArea

| Item | 3.x | 4.0 |
|---|---|---|
| `extra` slot horizontal padding | 20 | **24** |
| `extra` slot bottom padding | 24 | **20** |
| `extra` divider color | `lineNeutral` (= `lineNeutralSecondary`) | `lineNeutralTertiary` (lighter) |
| caption typography | `label2` | `label2` with `weight: .medium` (bolder) |
| `alternative` action button | `outlined` / `primary` | `outlined` / **`assistive`** |
| `cancel` main action button | `outlined` / `assistive` | **`solid`** / `assistive` |

The main button row keeps its horizontal padding of 20.

The button colors are an API-compatible change, so nothing fails to compile. The alternative action's label goes from blue to black, increasing contrast against the primary action, and the `cancel` variant's main button goes from outlined to a grey fill. The `sub` action is unchanged.

#### TopNavigation and ModalNavigation

| Item | 3.x | 4.0 |
|---|---|---|
| scroll background tint | `backgroundOpacity * 0.7` | `backgroundOpacity * 0.88` |
| icon button press | A grey rectangular layer behind the icon | The icon drops to 22% opacity |

**The navigation background gets darker** in the range where scrolling reveals it.

The `IconButton` container (36pt) is larger than the navigation bar's `.frame(24)`, so the press layer visibly spilled outside the button. 4.0 fades the icon instead (`interactionEffect(.dim)`). The touch area is unchanged. This applies to both leading (`back`, `icon`) and trailing icon buttons; text buttons are unaffected.

#### Avatar and AvatarGroup

The cornerRadius of the company and academy variants goes up by **2** at every size.

| size | 3.x | 4.0 |
|---|---|---|
| `xsmall` | 6 | 8 |
| `small` | 8 | 10 |
| `medium` | 10 | 12 |
| `large` | 12 | 14 |
| `xlarge` | 14 | 16 |
| `custom(v)` | `ceil(v * 0.25 / 2) * 2` | `ceil(v * 0.25 / 2) * 2 + 2` |

The placeholder drawn when there is no image also changed from a dedicated illustration to an icon glyph (`personFill` / `companyFill` / `graduationFill`). Push badge insets were adjusted per size as well.

#### Everything else

`Shadow`, `Typography`, `Opacity`, and `Spacing` definitions were adjusted, as were `Toast`, `SnackBar`, `Popup`, `Popover`, `Tooltip`, `Thumbnail`, `Accordion`, `Category`, and `ProgressTracker`.

### 4.2 Full list

**Walk through these screens after migrating.**

| Target | What changes |
|---|---|
| **Color tokens** | `accentForegroundBlue`, `Green`, and `Orange` change in both light and dark; the other `accentForeground*` tokens and `materialDimmer` change in dark. See [Tokens whose value also changes](#tokens-whose-value-also-changes) |
| **RedOrange tokens** | No matching token, so **the color changes whatever you pick.** Find every usage |
| **Spacing pt28 / pt36** | No matching value, so you pick from 24/32/40 and the layout shifts by 4pt |
| **Button** | The height constraint moved from fixed to minimum, so **long labels wrap instead of truncating.** The button grows taller and pushes the surrounding layout. radius also +2 per size |
| **Chip / FilterButton** | Typography drops a step and padding shrinks, so **they get smaller.** Wrap points change in horizontal chip and filter rows |
| **Select** | min-height goes up, so **the field gets taller.** The border also gets lighter. At large Dynamic Type sizes the leading icon and chevron no longer stick to the top |
| **SegmentedControl** | `outlined` variant removed; those spots fall back to solid |
| **ActionArea** | The transparent background is now **tied to the scroll reached-end signal.** Containers that do not report it (`SwiftUI.ScrollView`, `List`, non-scrolling popups) keep the gradient and the opaque background, so pass `scrollReachedEnd(true)` yourself. The background only turns transparent when the `extra` slot is empty. `extra` slot horizontal padding 20→24, bottom 24→20, lighter divider, caption bolder at `medium` weight. **The alternative action's label goes from blue to black and the `cancel` main button from outlined to a grey fill** |
| **AvatarGroup variant** | `variant:` is fixed to `.person`, so groups that used company or academy render **as circles instead of rounded rectangles** |
| **Avatar / AvatarGroup** | company and academy cornerRadius +2 at every size. The no-image placeholder changed from an illustration to an icon glyph. `opacity43` when disabled |
| **FallbackView** | The `image:` slot is gone, so **the illustration disappears.** 160 minimum vertical padding is built in; outer padding and fixed heights double up if you leave them. The description typography moved from `body2` to `body2Reading`, increasing line spacing |
| **TextField trailing button** | `variant:` is gone and the button is fixed to outlined, changing the color of buttons you had emphasised with `primary` |
| **Input components** | The label moves above the field, the error below it, and the counter below and to the right. Field height and overall form height change |
| **TextArea bottom resources** | The default gap between resources moves from a fixed 4 to size-dependent values (large 8 / medium 6) |
| **Character counter** | `Text("...")` interpolation adds a thousands separator at limits of 1000 or more (`5,000`). Use `Text(verbatim:)` |
| **Disabled state** | Instead of each component lowering its own opacity, colors now come from `isEnabled`-driven tokens. Opacity no longer stacks, so things **look less faded.** Custom views placed in `ListCell` slots (company logos and so on) are no longer dimmed. **A `.disabled(true)` on an ancestor now changes `Chip` and `FilterButton` colors too** (in 3.x it only blocked touches) |
| **PushBadge** | A single-character badge is now a fixed `badgeSize` square. It also stops scaling at `xxxLarge`, so it comes out smaller than 3.x at accessibility text sizes |
| **PlayBadge** | A `coolNeutral40` 28% tint was added to the background and the play icon is now `staticWhite` at 88%. The badge stays visible on bright thumbnails |
| **TopNavigation / ModalNavigation** | The background gets darker while scrolling. **Pressing an icon button fades the icon instead of showing a grey rectangular layer** |
| **Toast / SnackBar** | Background opacity light 50% → 52%, dark 46% → 43% |
| **BottomSheet** | Background opacity 80% → 88% |
| **TopNavigation / ModalNavigation** | The scroll background tint goes from `0.7` to `0.88`, so **the navigation background gets darker while scrolling** |
| **Typography `caption2`** | The Dynamic Type scale curve moved from `.caption2` to `.caption`. The base size is unchanged, and `caption2` no longer overtakes `caption1` at larger sizes |
| **Thumbnail** | `opacity43` when disabled |
| **Skeleton** | Text placeholder bar widths go from variable to uniform (while loading only) |
| **IconButton** | Same glyph, larger touch container (roughly 6\~8pt of layout shift) |

---

## Added APIs

**Not needed for the migration.** These are new in 4.0 and listed here for reference only. See the [DocC documentation](./documentation) and the Blueprint sample app for usage.

### New components

#### ScreenScaffold

Assembles `TopNavigation` + content + `ActionArea` into one screen, taking over the scroll-offset plumbing and bottom-inset math you used to wire up per screen. It is also the replacement for the removed `View.topNavigation(...)`, so it shows up during the migration too ([2.4](#24-viewtopnavigation-removed)).

```swift
ScreenScaffold(
    navigation: { TopNavigation(title: "Settings") },
    actionArea: { ActionArea(variant: .neutral(main: .init(text: "Save", action: save))) }
) {
    content
}
.backgroundColor(.semantic(.backgroundNeutralPrimary))
```

#### SearchField

A search input. It pairs a leading search icon with a single-line input, and a clear button appears on the right once there is text. Sizing follows the same system as `TextField`. `TopNavigation`'s search mode uses this component too.

```swift
SearchField(text: $keyword)
    .placeholder("Search")
    .onSubmit { search(keyword) }

// outlined, medium
SearchField(text: $keyword)
    .variant(.outlined)
    .size(.medium)
```

#### FormControl · FormControlGroup

`FormControl` places the label, message, and accessory around an input component. Attaching those modifiers to the component wraps one automatically, so you rarely write it yourself ([2.1](#21-input-labels-messages-and-counters)).

`FormControlGroup` aligns the label column across stacked inputs that put their label on the leading side, sizing it to the longest label. No fixed width in the call site, and it re-measures when Dynamic Type or localization changes the label lengths.

```swift
FormControlGroup {
    TextField(text: $name)
        .labelPlacement(.leading)
        .label("Name")

    TextField(text: $email)
        .labelPlacement(.leading)
        .label("Email address")
}
// the label column settles on the width of "Email address" and both inputs line up
```

### New token groups

`Radius`, `Dimension`, `Primitive`, and `MaterialBackground`. Each is exposed as a `CGFloat` extension and provides `allValues`, `min`, and `max`.

New semantic tokens were added too: `lineBrandFocus`, `lineNegativeFocus`, `surfaceBrandSubtle`, `surfaceNegativeStrong`, `foregroundAccent*`, `lineAccent*`, and `surfaceAccent*` (translucent 8%).

### Per-component additions

| Component | Added |
|---|---|
| `Button` | `xsmall` size, `negative` color |
| `TextButton` | `fillWidth(_:)` |
| `IconButton` | `interactionEffect(_:)`, `interactionColor(_:)` |
| `ActionArea` | the icon slot (16pt) on `caption(_:icon:)`, `scrollReachedEnd(_:)`, `backgroundColor(_:)` |
| `TopNavigation` | `backgroundColor(_:)` |
| `Chip` | `borderColor(_:)` |
| `Category` | `itemDisabled(_:)` |
| `PushBadge` | `outlineBorder(_:color:)` |
| `ListCell` | `verticalPadding(.custom(_:))`, four slots (`leading`, `labelTrailing`, `trailing`, `extra`) |
| `Select` | `size(.large/.medium)` |
| `TextField`, `TextArea` | `autocorrectionDisabled(_:)`, `onTextChange(_:)`, `size(_:)` |
| `Shadow` | `shadow(_:) -> some ShapeStyle` |
| `UIColor` | Montage token extensions |

---

## Checklist

### Substitution

- [ ] After substituting semantic color tokens, check for leftovers with `grep -rn "\.label\(Normal\|Alternative\|Assistive\|Strong\|Neutral\|Disable\)\b"`
- [ ] Check for leftover `spacing(.pt` and `opacity(.p`
- [ ] `grep -rn "spacing(\.pt28\|spacing(\.pt36"` - values with no replacement
- [ ] Check for leftover `.disable(` (it should be `.disabled(`)
- [ ] No component-specific modifier chained after `.disabled()` on `Chip` or `FilterButton`
- [ ] Check for leftover `.topNavigation(`
- [ ] Audit every use of `accentForegroundRedOrange` and `accentBackgroundRedOrange`
- [ ] Audit `FallbackView(image:`, `variant:` on `AvatarGroup(`, and `TrailingButtonInfo(variant:`

### Restructuring

- [ ] 3.x `heading`, `requiredBadge`, and `description` moved to `label` and `message`
- [ ] Character counters use `Text(verbatim:)` - prioritise limits of 1000 or more
- [ ] Outer `padding(.vertical,)` and `frame(height:)` removed from `FallbackView` call sites
- [ ] No `if` statements inside `.actionArea {}` or `ScreenScaffold` slots
- [ ] Icon size and color set at the call site for Chip slots
- [ ] `scrollReachedEnd(_:)` passed wherever `transparentBackground` was used with `.manual`

### Visual review

- [ ] Screens using `accentForeground{Blue,Green,Orange}`, in both light and dark
- [ ] The remaining `accentForeground*` and `materialDimmer`, in dark mode
- [ ] Buttons with long labels - confirm the surrounding layout can absorb the extra height
- [ ] ActionArea background in popups and sheets with no scroll container
- [ ] Button colors in ActionAreas using the `alternative` action or the `.cancel` variant
- [ ] Avatar placeholders where no image is provided
- [ ] `FallbackView` screens that had an illustration, and company/academy `AvatarGroup`s
- [ ] Every screen in [4. Visual changes](#4-visual-changes), on device or in the simulator

The fastest way to review spec changes is to build Blueprint at both versions and compare. Set `UDID` to a value from `xcrun simctl list devices`.

```bash
UDID=... # xcrun simctl list devices

git worktree add --detach ../baseline v3.15.2
xcodebuild -workspace ../baseline/Montage.xcworkspace -scheme Blueprint \
  -configuration Debug -destination "id=$UDID" \
  -derivedDataPath /tmp/dd-before build
```

---

## 3.0

If you are upgrading from a version older than 3.0, see the [release notes](https://github.com/wanteddev/montage-ios/releases).
