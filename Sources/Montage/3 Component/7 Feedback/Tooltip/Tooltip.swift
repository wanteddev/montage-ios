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
/// **사용 예시**:
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
///
/// - SeeAlso: `Tooltip.Position`, `Tooltip.ButtonInfo`, `Tooltip.Modifier`
public enum Tooltip {
    
    // MARK: - Types
    
    /// 툴팁이 표시될 위치를 정의하는 열거형입니다.
    ///
    /// 툴팁의 방향(상단, 하단, 왼쪽, 오른쪽)과
    /// 화살표의 위치를 함께 지정할 수 있습니다.
    ///
    /// **사용 예시**:
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
    public enum Position {
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
    }
    
    /// 툴팁에 표시되는 버튼의 정보를 정의하는 구조체입니다.
    ///
    /// 툴팁 내용 아래에 표시되는 버튼의 제목과 동작을 정의합니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// Tooltip.ButtonInfo(
    ///     title: "더 알아보기",
    ///     action: {
    ///         // 상세 정보 페이지로 이동
    ///     }
    /// )
    /// ```
    public struct ButtonInfo {
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
    }

    // MARK: - ViewModifier
    
    /// 뷰에 툴팁을 적용하기 위한 뷰 모디파이어입니다.
    ///
    /// isPresented 바인딩 값을 통해 툴팁의 표시 여부를 제어합니다.
    /// iOS 16.4 이상에서는 내장 popover API를 사용할 수 있으며,
    /// 그 이하 버전에서는 커스텀 툴팁이 구현됩니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var showTooltip = false
    ///
    /// Text("도움말이 필요한 항목")
    ///     .onTapGesture {
    ///         showTooltip.toggle()
    ///     }
    ///     .modifier(
    ///         Tooltip.Modifier(
    ///             isPresented: $showTooltip,
    ///             position: .bottom(),
    ///             message: "이 항목에 대한 설명입니다.",
    ///             showCloseButton: true
    ///         )
    ///     )
    /// ```
    ///
    /// - Note: iOS 16.4 이상에서는 `position` 파라미터를 생략하면 시스템 팝오버가 사용됩니다.
    struct Modifier: ViewModifier {
        
        // MARK: - Constants
        
        private let margin: CGFloat = 4
        private let cornerRadius: CGFloat = 8
        private let arrowWidth: CGFloat = 12
        private let arrowHeight: CGFloat = 7
        private let arrowVerticalPadding: CGFloat = 1
        private let arrowHorizontalPadding: CGFloat = 12
        private let lowerLayerColor: SwiftUI.Color = .semantic(.primaryNormal).opacity(0.05)
        private let upperLayerColor: SwiftUI.Color = .semantic(.inverseBackground).opacity(0.88)
        private let contentColor: Color.Semantic = .inverseLabel
        
        // MARK: - Initializer

        @Binding private var isPresented: Bool
        private let buttonInfo: ButtonInfo?
        private let position: Position?
        private let showArrow: Bool
        private let showCloseButton: Bool
        private let message: String

        /// 특정 위치에 표시되는 툴팁 모디파이어를 초기화합니다.
        ///
        /// - Parameters:
        ///   - isPresented: 툴팁의 표시 여부를 제어하는 바인딩
        ///   - position: 툴팁이 표시될 위치 및 화살표 위치
        ///   - message: 툴팁에 표시될 메시지
        ///   - showArrow: 화살표 표시 여부 (기본값: true)
        ///   - showCloseButton: 닫기 버튼 표시 여부 (기본값: false)
        ///   - buttonInfo: 툴팁에 추가할 버튼 정보 (선택 사항)
        init(
            isPresented: Binding<Bool>,
            position: Tooltip.Position,
            message: String,
            showArrow: Bool = true,
            showCloseButton: Bool = false,
            buttonInfo: ButtonInfo? = nil
        ) {
            _isPresented = isPresented
            self.position = position
            self.message = message
            self.showArrow = showArrow
            self.showCloseButton = showCloseButton
            self.buttonInfo = buttonInfo
        }
        
