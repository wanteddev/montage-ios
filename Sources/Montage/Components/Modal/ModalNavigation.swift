//
//  ModalNavigation.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    public struct Navigation: View {
        public enum Variant: Equatable {
            case normal
            case extended
            case floating(alternative: Bool = false)
            case emphasized
        }

        /// ModalNavigation이 노출될 screenWidth입니다.
        @State private var screenWidth: CGFloat = .zero
        
        private let variant: Variant
        private let title: String
        private let scrollOffset: CGFloat
        private let left: Bar.TopNavigation.Resource.Left?
        private let backgroundColorResolvable: ColorResolvable?
        private let actions: [Bar.TopNavigation.Resource.Action]
        
        // MARK: - Computed properties
        
        private var screenWidthMeasurer: some View {
            GeometryReader { proxy in
                SwiftUI.Color.clear
                    .onAppear {
                        screenWidth = proxy.size.width
                    }
            }
        }

        private var scrolled: Bool { scrollOffset < .zero }
        private var isFloatingVariant: Bool {
            switch variant {
            case .floating: return true
            case .normal: fallthrough
            case .extended: fallthrough
            case .emphasized: return false
            }
        }
        
        private var needMaterial: Bool {
            scrolled && isFloatingVariant == false && (scrollOffset / -33) > 1
        }
        
        private var backgroundColor: SwiftUI.Color {
            if let backgroundColorResolvable {
                return .init(uiColor: backgroundColorResolvable.resolve(.current)).opacity(0.88)
            } else {
                return SwiftUI.Color.alias(.backgroundNormal).opacity(0.88)
            }
        }
        
        private var backgroundOpacity: CGFloat {
            let ratio = (scrollOffset / -32)
            return ratio > 1 ? 1 : ratio
        }

        // MARK: - Initialisers
       
        public init(
            variant: Variant = .normal,
            title: String = "",
            scrollOffset: CGFloat = .zero,
            left: Bar.TopNavigation.Resource.Left? = nil,
            backgroundColorResolvable: ColorResolvable? = nil,
            actions: [Bar.TopNavigation.Resource.Action] = []
        ) {
            self.variant = variant
            self.title = title
            self.scrollOffset = scrollOffset
            self.left = left
            self.backgroundColorResolvable = backgroundColorResolvable
            self.actions = Array(actions.prefix(3))
        }
        
        public var body: some View {
            ZStack(alignment: .bottom) {
                Contents(
                    screenWidth: $screenWidth,
                    variant: variant,
                    title: title,
                    left: left,
                    actions: actions
                )
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .background(
                    (scrolled && isFloatingVariant == false) ? backgroundColor.opacity(backgroundOpacity) : .clear
                )
                .background(
                    .ultraThinMaterial.opacity(backgroundOpacity)
                )
                if scrolled && isFloatingVariant == false {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.alias(.lineNeutral).opacity(backgroundOpacity))
                        .frame(width: screenWidth, height: 0.5)
                }
            }
            .background(
                screenWidthMeasurer
            )
        }
        
        private struct Contents: View {
            @State private var leftSize: CGSize = .zero
            @State private var actionSize: CGSize = .zero
            @Binding var screenWidth: CGFloat
            
            var variant: Variant
            var title: String
            var left: Bar.TopNavigation.Resource.Left? = nil
            var actions: [Bar.TopNavigation.Resource.Action]
            
            var body: some View {
                switch variant {
                case .normal, .extended, .floating:
                    Bar.TopNavigation.Contents(
                        screenWidth: $screenWidth,
                        variant: variant.topNavigationVariant,
                        title: title,
                        actions: actions
                    )
                case .emphasized:
                    VStack(spacing: 20) {
                        HStack {
                            Bar.TopNavigation.ExtendedLeft(left)
                            Spacer()
                            Bar.TopNavigation.ExtendedAction(actions)
                        }
                        HStack {
                            Text(title)
                                .montage(
                                    variant: variant.typoVaraint,
                                    weight: variant.typoWeight,
                                    alias: .labelStrong
                                )
                                .paragraph(variant: variant.typoVaraint)
                                .lineLimit(1)
                                .frame(alignment: variant.textAlignment)
                                .padding(.horizontal, 4)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

private extension Modal.Navigation.Variant {
    var topNavigationVariant: Bar.TopNavigation.Variant {
        switch self {
        case .normal: .normal
        case .extended: .extended
        case .floating(let alternative): .floating(alternative: alternative)
        case .emphasized: .normal
        }
    }
    var typoVaraint: Typography.Variant {
        switch self {
        case .normal: .headline2
        case .extended: .title3
        case .floating: .headline2
        case .emphasized: .title3
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .normal: .bold
        case .extended: .bold
        case .floating: .regular
        case .emphasized: .bold
        }
    }
    
    var textAlignment: Alignment {
        switch self {
        case .normal: .center
        case .extended: .leading
        case .floating: .center
        case .emphasized: .leading
        }
    }
}

struct ModalNavigation_Preview: PreviewProvider {
    static var previews: some View {
        Modal.Navigation(
            variant: .emphasized,
            title: "주의해주세요",
            left: .back(action: {}),
            actions: [.icon(.close, showPushBadge: false, action: {})]
        )
    }
}
