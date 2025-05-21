---
title: Layout Implementations
---

## Topics

### Instance Methods


``func callAsFunction<V>(() -> V) -> some View``

``func explicitAlignment(of: HorizontalAlignment, in: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?``

``func explicitAlignment(of: VerticalAlignment, in: CGRect, proposal: ProposedViewSize, subviews: Self.Subviews, cache: inout Self.Cache) -> CGFloat?``

``func spacing(subviews: Self.Subviews, cache: inout Self.Cache) -> ViewSpacing``

``func updateCache(inout Self.Cache, subviews: Self.Subviews)``

### Type Properties


``static var layoutProperties: LayoutProperties``