        /// iOS 16.4 이상에서 시스템 팝오버를 사용하는 툴팁 모디파이어를 초기화합니다.
        ///
        /// - Parameters:
        ///   - isPresented: 툴팁의 표시 여부를 제어하는 바인딩
        ///   - message: 툴팁에 표시될 메시지
        ///   - showCloseButton: 닫기 버튼 표시 여부 (기본값: false)
        ///   - buttonInfo: 툴팁에 추가할 버튼 정보 (선택 사항)
        @available(iOS 16.4, *)
        init(
            isPresented: Binding<Bool>,
            message: String,
            showCloseButton: Bool = false,
            buttonInfo: ButtonInfo? = nil
        ) {
            _isPresented = isPresented
            self.position = nil
            self.message = message
            self.showArrow = false
            self.showCloseButton = showCloseButton
            self.buttonInfo = buttonInfo
        }

        @State private var originSize: CGSize = .zero
        @State private var contentSize: CGSize = .zero

        // MARK: - Body

        func body(content: Content) -> some View {
            content
                .modifying { originalView in
                    if #available(iOS 16.4, *), position == nil {
                        originalView.popover(
                            isPresented: $isPresented,
                            arrowEdge: position?.arrowEdge
                        ) {
                            tooltipContent
                                .frame(height: contentSize.height)
                                .presentationCompactAdaptation(.none)
                                .presentationBackground {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .foregroundColor(lowerLayerColor)
                                        RoundedRectangle(cornerRadius: cornerRadius)
                                            .background(
                                                RoundedRectangle(cornerRadius: cornerRadius)
                                                    .foregroundStyle(upperLayerColor)
                                            )
                                    }
                                    .background(.ultraThinMaterial)
                                }
                                .frame(minWidth: 64, maxWidth: 280)
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                    } else {
                        originalView.onGeometryChange(for: CGSize.self, of: { $0.size }, action: {
                            originSize = $0
                        })
                        .modifying {
                            if isPresented {
                                $0.overlay {
                                    tooltipContent.background {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: cornerRadius)
                                                .foregroundColor(lowerLayerColor)
                                            RoundedRectangle(cornerRadius: cornerRadius)
                                                .background(
                                                    RoundedRectangle(cornerRadius: cornerRadius)
                                                        .foregroundStyle(upperLayerColor)
                                                )
                                        }
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                                    }
                                    .background(arrowView)
                                    .frame(minWidth: 64, maxWidth: 280)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .allowsHitTesting(true)
                                    .offset(
                                        x: offsetHorizontal(),
                                        y: offsetVertical()
                                    )
                                }
                            } else {
                                $0
                            }
                        }
                    }
                }
        }
    }
}

