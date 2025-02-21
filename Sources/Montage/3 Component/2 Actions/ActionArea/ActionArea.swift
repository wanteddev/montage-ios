//
//  ActionArea.swift
//  Montage
//
//  Created by 김삼열 on 2/19/25.
//

import SwiftUI

public struct ActionArea: View, KeyboardReadable {
    // MARK: - Initializers
    
    private let variant: Variant
    
    public init(variant: Variant) {
        self.variant = variant
    }
    
    // MARK: - Body
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var isKeyboardVisible = false
    @State private var height: CGFloat = .zero
    @State private var captionHeight: CGFloat = .zero
    
    public var body: some View {
        VStack(spacing: 0) {
            backgroundColor
                .frame(height: gradientNeeded && !showExtraContents ? 0 : 20)
                .overlay {
                    if gradientNeeded {
                        if !showExtraContents {
                            LinearGradient(
                                colors: gradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 40)
                            .offset(y: -20)
                        }
                    } else {
                        if dividerNeeded {
                            Rectangle()
                                .foregroundStyle(SwiftUI.Color.alias(.lineNeutral))
                                .frame(height: 1)
                                .offset(y: -9.5)
                        }
                    }
                }
            
            VStack(spacing: 0) {
                if variant.isCompact {
                    HStack(spacing: 12) {
                        if showExtraContents {
                            extraContentView
                        } else {
                            Spacer(minLength: 0)
                        }
                        
                        Buttons(variant)
                    }
                } else {
                    VStack(spacing: 20) {
                        extraContentView
                            .padding(.bottom, 4)
                        
                        VStack(spacing: 16) {
                            captionView
                            
                            Buttons(variant)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .background(backgroundColor)
        }
        .onReceive(keyboardPublisher) { isKeyboardVisible = $0 }
    }
    
    // MARK: - Modifiers
    
    private var sticky = false
    private var caption: String?
    private var extra: (() -> any View)?
    private var extraDivider = false
    
    public func sticky(_ isSticky: Bool = true) -> Self {
        var zelf = self
        zelf.sticky = isSticky
        return zelf
    }
    
    public func caption(_ caption: String?) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }
    
    public func extra(_ content: (() -> any View)?, divider: Bool = false) -> Self {
        var zelf = self
        zelf.extra = content
        zelf.extraDivider = divider
        return zelf
    }
    
    // MARK: - Private
    private var extraContentView: some View {
        Group {
            if let extra = extra {
                AnyView(extra())
                    .background(backgroundColor)
            }
        }
    }
    
    private var captionView: some View {
        Group {
            if let caption = caption, variant.isCaptionAvailable {
                Text(caption)
                    .montage(variant: .label2, alias: .labelAlternative)
                    .paragraph(variant: .label2)
            }
        }
    }
    
    private var showExtraContents: Bool { extra != nil }
    private var gradient: [SwiftUI.Color] {
        [0, 0.14, 0.27, 0.38, 0.48, 0.57, 0.65, 0.71, 0.77, 0.82, 0.86, 0.9, 0.93, 0.96, 0.98, 1]
            .map {
                backgroundColor.opacity($0)
            }
    }
    
    private var backgroundColor: SwiftUI.Color {
        sticky
            ? (showExtraContents ? .alias(.backgroundElevated) : .alias(.backgroundNormal))
            : .clear
    }
    
    private var gradientNeeded: Bool {
        sticky && !showExtraContents && !variant.isCompact
    }
    
    private var dividerNeeded: Bool {
        extraDivider || variant.isCompact || caption != nil
    }
    
    // MARK: - Types
    
    public enum Variant {
        case strong(main: Action, sub: Action? = nil, alternative: Action? = nil)
        case neutral(main: Action, sub: Action? = nil, alternative: Action? = nil)
        case compact(main: Action, sub: Action? = nil)
        case cancel(main: Action)
        
        fileprivate var isCompact: Bool {
            switch self {
            case .compact:
                true
            default:
                false
            }
        }
        
        fileprivate var isCaptionAvailable: Bool {
            switch self {
            case .strong, .neutral: true
            default: false
            }
        }
    }
    
    public struct Action {
        let text: String
        let action: () -> Void
        let custom: (() -> any View)?
        
        /// ActionArea/Bottom의 항목을 기본값으로 생성합니다.
        /// - Parameters:
        ///   - text: 기본 컴포넌트에 나타날 텍스트입니다.
        ///   - action: 기본 컴포넌트 클릭시 동작할 내용입니다.
        public init(
            text: String,
            action: @escaping (() -> Void)
        ) {
            self.text = text
            self.action = action
            custom = nil
        }
        
        /// ActionArea/Bottom의 항목을 커스텀하여 생성합니다.
        /// - Parameter custom: 커스텀 Montage/Button 컴포넌트입니다.
        /// > Component 사용하는 과정에서 fixedSize를 내부에서 지정하기 때문에
        /// > 전달하는 Button 컴포넌트는 fixedSize를 지정하여 전달하면 안됩니다.
        public init(
            custom: @escaping (() -> any View)
        ) {
            text = ""
            action = {}
            self.custom = custom
        }
    }
    
    // MARK: - Inner Views
    
    private struct Buttons: View {
        private let variant: Variant
        
        init( _ variant: Variant) {
            self.variant = variant
        }
        
        var body: some View {
            Group {
                switch variant {
                case let .strong(main, sub, alternative):
                    strong(main, sub, alternative)
                case let .neutral(main, sub, alternative):
                    neutral(main, sub, alternative)
                case let .compact(main, sub):
                    compact(main, sub)
                case let .cancel(main):
                    cancel(main)
                }
            }
        }
        
        @ViewBuilder
        private func strong(
            _ main: Action,
            _ sub: Action?,
            _ alternative: Action?
        ) -> some View {
            VStack(spacing: 8) {
                if let customButton = main.custom {
                    AnyView(customButton())
                } else {
                    Button.SolidButton(
                        variant: .primary,
                        size: .large,
                        text: main.text,
                        handler: main.action
                    )
                    .fill(horizontal: true, vertical: false)
                }
                if let alternative {
                    if let customButton = alternative.custom {
                        AnyView(customButton())
                    } else {
                        Button.OutlinedButton(
                            variant: .secondary,
                            size: .large,
                            text: alternative.text,
                            handler: alternative.action
                        )
                        .fill(horizontal: true, vertical: false)
                    }
                }
                if let sub {
                    if let customButton = sub.custom {
                        AnyView(customButton())
                    } else {
                        Button.TextButton(
                            variant: .assistive,
                            size: .small,
                            text: sub.text,
                            handler: sub.action
                        )
                    }
                }
            }
        }
        
        @ViewBuilder
        private func neutral(
            _ main: Action,
            _ sub: Action?,
            _ alternative: Action?
        ) -> some View {
            HStack(spacing: 12) {
                if let sub {
                    if let customButton = sub.custom {
                        AnyView(customButton())
                    } else {
                        Button.OutlinedButton(
                            variant: .assistive,
                            size: .large,
                            text: sub.text,
                            handler: sub.action
                        )
                    }
                }
                if let alternative {
                    if let customButton = alternative.custom {
                        AnyView(customButton())
                    } else {
                        Button.OutlinedButton(
                            variant: .secondary,
                            size: .large,
                            text: alternative.text,
                            handler: alternative.action
                        )
                        .fill(horizontal: true, vertical: false)
                    }
                }
                if let customButton = main.custom {
                    AnyView(customButton())
                } else {
                    Button.SolidButton(
                        variant: .primary,
                        size: .large,
                        text: main.text,
                        handler: main.action
                    )
                    .fill(horizontal: true, vertical: false)
                }
            }
        }
        
        @ViewBuilder
        private func compact(
            _ main: Action,
            _ sub: Action?
        ) -> some View {
            HStack(spacing: 12) {
                if let sub {
                    if let customButton = sub.custom {
                        AnyView(customButton())
                    } else {
                        Button.OutlinedButton(
                            variant: .assistive,
                            size: .large,
                            text: sub.text,
                            handler: sub.action
                        )
                    }
                }
                if let customButton = main.custom {
                    AnyView(customButton())
                } else {
                    Button.SolidButton(
                        variant: .primary,
                        size: .large,
                        text: main.text,
                        handler: main.action
                    )
                }
            }
        }
        
        @ViewBuilder
        private func cancel(
            _ main: Action
        ) -> some View {
            if let customButton = main.custom {
                AnyView(customButton())
            } else {
                Button.OutlinedButton(
                    variant: .assistive,
                    size: .large,
                    text: main.text,
                    handler: main.action
                )
                .fill(horizontal: true, vertical: false)
            }
        }
    }
}

public struct ActionAreaModifier: ViewModifier {
    // MARK: - Initializer
    private let model: Model
    public init(model: Model) {
        self.model = model
    }
    
    // MARK: - Body
        
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            ActionArea(variant: model.variant)
                .sticky(model.sticky)
                .caption(model.caption)
                .extra(model.extra, divider: model.extraDivider)
        }
    }
    
    // MARK: - Types
    
    public struct Model {
        let variant: ActionArea.Variant
        let sticky: Bool
        let caption: String?
        let extra: (() -> any View)?
        let extraDivider: Bool
        
        public init(
            variant: ActionArea.Variant,
            sticky: Bool = false,
            caption: String? = nil,
            extra: (() -> any View)? = nil,
            extraDivider: Bool = false
        ) {
            self.variant = variant
            self.sticky = sticky
            self.caption = caption
            self.extra = extra
            self.extraDivider = extraDivider
        }
    }
}
