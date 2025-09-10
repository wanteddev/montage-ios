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
/// 또한 닫기 버튼과 액션 버튼을 추가할 수 있습니다.
///
/// ```swift
/// // 기본 툴팁 표시
/// @State private var showTooltip = false
///
/// Button("도움말") {
///     showTooltip.toggle()
/// }
/// .modifier(
///     Tooltip.Modifier(
///         isPresented: $showTooltip,
///         position: .top(),
///         message: "이 버튼을 클릭하면 도움말이 표시됩니다."
///     )
/// )
///
/// // 버튼이 있는 툴팁
/// Button("설정") {
///     showTooltip.toggle()
/// }
/// .modifier(
///     Tooltip.Modifier(
///         isPresented: $showTooltip,
///         position: .bottom(arrowPosition: .leading),
///         message: "서비스 이용을 위해 설정이 필요합니다.",
///         showCloseButton: true,
///         buttonInfo: Tooltip.ButtonInfo(
///             title: "설정하기",
///             action: {
///                 // 설정 화면으로 이동
///             }
///         )
///     )
/// )
/// ```
public enum Tooltip {
    
    // MARK: - Types
    
    /// 툴팁의 표시 모드를 정의하는 열거형입니다.
    public enum ActionMode {
        /// 클릭 시에 표시되는 툴팁. 백그라운드를 터치하거나 스크롤을 할 시 닫힙니다.
        case click
        /// 화면이 노출될 때 항상 표시되는 툴팁. 툴팁에 있는 버튼을 통해서만 닫힙니다.
        case always
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
    public enum Position: Equatable {
        /// 왼쪽에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수직 위치 (기본값: .center)
        case leading(arrowPosition: VerticalAlignment = .center)
        
        /// 오른쪽에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수직 위치 (기본값: .center)
        case trailing(arrowPosition: VerticalAlignment = .center)
        
        /// 상단에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수평 위치 (기본값: .center)
        case top(arrowPosition: HorizontalAlignment = .center)
        
        /// 하단에 툴팁 표시
        /// - Parameter arrowPosition: 화살표의 수평 위치 (기본값: .center)
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
    
    /// 툴팁에 표시되는 버튼의 정보를 정의하는 구조체입니다.
    public struct ButtonInfo: Equatable {
        public let title: String
        public let action: () -> Void
        
        /// ButtonInfo를 초기화합니다.
        ///
        /// - Parameters:
        ///   - title: 버튼에 표시될 텍스트
        ///   - action: 버튼 클릭 시 실행될 동작
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
        
        public static func == (lhs: Tooltip.ButtonInfo, rhs: Tooltip.ButtonInfo) -> Bool {
            lhs.title == rhs.title
        }
    }

    struct Modifier: ViewModifier {
        // MARK: - Initializer

        @Binding private var isPresented: Bool
        private let mode: ActionMode?
        private let buttonInfo: ButtonInfo?
        private let position: Position
        private let showArrow: Bool
        private let showCloseButton: Bool
        private let message: String

        init(
            isPresented: Binding<Bool>,
            mode: ActionMode,
            position: Tooltip.Position,
            message: String,
            showArrow: Bool = true,
            showCloseButton: Bool = false,
            buttonInfo: ButtonInfo? = nil
        ) {
            _isPresented = isPresented
            self.mode = mode
            self.position = position
            self.message = message
            self.showArrow = showArrow
            self.showCloseButton = showCloseButton
            self.buttonInfo = buttonInfo
        }

        @State private var originFrame: CGRect = .zero
        @Environment(\.colorScheme) private var colorScheme: ColorScheme

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
                                                    buttonInfo: buttonInfo,
                                                    position: position,
                                                    originSize: originFrame.size,
                                                    showArrow: showArrow,
                                                    showCloseButton: showCloseButton,
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
                                            buttonInfo: buttonInfo,
                                            position: position,
                                            originSize: originFrame.size,
                                            showArrow: showArrow,
                                            showCloseButton: showCloseButton,
                                            message: message
                                        )
                                    }
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
    private let margin: CGFloat = 5
    private let cornerRadius: CGFloat = 8
    private let arrowWidth: CGFloat = 12
    private let arrowHeight: CGFloat = 7
    private let arrowEdgePadding: CGFloat = 12
    private let lowerLayerColor: SwiftUI.Color = .semantic(.primaryNormal).opacity(0.05)
    private let upperLayerColor: SwiftUI.Color = .semantic(.inverseBackground).opacity(0.74)
    private let contentColor: SwiftUI.Color = .semantic(.inverseLabel)
    
    // MARK: - Initializer
    
    private let isPresented: Binding<Bool>
    private let buttonInfo: Tooltip.ButtonInfo?
    private let position: Tooltip.Position
    private let originSize: CGSize
    private let showArrow: Bool
    private let showCloseButton: Bool
    private let message: String
    
