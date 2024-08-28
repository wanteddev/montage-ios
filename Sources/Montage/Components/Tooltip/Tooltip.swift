//
//  Tooltip.swift
//
//
//  Created by Ahn Sang Hoon on 6/27/24.
//

import SwiftUI

public enum Tooltip {
    public enum Variant: Equatable {
        case extended(title: String? = nil, action: (() -> Void)? = nil)
        case compact
        
        public static func == (lhs: Tooltip.Variant, rhs: Tooltip.Variant) -> Bool {
            switch (lhs, rhs) {
            case let (.extended(t1, _), .extended(t2, _)): t1 == t2
            case (.compact, .compact): true
            default: false
            }
        }
        
        public var isExtended: Bool {
            self != .compact
        }
    }
    
    public enum Position {
        case left, leftTop, leftBottom
        case right, rightTop, rightBottom
        case top, topLeft, topRight
        case bottom, bottomLeft, bottomRight

        func getArrowAngleDegree() -> Double {
            switch self {
            case .left, .leftTop, .leftBottom:
                return 90
            case .right, .rightTop, .rightBottom:
                return -90
            case .top, .topLeft, .topRight:
                return 180
            case .bottom, .bottomLeft, .bottomRight:
                return 0
            }
        }
    }
    
    public enum Size {
        public enum Arrow {
            public static let width: CGFloat = 12
            public static let height: CGFloat = 7
        }

        public static let margin: CGFloat = 4
        
        public static let width: CGFloat = 10
        public static let height: CGFloat = 10
        public static let borderRadius: CGFloat = 8
    }
    
    private struct Arrow: Shape {
        public func path(in rect: CGRect) -> Path {
            var path = Path()
            path.addLines([
                CGPoint(x: 0, y: rect.height),
                CGPoint(x: rect.width / 2, y: 0),
                CGPoint(x: rect.width, y: rect.height),
            ])
            return path
        }
    }
    
    public struct DefaultTooltipConfig: TooltipConfigurable {
        public var variant: Tooltip.Variant
        
        public var position: Tooltip.Position
        public var margin: CGFloat = Tooltip.Size.margin

        public var inverse: Bool
        public var width: CGFloat?
        public var height: CGFloat?
        public var borderRadius: CGFloat = Tooltip.Size.borderRadius

        public var showArrow: Bool = true
        public var arrowWidth: CGFloat = Tooltip.Size.Arrow.width
        public var arrowHeight: CGFloat = Tooltip.Size.Arrow.height
        
        public var showCloseButton: Bool = false

        public init(
            variant: Tooltip.Variant = .extended(),
            position: Tooltip.Position = .top,
            inverse: Bool = false,
            showArrow: Bool = true,
            showCloseButton: Bool = false,
            actionTitle: String? = nil,
            action: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.position = position
            self.inverse = inverse
            self.showArrow = showArrow
            self.showCloseButton = showCloseButton
        }
    }
}

extension Tooltip {
    struct TooltipModifier: ViewModifier {
        // MARK: - Local state

        @State private var originSize: CGSize = .zero
        @State private var contentWidth: CGFloat = 10
        @State private var contentHeight: CGFloat = 10
        
        @Binding private var show: Bool
        
        // MARK: - Environment
        
        @Environment(\.colorScheme) private var colorScheme
        
        // MARK: - Uninitialised properties
        
        private var config: TooltipConfigurable
        private var content: String

        // MARK: - Initialisers

        init(
            config: TooltipConfigurable,
            show: Binding<Bool>,
            content: String
        ) {
            self.config = config
            self._show = show
            self.content = content
        }

        // MARK: - Computed properties

        private var showArrow: Bool { config.variant.isExtended && config.showArrow }
        private var showCloseButton: Bool { config.variant.isExtended && config.showCloseButton }

        private var actualArrowHeight: CGFloat { self.showArrow ? config.arrowHeight : 0 }
        private let arrowVerticalPadding: CGFloat = 1
        private let arrowHorizontalPadding: CGFloat = 12
        
