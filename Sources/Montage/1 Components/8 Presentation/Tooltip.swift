//
//  Tooltip.swift
//
//
//  Created by Ahn Sang Hoon on 6/27/24.
//

import SwiftUI

/// UI 요소 주변에 추가 정보나 설명을 제공하는 툴팁 컴포넌트입니다.
///
/// 툴팁은 사용자가 특정 UI 요소를 이해하는데 도움이 되는 짧은 설명을 보여주기 위해 사용됩니다.
/// 화살표가 있는 말풍선 형태로 표시되며, 화살표의 위치와 방향을 설정할 수 있습니다.
///
/// ```swift
/// // 버튼을 클릭하면 표시되는 툴팁 (click 모드)
/// @State private var showTooltip = false
///
/// Button {
///     showTooltip.toggle()
/// }, label: {
///     HStack {
///         Text("Montage")
///         Image.icon(.circleInfo)
///     }
/// })
/// .tooltip(
///     isPresented: $showTooltip,
///     mode: .click,
///     position: .top(),
///     message: "Montage는 컴포넌트 기반의 디자인 시스템입니다."
/// )
///
/// // 화면에 진입하면 표시되는 툴팁 (always 모드)
/// Button("설정") {
///     showTooltip.toggle()
///     setupSomething() // 설정 화면으로 이동
/// }
/// .tooltip(
///     isPresented: $showTooltip,
///     mode: .always,
///     position: .bottom(arrowPosition: .leading),
///     size: .small,
///     message: "서비스 이용을 위해 설정이 필요합니다."
/// )
/// ```
public enum Tooltip {
    
    // MARK: - Types
    
    /// 툴팁의 표시 모드를 정의하는 열거형입니다.
    public enum ActionMode {
        /// 백그라운드를 터치하거나 스크롤을 할 시 닫힙니다. 주로 클릭 시에 표시되는 툴팁에 사용됩니다.
        case click
        /// 바인딩으로만 닫힘을 제어할 수 있습니다. 주로 화면이 노출될 때 항상 표시되는 툴팁에 사용됩니다.
        case always
    }

    /// 툴팁의 크기를 정의하는 열거형입니다.
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }
    
    /// 툴팁이 표시될 위치를 정의하는 열거형입니다.
    ///
    /// 툴팁의 방향(상단, 하단, 왼쪽, 오른쪽)과
    /// 화살표의 위치를 함께 지정할 수 있습니다.
    ///
    /// ```swift
    /// // 상단에 표시되고 화살표는 중앙에 위치
    /// .position(.top())
    ///
    /// // 왼쪽에 표시되고 화살표는 상단에 위치
    /// .position(.leading(arrowPosition: .top))
    ///
    /// // 하단에 표시되고 화살표는 오른쪽에 위치
    /// .position(.bottom(arrowPosition: .trailing))
    /// ```
    public enum Position: Equatable, Sendable {
        /// 왼쪽에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수직 위치, 기본값은 `.center`
        case leading(arrowPosition: VerticalAlignment = .center)
        
        /// 오른쪽에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수직 위치, 기본값은 `.center`
        case trailing(arrowPosition: VerticalAlignment = .center)
        
        /// 상단에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수평 위치, 기본값은 `.center`
        case top(arrowPosition: HorizontalAlignment = .center)
        
        /// 하단에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수평 위치, 기본값은 `.center`
        case bottom(arrowPosition: HorizontalAlignment = .center)
        
        fileprivate func getArrowAngleDegree() -> Double {
            switch self {
            case .leading:
                90
            case .trailing:
                -90
            case .top:
                180
            case .bottom:
                0
            }
        }
        
        fileprivate var arrowEdge: Edge {
            switch self {
            case .leading: .trailing
            case .trailing: .leading
            case .top: .bottom
            case .bottom: .top
            }
        }
        
        fileprivate var isHorizontal: Bool {
            switch self {
            case .leading, .trailing:
                true
            default:
                false
            }
        }
        
        fileprivate var isVertical: Bool {
            switch self {
            case .top, .bottom:
                true
            default:
                false
            }
        }
    }

    struct Modifier: ViewModifier {
        // MARK: - Initializer

        @Binding private var isPresented: Bool
        private let mode: ActionMode
        private let position: Position
        private let size: Size
        private let message: String

        init(
            isPresented: Binding<Bool>,
            mode: ActionMode,
            position: Tooltip.Position,
            size: Tooltip.Size = .medium,
            message: String
        ) {
            _isPresented = isPresented
            self.mode = mode
            self.position = position
            self.size = size
            self.message = message
        }

        @State private var originFrame: CGRect = .zero

        // MARK: - Body

        func body(content: Content) -> some View {
            content
                .modifying { originalView in
                    originalView.onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }, action: {
                        originFrame = $0
                    })
                    .modifying { original in
                        Group {
                            if mode == .click {
                                original
                                    .modifier(
                                        FloatModifier<Bool>(
                                            isPresented: $isPresented,
                                            updatingValue: .constant(nil),
                                            dismissPolicy: .onTouchOutside,
                                            presentingAnimation: .easeInOut,
                                            dismissingAnimation: .easeInOut,
                                            onDismiss: nil,
                                            floatView: {
                                                TooltipView(
                                                    isPresented: $isPresented,
                                                    position: position,
                                                    size: size,
                                                    originSize: originFrame.size,
                                                    message: message
                                                )
                                                .position(x: originFrame.midX, y: originFrame.midY)
                                                .ignoresSafeArea()
                                            }
                                        )
                                    )
                            } else {
                                if isPresented {
                                    original.overlay {
                                        TooltipView(
                                            isPresented: $isPresented,
                                            position: position,
                                            size: size,
                                            originSize: originFrame.size,
                                            message: message
                                        )
                                    }
                                    .allowsHitTesting(true)
                                } else {
                                    original
                                }
                            }
                        }
                    }
                }
        }
    }
}