    init(
        isPresented: Binding<Bool>,
        buttonInfo: Tooltip.ButtonInfo?,
        position: Tooltip.Position,
        originSize: CGSize,
        showArrow: Bool,
        showCloseButton: Bool,
        message: String
    ) {
        self.isPresented = isPresented
        self.buttonInfo = buttonInfo
        self.position = position
        self.originSize = originSize
        self.showArrow = showArrow
        self.showCloseButton = showCloseButton
        self.message = message
    }
    
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        tooltipContent
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
                            showArrow: showArrow,
                            position: position
                        )
                    )
                    .frame(
                        width: contentSize.width,
                        height: contentSize.height
                    )
            }
            .frame(minWidth: 64, maxWidth: 280)
            .fixedSize(horizontal: true, vertical: false)
            .allowsHitTesting(true)
            .offset(
                x: offsetHorizontal,
                y: offsetVertical
            )
    }
        
    var tooltipContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Text(message)
                    .paragraphNew(
                        variant: .label1,
                        weight: .medium,
                        color: contentColor
                    )
                    .lineLimit(nil)
                    .padding(.horizontal, 2)
                    .fixedSize(horizontal: false, vertical: true)
                
                if showCloseButton {
                    Spacer(minLength: 0)
                    IconButton(
                        variant: .normal(size: 16),
                        icon: .close
                    ) {
                        isPresented.wrappedValue = false
                    }
                    .iconColor(contentColor)
                    .frame(width: 16, height: 16)
                    .padding(.all, 2)
                    .opacity(0.61)
                }
            }
            if let buttonInfo = buttonInfo {
                SwiftUI.Button(action: {
                    buttonInfo.action()
                }, label: {
                    Text(buttonInfo.title)
                        .paragraphNew(
                            variant: .label1,
                            weight: .bold,
                            color: contentColor
                        )
                        .opacity(0.61)
                        .frame(height: 20)
                        .padding(.horizontal, 2)
                })
            }
        }
        .padding(contentPadding)
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
    }
        
    var contentPadding: EdgeInsets {
        let basePadding: CGFloat = 10
        let arrowPadding: CGFloat = showArrow ? arrowHeight : 0
        
        switch position {
        case .top:
            return EdgeInsets(top: basePadding, leading: basePadding, bottom: basePadding + arrowPadding, trailing: basePadding)
        case .bottom:
            return EdgeInsets(top: basePadding + arrowPadding, leading: basePadding, bottom: basePadding, trailing: basePadding)
        case .leading:
            return EdgeInsets(top: basePadding, leading: basePadding, bottom: basePadding, trailing: basePadding + arrowPadding)
        case .trailing:
            return EdgeInsets(top: basePadding, leading: basePadding + arrowPadding, bottom: basePadding, trailing: basePadding)
        }
    }

    var offsetHorizontal: CGFloat {
        switch position {
        case .leading:
            -(originSize.width / 2 + contentSize.width / 2 + margin)
        case .trailing:
            originSize.width / 2 + contentSize.width / 2 + margin
        case .top(let arrowPosition), .bottom(let arrowPosition):
            switch arrowPosition {
            case .leading:
                contentSize.width / 2 - arrowWidth / 2 - arrowEdgePadding
            case .trailing:
                -(contentSize.width / 2 - arrowWidth / 2 - arrowEdgePadding)
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
                contentSize.height / 2 - arrowWidth / 2 - arrowEdgePadding
            case .bottom:
                -(contentSize.height / 2 - arrowWidth / 2 - arrowEdgePadding)
            default:
                .zero
            }
        case .top:
            -(contentSize.height / 2 + originSize.height / 2 + margin)
        case .bottom:
            contentSize.height / 2 + originSize.height / 2 + margin
        }
    }
}

struct TooltipBubbleShape: Shape {
    enum Direction { case top, bottom, leading, trailing }
    enum HAlign { case leading, center, trailing }
    enum VAlign { case top, center, bottom }

    var cornerRadius: CGFloat
    var showArrow: Bool
    private let direction: Direction
    private let hAlign: HAlign
    private let vAlign: VAlign

    var arrowWidth: CGFloat
    var arrowHeight: CGFloat
    var arrowEdgePadding: CGFloat

    init(
        cornerRadius: CGFloat,
        showArrow: Bool,
        position: Tooltip.Position,
        arrowWidth: CGFloat = 12,
        arrowHeight: CGFloat = 7,
        arrowEdgePadding: CGFloat = 12
    ) {
        self.cornerRadius = cornerRadius
        self.showArrow = showArrow
        self.arrowWidth = arrowWidth
        self.arrowHeight = arrowHeight
        self.arrowEdgePadding = arrowEdgePadding

        switch position {
        case .top(let align):
            self.direction = .top
            self.hAlign = (align == .leading ? .leading : (align == .trailing ? .trailing : .center))
            self.vAlign = .center
        case .bottom(let align):
            self.direction = .bottom
            self.hAlign = (align == .leading ? .leading : (align == .trailing ? .trailing : .center))
            self.vAlign = .center
        case .leading(let align):
            self.direction = .leading
            self.vAlign = (align == .top ? .top : (align == .bottom ? .bottom : .center))
            self.hAlign = .center
        case .trailing(let align):
            self.direction = .trailing
            self.vAlign = (align == .top ? .top : (align == .bottom ? .bottom : .center))
            self.hAlign = .center
        }
    }