        private var underLayerColor: SwiftUI.Color {
            if config.variant == .compact, config.inverse {
                SwiftUI.Color.alias(.lineNeutral)
            } else {
                SwiftUI.Color.alias(.primaryNormal).opacity(0.05)
            }
        }
        private var upperLayerColor: SwiftUI.Color {
            if config.variant == .compact, config.inverse {
                SwiftUI.Color.alias(.backgroundElevated).opacity(0.88)
            } else {
                SwiftUI.Color.alias(.inverseBackground).opacity(0.88)
            }
        }
        private var contentColor: Color.Alias {
            if config.variant == .compact, config.inverse {
                .labelNeutral
            } else {
                .inverseLabel
            }
        }
        private var borderColor: SwiftUI.Color {
            if config.inverse {
                SwiftUI.Color.alias(.lineNeutral)
            } else {
                .clear
            }
        }
        private var borderWidth: CGFloat {
            if config.inverse {
                1
            } else {
                .zero
            }
        }

        private var arrowOffsetX: CGFloat {
            switch config.position {
            case .left, .leftTop, .leftBottom:
                (
                    contentWidth / 2
                    + config.arrowHeight / 2
                    - 0.3
                )
            case .right, .rightTop, .rightBottom:
                -(
                    contentWidth / 2
                    + config.arrowHeight / 2
                    - 0.3
                )
            case .top:
                    .zero
            case .topLeft:
                -(
                    contentWidth / 2 - (config.arrowWidth + arrowHorizontalPadding)
                )
            case .topRight:
                (
                    contentWidth / 2 - (config.arrowWidth + arrowHorizontalPadding)
                )
            case .bottom:
                    .zero
            case .bottomLeft:
                -(
                    contentWidth / 2 - (config.arrowWidth + arrowHorizontalPadding)
                )
            case .bottomRight:
                (
                    contentWidth / 2 - (config.arrowWidth + arrowHorizontalPadding)
                )
            }
        }

