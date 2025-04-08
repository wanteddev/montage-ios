//
//  Tooltip.swift
//
//
//  Created by Ahn Sang Hoon on 6/27/24.
//

import SwiftUI

public enum Tooltip {
    
    // MARK: - Types
    
    public enum Position: CaseDescribable {
        case leading(arrowPosition: VerticalAlignment = .center)
        case trailing(arrowPosition: VerticalAlignment = .center)
        case top(arrowPosition: HorizontalAlignment = .center)
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
    
    public struct ButtonInfo {
        public let title: String
        public let action: () -> Void
        
        public init(title: String, action: @escaping () -> Void) {
            self.title = title
            self.action = action
        }
    }

    // MARK: - ViewModifier
    
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