    func path(in rect: CGRect) -> Path {
        guard showArrow else {
            // 화살표가 없으면 단순한 라운드 사각형
            return Path(roundedRect: rect, cornerRadius: cornerRadius)
        }
        
        var path = Path()
        
        // 콘텐츠 영역을 기준으로 버블과 화살표 영역 계산
        let bubbleRect = rect
        let arrowRect: CGRect
        
        switch direction {
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
        switch direction {
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
        switch direction {
        case .top, .bottom:
            let leftX = bodyRect.minX + arrowEdgePadding + arrowWidth / 2
            let rightX = bodyRect.maxX - arrowEdgePadding - arrowWidth / 2
            let centerX = (hAlign == .leading ? leftX : (hAlign == .trailing ? rightX : bodyRect.midX))
            arrowCenter = CGPoint(x: centerX, y: direction == .top ? arrowRect.midY : arrowRect.midY)
            
        case .leading, .trailing:
            let topY = bodyRect.minY + arrowEdgePadding + arrowWidth / 2
            let bottomY = bodyRect.maxY - arrowEdgePadding - arrowWidth / 2
            let centerY = (vAlign == .top ? topY : (vAlign == .bottom ? bottomY : bodyRect.midY))
            arrowCenter = CGPoint(x: direction == .leading ? arrowRect.midX : arrowRect.midX, y: centerY)
        }
        
        let arrowCornerRadius: CGFloat = 1
        switch direction {
        case .top:
            path.addPath(Path(roundedRect: bodyRect, cornerRadius: cornerRadius))
            
            let arrowLeft = CGPoint(x: arrowCenter.x - arrowWidth / 2, y: bodyRect.maxY)
            let arrowTip = CGPoint(x: arrowCenter.x, y: rect.maxY)
            let arrowRight = CGPoint(x: arrowCenter.x + arrowWidth / 2, y: bodyRect.maxY)
            
            path.move(to: arrowLeft)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowRight, radius: arrowCornerRadius)
            path.addLine(to: arrowRight)
            path.closeSubpath()
            
        case .bottom:
            path.addPath(Path(roundedRect: bodyRect, cornerRadius: cornerRadius))
            
            let arrowLeft = CGPoint(x: arrowCenter.x - arrowWidth / 2, y: bodyRect.minY)
            let arrowTip = CGPoint(x: arrowCenter.x, y: rect.minY)
            let arrowRight = CGPoint(x: arrowCenter.x + arrowWidth / 2, y: bodyRect.minY)
            
            path.move(to: arrowLeft)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowRight, radius: arrowCornerRadius)
            path.addLine(to: arrowRight)
            path.closeSubpath()
            
        case .leading:
            path.addPath(Path(roundedRect: bodyRect, cornerRadius: cornerRadius))
            
            let arrowTop = CGPoint(x: bodyRect.maxX, y: arrowCenter.y - arrowWidth / 2)
            let arrowTip = CGPoint(x: rect.maxX, y: arrowCenter.y)
            let arrowBottom = CGPoint(x: bodyRect.maxX, y: arrowCenter.y + arrowWidth / 2)
            
            path.move(to: arrowTop)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowBottom, radius: arrowCornerRadius)
            path.addLine(to: arrowBottom)
            path.closeSubpath()
            
        case .trailing:
            path.addPath(Path(roundedRect: bodyRect, cornerRadius: cornerRadius))
            
            let arrowTop = CGPoint(x: bodyRect.minX, y: arrowCenter.y - arrowWidth / 2)
            let arrowTip = CGPoint(x: rect.minX, y: arrowCenter.y)
            let arrowBottom = CGPoint(x: bodyRect.minX, y: arrowCenter.y + arrowWidth / 2)
            
            path.move(to: arrowTop)
            path.addArc(tangent1End: arrowTip, tangent2End: arrowBottom, radius: arrowCornerRadius)
            path.addLine(to: arrowBottom)
            path.closeSubpath()
        }
        
        return path
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 툴팁을 표시하는 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 툴팁의 표시 여부를 제어하는 바인딩
    ///   - position: 툴팁이 표시될 위치 및 화살표 위치
    ///   - message: 툴팁에 표시될 메시지
    ///   - showArrow: 화살표 표시 여부 (기본값: true)
    ///   - showCloseButton: 닫기 버튼 표시 여부 (기본값: false)
    ///   - buttonInfo: 툴팁에 추가할 버튼 정보 (선택 사항)
    /// - Returns: 툴팁이 적용된 뷰
    public func tooltip(
        isPresented: Binding<Bool>,
        mode: Tooltip.ActionMode,
        position: Tooltip.Position,
        message: String,
        showArrow: Bool = true,
        showCloseButton: Bool = false,
        buttonInfo: Tooltip.ButtonInfo? = nil
    ) -> some View {
        modifier(Tooltip.Modifier(
            isPresented: isPresented,
            mode: mode,
            position: position,
            message: message,
            showArrow: showArrow,
            showCloseButton: showCloseButton,
            buttonInfo: buttonInfo
        ))
    }
}
