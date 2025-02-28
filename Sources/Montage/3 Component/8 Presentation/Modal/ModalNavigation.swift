//
//  ModalNavigation.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    public struct Navigation: View {
        // MARK: - Types
        
        public enum Variant: Equatable {
            case normal
            case extended
            case floating(alternative: Bool = false, background: Bool = true)
            case emphasized
        }
        
        // MARK: - Initialisers
        
        private let title: String
        @Binding private var scrollOffset: CGFloat
        
        public init(title: String, scrollOffset: Binding<CGFloat> = .constant(0)) {
            self.title = title
            _scrollOffset = scrollOffset
        }

        // MARK: - Body
        
        public var body: some View {
            ZStack(alignment: .bottom) {
                Contents(
                    variant: variant,
                    title: title,
                    left: left,
                    actions: actions
                )
                .if(needHandleArea) {
                    $0.padding(.top, 10)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .background(
                    (scrolled && isFloatingVariant == false) ? _backgroundColor
                        .opacity(backgroundOpacity) : .clear
                )
                .background(
                    (scrolled && isFloatingVariant == false) ?
                        Material.ultraThinMaterial.opacity(backgroundOpacity)
                        : Material.ultraThinMaterial.opacity(.zero)
                )
                if scrolled && isFloatingVariant == false {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.alias(.lineNeutral).opacity(backgroundOpacity))
                        .frame(height: 0.5)
                }
            }
        }
        
        // MARK: - Modifiers
        
        private var variant: Variant = .normal
        private var left: Bar.TopNavigation.Resource.Left? = nil
        private var backgroundColor: SwiftUI.Color? = nil
        private var needHandleArea = false
        private var actions: [Bar.TopNavigation.Resource.Action] = []

        public func variant(_ variant: Variant) -> Self {
            var zelf = self
            zelf.variant = variant
            return zelf
        }

        public func scrollOffset(_ scrollOffset: Binding<CGFloat>) -> Self {
            var zelf = self
            zelf._scrollOffset = scrollOffset
            return zelf
        }
        
        public func left(_ left: Bar.TopNavigation.Resource.Left?) -> Self {
            var zelf = self
            zelf.left = left
            return zelf
        }
        
        public func backgroundColor(_ backgroundColor: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.backgroundColor = backgroundColor
            return zelf
        }
        
        public func needHandleArea(_ needHandleArea: Bool) -> Self {
            var zelf = self
            zelf.needHandleArea = needHandleArea
            return zelf
        }
        
        public func actions(_ actions: [Bar.TopNavigation.Resource.Action]) -> Self {
            var zelf = self
            zelf.actions = Array(actions.prefix(3))
            return zelf
        }
        
        private struct Contents: View {
            @State private var leftSize: CGSize = .zero
            @State private var actionSize: CGSize = .zero
            
            var variant: Variant
            var title: String
            var left: Bar.TopNavigation.Resource.Left?
            var actions: [Bar.TopNavigation.Resource.Action]
            
            var body: some View {
                switch variant {
                case .normal, .extended, .floating:
                    Bar.TopNavigation.Contents(
                        variant: variant.topNavigationVariant,
                        title: title,
                        left: left,
                        actions: actions
                    )
                case .emphasized:
                    ZStack {
                        HStack(spacing: 20) {
                            Bar.TopNavigation.NormalLeft(left)
                            Text(title)
                                .montage(
                                    variant: variant.typoVaraint,
                                    weight: variant.typoWeight,
                                    alias: .labelStrong
                                )
                                .paragraph(variant: variant.typoVaraint)
                                .lineLimit(1)
                                .frame(height: 24, alignment: variant.textAlignment)
                            Spacer(minLength: 0)
                            Bar.TopNavigation.NormalAction(actions)
                        }
                    }
                }
            }
        }
    }
}

private extension Modal.Navigation {
    var scrolled: Bool { scrollOffset < .zero }
    var isFloatingVariant: Bool {
        switch variant {
        case .floating: true
        case .normal, .extended, .emphasized: false
        }
    }
    
    var needMaterial: Bool {
        scrolled && isFloatingVariant == false && (scrollOffset / -33) > 1
    }
    
    var _backgroundColor: SwiftUI.Color {
        if let backgroundColor {
            backgroundColor.opacity(0.88)
        } else {
            SwiftUI.Color.alias(.backgroundNormal).opacity(0.88)
        }
    }
    
    var backgroundOpacity: CGFloat {
        let ratio = (scrollOffset / -32)
        return ratio > 1 ? 1 : ratio
    }
}

private extension Modal.Navigation.Variant {
    var topNavigationVariant: Bar.TopNavigation.Variant {
        switch self {
        case .normal: .normal
        case .extended: .extended
        case .floating(let alternative, let background): .floating(
                alternative: alternative,
                background: background
            )
        case .emphasized: .normal
        }
    }

    var typoVaraint: Typography.Variant {
        switch self {
        case .normal: .headline2
        case .extended: .title3
        case .floating: .headline2
        case .emphasized: .heading2
        }
    }
    
    var typoWeight: Typography.Weight {
        switch self {
        case .normal: .bold
        case .extended: .bold
        case .floating: .bold
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
