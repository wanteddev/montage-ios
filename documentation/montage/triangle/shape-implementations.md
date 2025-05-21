---
title: Shape Implementations
---

## Topics

### Instance Properties


``var body: _ShapeView<Self, ForegroundStyle>``

``var layoutDirectionBehavior: LayoutDirectionBehavior``

### Instance Methods


``func fill<S>(S, style: FillStyle) -> some View``

``func fill<S>(S, style: FillStyle) -> _ShapeView<Self, S>``

``func fill(style: FillStyle) -> some View``

``func intersection<T>(T, eoFill: Bool) -> some Shape``

``func lineIntersection<T>(T, eoFill: Bool) -> some Shape``

``func lineSubtraction<T>(T, eoFill: Bool) -> some Shape``

``func offset(CGSize) -> OffsetShape<Self>``

``func offset(CGPoint) -> OffsetShape<Self>``

``func offset(x: CGFloat, y: CGFloat) -> OffsetShape<Self>``

``func rotation(Angle, anchor: UnitPoint) -> RotatedShape<Self>``

``func scale(CGFloat, anchor: UnitPoint) -> ScaledShape<Self>``

``func scale(x: CGFloat, y: CGFloat, anchor: UnitPoint) -> ScaledShape<Self>``

``func size(CGSize) -> some Shape``

``func size(CGSize, anchor: UnitPoint) -> some Shape``

``func size(width: CGFloat, height: CGFloat) -> some Shape``

``func size(width: CGFloat, height: CGFloat, anchor: UnitPoint) -> some Shape``

``func sizeThatFits(ProposedViewSize) -> CGSize``

``func stroke<S>(S, lineWidth: CGFloat) -> some View``

``func stroke<S>(S, lineWidth: CGFloat, antialiased: Bool) -> StrokeShapeView<Self, S, EmptyView>``

``func stroke<S>(S, style: StrokeStyle) -> some View``

``func stroke<S>(S, style: StrokeStyle, antialiased: Bool) -> StrokeShapeView<Self, S, EmptyView>``

``func stroke(lineWidth: CGFloat) -> some Shape``

``func stroke(style: StrokeStyle) -> some Shape``

``func subtracting<T>(T, eoFill: Bool) -> some Shape``

``func symmetricDifference<T>(T, eoFill: Bool) -> some Shape``

``func transform(CGAffineTransform) -> TransformedShape<Self>``

``func trim(from: CGFloat, to: CGFloat) -> some Shape``

``func union<T>(T, eoFill: Bool) -> some Shape``

### Type Properties


``static var role: ShapeRole``