        private var arrowOffsetY: CGFloat {
            switch config.position {
            case .left:
                    .zero
            case .leftTop:
                -(
                    contentHeight / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .leftBottom:
                (
                    contentHeight / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .right:
                    .zero
            case .rightTop:
                -(
                    contentHeight / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .rightBottom:
                (
                    contentHeight / 2 - (actualArrowHeight + arrowHorizontalPadding)
                )
            case .top, .topLeft, .topRight:
                (
                    contentHeight / 2 + actualArrowHeight / 2
                )
            case .bottom, .bottomLeft, .bottomRight:
                -(
                    contentHeight / 2 + actualArrowHeight / 2
                )
            }
        }

        // MARK: - Helper functions

        private func offsetHorizontal() -> CGFloat {
            switch config.position {
            case .left, .leftTop, .leftBottom:
                -(
                    originSize.width / 2
                    + contentWidth / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + config.margin
                )
            case .right, .rightTop, .rightBottom:
                (
                    originSize.width / 2
                    + contentWidth / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + config.margin
                )
            case .top, .bottom:
                    .zero
            case .topLeft, .bottomLeft:
                (
                    contentWidth / 2
                    - config.arrowWidth
                    - arrowHorizontalPadding
                )
            case .topRight, .bottomRight:
                -(
                    contentWidth / 2
                    - config.arrowWidth
                    - arrowHorizontalPadding
                )
            }
        }

        private func offsetVertical() -> CGFloat {
            switch config.position {
            case .left, .right:
                    .zero
            case .leftTop, .rightTop:
                (
                    contentHeight / 2
                    - config.arrowWidth / 2
                    - arrowHorizontalPadding
                )
            case .leftBottom, .rightBottom:
                -(
                    contentHeight / 2
                    - config.arrowWidth / 2
                    - arrowHorizontalPadding
                )
            case .top, .topLeft, .topRight:
                -(
                    contentHeight / 2
                    + originSize.height / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + config.margin
                )
            case .bottom, .bottomLeft, .bottomRight:
                (
                    contentHeight / 2
                    + originSize.height / 2
                    + actualArrowHeight
                    + arrowVerticalPadding
                    + config.margin
                )
            }
        }

        // MARK: - TooltipModifier Body Properties

        private var contentSizeMeasurer: some View {
            GeometryReader { proxy in
                Text("")
                    .onAppear {
                        self.contentWidth = config.width ?? proxy.size.width
                        self.contentHeight = config.height ?? proxy.size.height
                    }
            }
        }
        
        private var originSizeMeasurer: some View {
            GeometryReader { proxy in
                Text("")
                    .onAppear {
                        originSize = proxy.size
                    }
            }
        }

        @ViewBuilder
        private var arrowView: some View {
            if showArrow {
                ZStack {
                    arrowShape(degree: config.position.getArrowAngleDegree())
                        .frame(
                            width: config.arrowWidth,
                            height: config.arrowHeight
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

        private func arrowShape(degree: Double) -> some View {
            ZStack {
                Tooltip.Arrow()
                    .rotation(Angle(degrees: degree))
                    .foregroundStyle(underLayerColor)
                Tooltip.Arrow()
                    .rotation(Angle(degrees: degree))
                    .foregroundStyle(upperLayerColor)
            }
        }

        private var arrowCutoutMask: some View {
            ZStack {
                Rectangle()
                    .frame(
                        width: config.arrowWidth,
                        height: config.arrowHeight)
                    .rotationEffect(
                        Angle(
                            degrees: config.position.getArrowAngleDegree()
                        )
                    )
                    .offset(
                        x: self.arrowOffsetX,
                        y: self.arrowOffsetY)
                    .foregroundStyle(.black)
            }
            .compositingGroup()
            .luminanceToAlpha()
        }

        private var tooltipBody: some View {
            ZStack {
                ZStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: config.borderRadius)
                            .foregroundColor(underLayerColor)
                        RoundedRectangle(cornerRadius: config.borderRadius)
                            .stroke(borderColor)
                            .background(
                                RoundedRectangle(cornerRadius: config.borderRadius)
                                    .foregroundStyle(upperLayerColor)
                            )
                    }
                    .background(
                        .ultraThinMaterial
                    )
                    .clipShape(RoundedRectangle(cornerRadius: config.borderRadius))
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 6) {
                            Text(content)
                                .montage(
                                    variant: .label1,
                                    weight: .medium,
                                    color: contentColor
                                )
                                .paragraph(variant: .label1)
                                .padding(.horizontal, 2)
                            if showCloseButton {
                                Button.IconButtonController(
                                    variant: .normal(size: 16),
                                    icon: .close,
                                    iconColorResolver: Color.Alias.inverseLabel
                                ) {
                                    show = false
                                }
                                .frame(width: 16, height: 16)
                                .padding([.leading, .top], 2)
                                .fixedSize()
                                .opacity(0.61)
                            }
                        }
                        if case let .extended(title, action) = config.variant,
                           let title = title, let action = action
                        {
                            SwiftUI.Button(action: {
                                action()
                            }){
                                Text(title)
                                    .montage(
                                        variant: .label1,
                                        weight: .bold,
                                        color: .inverseLabel
                                    )
                                    .paragraph(variant: .label1)
                                    .opacity(0.61)
                                    .frame(height: 20)
                                    .padding(.horizontal, 2)
                            }
                        }
                    }
                    .padding(.all, 10)
                }
                .background(self.contentSizeMeasurer)
                .background(self.arrowView)
                .frame(
                    minWidth: 64,
                    maxWidth: 280
                )
                .fixedSize(
                    horizontal: true,
                    vertical: true
                )
            }
            .offset(
                x: offsetHorizontal(),
                y: offsetVertical()
            )
        }

        // MARK: - ViewModifier properties

        func body(content: Content) -> some View {
            content
                .background(
                    self.originSizeMeasurer
                )
                .overlay(
                    show ? tooltipBody : nil
                )
                .animation(.easeInOut, value: show)
        }
    }
}

struct Tooltip_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Text")
                .padding()
                .background(SwiftUI.Color.teal)
                .tooltip(
                    config: Tooltip.DefaultTooltipConfig(
                        position: .top,
                        showCloseButton: true
                    ),
                    show: .constant(true),
                    content: "긴 내용이 필요한 경우 이 영역을 써요. 이 텍스트는 본래 내용이 입력되기 전까지 공간을 차지하고, 배치를 확인하기 위한 텍스트입니다"
                )
        }
    }
}