struct TooltipView: View {
    private let lowerLayerColor: SwiftUI.Color = .semantic(.primaryNormal).opacity(0.05)
    private let upperLayerColor: SwiftUI.Color = .semantic(.inverseBackground).opacity(0.74)
    private let contentColor: SwiftUI.Color = .semantic(.inverseLabel)
    
    // MARK: - Initializer
    
    private let isPresented: Binding<Bool>
    private let position: Tooltip.Position
    private let size: Tooltip.Size
    private let originSize: CGSize
    private let message: String
    
    init(
        isPresented: Binding<Bool>,
        position: Tooltip.Position,
        size: Tooltip.Size,
        originSize: CGSize,
        message: String
    ) {
        self.isPresented = isPresented
        self.position = position
        self.size = size
        self.originSize = originSize
        self.message = message
    }
    
    @State private var tooltipSize: CGSize = .zero
    
    var body: some View {
        Text(message)
            .paragraph(
                variant: size == .small ? .caption2 : .label1,
                weight: .medium,
                color: contentColor
            )
            .lineLimit(nil)
            .padding(.horizontal, size == .small ? 8 : 12)
            .padding(.vertical, size == .small ? 5 : 8)
            .frame(minWidth: size == .small ? 36 : 64)
            .fixedSize(horizontal: false, vertical: true)
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(arrowPadding)
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { tooltipSize = $0 })
            .background {
                Rectangle()
                    .fill(lowerLayerColor)
                    .overlay(
                        Rectangle()
                            .fill(upperLayerColor)
                    )
                    .background(.ultraThinMaterial)
                    .clipShape(
                        TooltipBubbleShape(
                            cornerRadius: cornerRadius,
                            position: position,
                            arrowWidth: arrowWidth,
                            arrowHeight: arrowHeight,
                            arrowEdgeHPadding: arrowEdgeHPadding,
                            arrowTipRadius: size == .small ? 1.5 : 2,
                            arrowBaseRadius: 4
                        )
                    )
            }
            .frame(maxWidth: 280)
            .fixedSize(horizontal: true, vertical: false)
            .offset(x: offsetHorizontal, y: offsetVertical)
    }
        
    var arrowPadding: EdgeInsets {
        switch position {
        case .top:
            return EdgeInsets(top: 0, leading: 0, bottom: arrowHeight, trailing: 0)
        case .bottom:
            return EdgeInsets(top: arrowHeight, leading: 0, bottom: 0, trailing: 0)
        case .leading:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: arrowHeight)
        case .trailing:
            return EdgeInsets(top: 0, leading: arrowHeight, bottom: 0, trailing: 0)
        }
    }
    
    var cornerRadius: CGFloat {
        size == .small ? 6 : 8
    }
    
    var arrowWidth: CGFloat {
        size == .small ? 9 : 12
    }
    
    var arrowHeight: CGFloat {
        size == .small ? 6 : 7
    }
    
    var arrowToContentSpacing: CGFloat {
        size == .small ? 4 : 5
    }
    
    var arrowEdgeHPadding: CGFloat {
        size == .small ? 7.5 : 12
    }
    
    var offsetHorizontal: CGFloat {
        switch position {
        case .leading:
            -(originSize.width / 2 + tooltipSize.width / 2 + arrowToContentSpacing)
        case .trailing:
            originSize.width / 2 + tooltipSize.width / 2 + arrowToContentSpacing
        case .top(let arrowPosition), .bottom(let arrowPosition):
            switch arrowPosition {
            case .leading:
                tooltipSize.width / 2 - arrowWidth / 2 - arrowEdgeHPadding
            case .trailing:
                -(tooltipSize.width / 2 - arrowWidth / 2 - arrowEdgeHPadding)
            default:
                .zero
            }
        }
    }

    var offsetVertical: CGFloat {
        switch position {
        case .leading(let arrowPosition), .trailing(let arrowPosition):
            switch arrowPosition {
            case .top:
                tooltipSize.height / 2 - arrowWidth / 2 - arrowEdgeHPadding
            case .bottom:
                -(tooltipSize.height / 2 - arrowWidth / 2 - arrowEdgeHPadding)
            default:
                .zero
            }
        case .top:
            -(tooltipSize.height / 2 + originSize.height / 2 + arrowToContentSpacing)
        case .bottom:
            tooltipSize.height / 2 + originSize.height / 2 + arrowToContentSpacing
        }
    }
}