private extension Tooltip.Modifier {
    var tooltipContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 6) {
                Text(message)
                    .montage(
                        variant: .label1,
                        weight: .medium,
                        semantic: contentColor
                    )
                    .paragraph(variant: .label1)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 2)
                Spacer(minLength: 0)
                if showCloseButton {
                    IconButton(
                        variant: .normal(size: 16),
                        icon: .close,
                        iconColor: .semantic(.inverseLabel)
                    ) {
                        isPresented = false
                    }
                    .frame(width: 16, height: 16)
                    .padding([.leading, .top], 2)
                    .opacity(0.61)
                }
            }
            if let buttonInfo = buttonInfo {
                SwiftUI.Button(action: {
                    buttonInfo.action()
                }, label: {
                    Text(buttonInfo.title)
                        .montage(
                            variant: .label1,
                            weight: .bold,
                            semantic: .inverseLabel
                        )
                        .paragraph(variant: .label1)
                        .opacity(0.61)
                        .frame(height: 20)
                        .padding(.horizontal, 2)
                })
            }
        }
        .padding(.all, 10)
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
    }
    
    var actualArrowHeight: CGFloat { showArrow ? arrowHeight : 0 }

    var arrowOffsetX: CGFloat {
        switch position ?? .top() {
        case .leading:
            contentSize.width / 2
                + arrowHeight / 2
                - 0.3

        case .trailing:
            -(
                contentSize.width / 2
                    + arrowHeight / 2
                    - 0.3
            )
        case .top(let arrowPosition):
            switch arrowPosition {
            case .leading:
                -(
                    contentSize.width / 2 - (arrowWidth + arrowHorizontalPadding)
                )
            case .trailing:
                contentSize.width / 2 - (arrowWidth + arrowHorizontalPadding)
            default:
                .zero
            }

        case .bottom(let arrowPosition):
            switch arrowPosition {
            case .leading:
                -(
                    contentSize.width / 2 - (arrowWidth + arrowHorizontalPadding)
                )
            case .trailing:
                contentSize.width / 2 - (arrowWidth + arrowHorizontalPadding)
            default:
                .zero
            }
        }
    }

    var arrowOffsetY: CGFloat {
        switch position ?? .top() {
        case .leading(let arrowPosition):
            switch arrowPosition {
            case .top:
                -(
                    contentSize.height / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .bottom:
                contentSize.height / 2 - (actualArrowHeight + arrowHorizontalPadding)
            default:
                .zero
            }

        case .trailing(let arrowPosition):
            switch arrowPosition {
            case .top:
                -(
                    contentSize.height / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .bottom:
                contentSize.height / 2 - (actualArrowHeight + arrowHorizontalPadding)
            default:
                .zero
            }

        case .top:
            contentSize.height / 2 + actualArrowHeight / 2

        case .bottom:
            -(
                contentSize.height / 2 + actualArrowHeight / 2
            )
        }
    }

    func offsetHorizontal() -> CGFloat {
        switch position ?? .top() {
        case .leading:
            -(
                originSize.width / 2
                    + contentSize.width / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + margin
            )

        case .trailing:
            originSize.width / 2
                + contentSize.width / 2
                + actualArrowHeight
                + arrowVerticalPadding
                + margin

        case .top(let arrowPosition), .bottom(let arrowPosition):
            switch arrowPosition {
            case .leading:
                contentSize.width / 2
                    - arrowWidth
                    - arrowHorizontalPadding
            case .trailing:
                -(
                    contentSize.width / 2
                        - arrowWidth
                        - arrowHorizontalPadding
                )
            default:
                .zero
            }
        }
    }

    func offsetVertical() -> CGFloat {
        switch position ?? .top() {
        case .leading(let arrowPosition), .trailing(let arrowPosition):
            switch arrowPosition {
            case .top:
                contentSize.height / 2
                    - arrowWidth / 2
                    - arrowHorizontalPadding
            case .bottom:
                -(
                    contentSize.height / 2
                        - arrowWidth / 2
                        - arrowHorizontalPadding
                )
            default:
                .zero
            }

        case .top:
            -(
                contentSize.height / 2
                    + originSize.height / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + margin
            )

        case .bottom:
            contentSize.height / 2
                + originSize.height / 2
                + actualArrowHeight
                + arrowVerticalPadding
                + margin
        }
    }

    @ViewBuilder
    var arrowView: some View {
        if showArrow {
            ZStack {
                arrowShape(degree: (position ?? .top()).getArrowAngleDegree())
                    .frame(
                        width: arrowWidth,
                        height: arrowHeight
                    )
                    .offset(
                        x: arrowOffsetX,
                        y: arrowOffsetY
                    )
            }
        } else {
            EmptyView()
        }
    }

    func arrowShape(degree: Double) -> some View {
        ZStack {
            Triangle()
                .rotation(Angle(degrees: degree))
                .foregroundStyle(lowerLayerColor)
            Triangle()
                .rotation(Angle(degrees: degree))
                .foregroundStyle(upperLayerColor)
        }
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
        position: Tooltip.Position,
        message: String,
        showArrow: Bool = true,
        showCloseButton: Bool = false,
        buttonInfo: Tooltip.ButtonInfo? = nil
    ) -> some View {
        modifier(Tooltip.Modifier(
            isPresented: isPresented,
            position: position,
            message: message,
            showArrow: showArrow,
            showCloseButton: showCloseButton,
            buttonInfo: buttonInfo
        ))
    }
    
    /// iOS 16.4 이상에서 시스템 팝오버를 사용하는 툴팁 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 툴팁의 표시 여부를 제어하는 바인딩
    ///   - message: 툴팁에 표시될 메시지
    ///   - showCloseButton: 닫기 버튼 표시 여부 (기본값: false)
    ///   - buttonInfo: 툴팁에 추가할 버튼 정보 (선택 사항)
    /// - Returns: 툴팁이 적용된 뷰
    @available(iOS 16.4, *)
    public func tooltip(
        isPresented: Binding<Bool>,
        message: String,
        showCloseButton: Bool = false,
        buttonInfo: Tooltip.ButtonInfo? = nil
    ) -> some View {
        modifier(Tooltip.Modifier(
            isPresented: isPresented,
            message: message,
            showCloseButton: showCloseButton,
            buttonInfo: buttonInfo
        ))
    }
}
