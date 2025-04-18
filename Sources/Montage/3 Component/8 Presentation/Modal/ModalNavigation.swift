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
            
            fileprivate var isFloating: Bool {
                switch self {
                case .floating: true
                case .normal, .extended, .emphasized: false
                }
            }
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
                    leadingButton: leadingButton,
                    trailingButtons: trailingButtons
                )
                .if(needHandleArea) {
                    $0.padding(.top, 10)
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
                .background {
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial)
                            .opacity(backgroundOpacity)
                        backgroundColor
                            .opacity(backgroundOpacity * 0.70)
                    }
                    .ignoresSafeArea(.container, edges: .top)
                }
                
                if scrolled && variant.isFloating == false {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.semantic(.lineNeutral).opacity(backgroundOpacity))
                        .frame(height: 0.5)
                }
            }
        }
        
        // MARK: - Modifiers
        
        private var variant: Variant = .normal
        private var backgroundColor: SwiftUI.Color? = nil
        private var needHandleArea = false
        private var leadingButton: Bar.TopNavigation.Resource.LeadingButton? = nil
        private var trailingButtons: [Bar.TopNavigation.Resource.TrailingButton] = []

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
        
        public func leadingButton(_ leadingButton: Bar.TopNavigation.Resource.LeadingButton?) -> Self {
            var zelf = self
            zelf.leadingButton = leadingButton
            return zelf
        }
        
        public func trailingButtons(_ actions: [Bar.TopNavigation.Resource.TrailingButton]) -> Self {
            var zelf = self
            zelf.trailingButtons = Array(actions.prefix(3))
            return zelf
        }
        
        private struct Contents: View {
            var variant: Variant
            var title: String
            var leadingButton: Bar.TopNavigation.Resource.LeadingButton?
            var trailingButtons: [Bar.TopNavigation.Resource.TrailingButton]
            
            var body: some View {
                switch variant {
                case .normal, .extended, .floating:
                    Bar.TopNavigation.Contents(
                        variant: variant.topNavigationVariant,
                        title: title,
                        leadingButton: leadingButton,
                        trailingButtons: trailingButtons
                    )
                case .emphasized:
                    ZStack {
                        HStack(spacing: 20) {
                            Bar.TopNavigation.LeadingButton(leadingButton)
                            Text(title)
                                .montage(
                                    variant: variant.typoVaraint,
                                    weight: variant.typoWeight,
                                    semantic: .labelStrong
                                )
                                .paragraph(variant: variant.typoVaraint)
                                .lineLimit(1)
                                .frame(height: 24, alignment: variant.textAlignment)
                            Spacer(minLength: 0)
                            Bar.TopNavigation.TrailingButtons(trailingButtons)
                        }
                    }
                }
            }
        }
    }
}

private extension Modal.Navigation {
    var scrolled: Bool { scrollOffset < .zero }
    
    var backgroundOpacity: CGFloat {
        if variant.isFloating {
            return 0
        } else {
            let ratio = (scrollOffset / -32)
            return max(0, min(1, ratio))
        }
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