struct TooltipBubbleShape: Shape {
    enum Direction { case top, bottom, leading, trailing }
    enum HAlign { case leading, center, trailing }
    enum VAlign { case top, center, bottom }

    private let cornerRadius: CGFloat
    private let arrowWidth: CGFloat
    private let arrowHeight: CGFloat
    private let arrowEdgeHPadding: CGFloat
    private let arrowTipRadius: CGFloat
    private let arrowBaseRadius: CGFloat

    private let position: Tooltip.Position
    private let hAlign: HAlign
    private let vAlign: VAlign

    init(
        cornerRadius: CGFloat,
        position: Tooltip.Position,
        arrowWidth: CGFloat,
        arrowHeight: CGFloat,
        arrowEdgeHPadding: CGFloat,
        arrowTipRadius: CGFloat,
        arrowBaseRadius: CGFloat
    ) {
        self.cornerRadius = cornerRadius
        self.position = position
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.arrowEdgeHPadding = arrowEdgeHPadding
        self.arrowTipRadius = arrowTipRadius
        self.arrowBaseRadius = arrowBaseRadius

        switch position {
        case .top(let align):
            self.hAlign = (align == .leading ? .leading : (align == .trailing ? .trailing : .center))
            self.vAlign = .center
        case .bottom(let align):
            self.hAlign = (align == .leading ? .leading : (align == .trailing ? .trailing : .center))
            self.vAlign = .center
        case .leading(let align):
            self.vAlign = (align == .top ? .top : (align == .bottom ? .bottom : .center))
            self.hAlign = .center
        case .trailing(let align):
            self.vAlign = (align == .top ? .top : (align == .bottom ? .bottom : .center))
            self.hAlign = .center
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 콘텐츠 영역을 기준으로 버블과 화살표 영역 계산
        let arrowRect: CGRect
        
        switch position {
        case .top:
            arrowRect = CGRect(x: rect.minX, y: rect.maxY - arrowHeight, width: rect.width, height: arrowHeight)
        case .bottom:
            arrowRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: arrowHeight)
        case .leading:
            arrowRect = CGRect(x: rect.maxX - arrowHeight, y: rect.minY, width: arrowHeight, height: rect.height)
        case .trailing:
            arrowRect = CGRect(x: rect.minX, y: rect.minY, width: arrowHeight, height: rect.height)
        }
        
        // 버블 바디 영역 (화살표 영역 제외)
        let bodyRect: CGRect
        switch position {
        case .top:
            bodyRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - arrowHeight)
        case .bottom:
            bodyRect = CGRect(x: rect.minX, y: rect.minY + arrowHeight, width: rect.width, height: rect.height - arrowHeight)
        case .leading:
            bodyRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width - arrowHeight, height: rect.height)
        case .trailing:
            bodyRect = CGRect(x: rect.minX + arrowHeight, y: rect.minY, width: rect.width - arrowHeight, height: rect.height)
        }
        
        // 화살표 위치 계산
        let arrowCenter: CGPoint
        switch position {
        case .top, .bottom:
            let centerXWhenLeadingAlign = bodyRect.minX + arrowEdgeHPadding + arrowWidth / 2
            let centerXWhenTrailingAlign = bodyRect.maxX - arrowEdgeHPadding - arrowWidth / 2
            let centerX = (hAlign == .leading ? centerXWhenLeadingAlign : (hAlign == .trailing ? centerXWhenTrailingAlign : bodyRect.midX))
            arrowCenter = CGPoint(x: centerX, y: arrowRect.midY)
            
        case .leading, .trailing:
            let centerYWhenTopAlign = bodyRect.minY + arrowEdgeHPadding + arrowWidth / 2
            let centerYWhenBottomAlign = bodyRect.maxY - arrowEdgeHPadding - arrowWidth / 2
            let centerY = (vAlign == .top ? centerYWhenTopAlign : (vAlign == .bottom ? centerYWhenBottomAlign : bodyRect.midY))
            arrowCenter = CGPoint(x: arrowRect.midX, y: centerY)
        }
        
        switch position {
        case .top:
            let arrowLeft = CGPoint(x: arrowCenter.x - arrowWidth / 2, y: bodyRect.maxY)
            let arrowTip = CGPoint(x: arrowCenter.x, y: rect.maxY)
            let arrowRight = CGPoint(x: arrowCenter.x + arrowWidth / 2, y: bodyRect.maxY)
            
            path.move(to: bodyRect.bottomRight.offsetBy(dy: -cornerRadius))
            path.addArc(tangent1End: bodyRect.bottomRight, tangent2End: arrowLeft, radius: cornerRadius)
            path.addArc(tangent1End: arrowRight, tangent2End: arrowTip, radius: arrowBaseRadius)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowLeft, radius: arrowTipRadius)
            path.addArc(tangent1End: arrowLeft, tangent2End: bodyRect.bottomLeft, radius: arrowBaseRadius)
            path.addArc(tangent1End: bodyRect.bottomLeft, tangent2End: bodyRect.topLeft, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.topLeft, tangent2End: bodyRect.topRight, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.topRight, tangent2End: bodyRect.bottomRight, radius: cornerRadius)
            path.closeSubpath()
            
        case .bottom:
            let arrowLeft = CGPoint(x: arrowCenter.x - arrowWidth / 2, y: bodyRect.minY)
            let arrowTip = CGPoint(x: arrowCenter.x, y: rect.minY)
            let arrowRight = CGPoint(x: arrowCenter.x + arrowWidth / 2, y: bodyRect.minY)
            
            path.move(to: bodyRect.topLeft.offsetBy(dy: cornerRadius))
            path.addArc(tangent1End: bodyRect.topLeft, tangent2End: arrowLeft, radius: cornerRadius)
            path.addArc(tangent1End: arrowLeft, tangent2End: arrowTip, radius: arrowBaseRadius)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowRight, radius: arrowTipRadius)
            path.addArc(tangent1End: arrowRight, tangent2End: bodyRect.topRight, radius: arrowBaseRadius)
            path.addArc(tangent1End: bodyRect.topRight, tangent2End: bodyRect.bottomRight, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.bottomRight, tangent2End: bodyRect.bottomLeft, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.bottomLeft, tangent2End: bodyRect.topLeft, radius: cornerRadius)
            path.closeSubpath()
            
        case .leading:
            let arrowTop = CGPoint(x: bodyRect.maxX, y: arrowCenter.y - arrowWidth / 2)
            let arrowTip = CGPoint(x: rect.maxX, y: arrowCenter.y)
            let arrowBottom = CGPoint(x: bodyRect.maxX, y: arrowCenter.y + arrowWidth / 2)
            
            path.move(to: bodyRect.topRight.offsetBy(dx: -cornerRadius))
            path.addArc(tangent1End: bodyRect.topRight, tangent2End: bodyRect.bottomRight, radius: cornerRadius)
            path.addArc(tangent1End: arrowTop, tangent2End: arrowTip, radius: arrowBaseRadius)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowBottom, radius: arrowTipRadius)
            path.addArc(tangent1End: arrowBottom, tangent2End: bodyRect.bottomRight, radius: arrowBaseRadius)
            path.addArc(tangent1End: bodyRect.bottomRight, tangent2End: bodyRect.bottomLeft, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.bottomLeft, tangent2End: bodyRect.topLeft, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.topLeft, tangent2End: bodyRect.topRight, radius: cornerRadius)
            path.closeSubpath()
            
        case .trailing:
            let arrowTop = CGPoint(x: bodyRect.minX, y: arrowCenter.y - arrowWidth / 2)
            let arrowTip = CGPoint(x: rect.minX, y: arrowCenter.y)
            let arrowBottom = CGPoint(x: bodyRect.minX, y: arrowCenter.y + arrowWidth / 2)
            
            path.move(to: bodyRect.bottomLeft.offsetBy(dx: cornerRadius))
            path.addArc(tangent1End: bodyRect.bottomLeft, tangent2End: bodyRect.topLeft, radius: cornerRadius)
            path.addArc(tangent1End: arrowBottom, tangent2End: arrowTip, radius: arrowBaseRadius)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowTop, radius: arrowTipRadius)
            path.addArc(tangent1End: arrowTop, tangent2End: bodyRect.topLeft, radius: arrowBaseRadius)
            path.addArc(tangent1End: bodyRect.topLeft, tangent2End: bodyRect.topRight, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.topRight, tangent2End: bodyRect.bottomRight, radius: cornerRadius)
            path.addArc(tangent1End: bodyRect.bottomRight, tangent2End: bodyRect.bottomLeft, radius: cornerRadius)
            path.closeSubpath()
        }
        
        return path
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    var topLeft: CGPoint {
        CGPoint(x: minX, y: minY)
    }
    
    var bottomLeft: CGPoint {
        CGPoint(x: minX, y: maxY)
    }
    
    var topRight: CGPoint {
        CGPoint(x: maxX, y: minY)
    }
    
    var bottomRight: CGPoint {
        CGPoint(x: maxX, y: maxY)
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 툴팁을 표시하는 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 툴팁의 표시 여부를 제어하는 바인딩
    ///   - mode: 툴팁의 표시 모드
    ///   - position: 툴팁이 표시될 위치 및 화살표 위치
    ///   - size: 툴팁의 크기, 기본값은 `.medium`
    ///   - message: 툴팁에 표시될 메시지
    /// - Returns: 툴팁이 적용된 뷰
    public func tooltip(
        isPresented: Binding<Bool>,
        mode: Tooltip.ActionMode,
        position: Tooltip.Position,
        size: Tooltip.Size = .medium,
        message: String
    ) -> some View {
        modifier(Tooltip.Modifier(
            isPresented: isPresented,
            mode: mode,
            position: position,
            size: size,
            message: message
        ))
    }
}

#Preview {
    TooltipBubbleShape(
        cornerRadius: 6,
        position: .trailing(arrowPosition: .top),
        arrowWidth: 11,
        arrowHeight: 6,
        arrowEdgeHPadding: 6.5,
        arrowTipRadius: 1.5,
        arrowBaseRadius: 4
    )
    .stroke()
    .frame(width: 200, height: 100)
}
