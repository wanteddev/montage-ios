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
            if let extra = extra {
                ZStack(alignment: .top) {
                    AnyView(extra())
                        .padding([.top, .horizontal], 20)
                        .padding(.bottom, 24)
                        .background(backgroundColor)
                    
                    if extraDivider {
                        Rectangle()
                            .foregroundStyle(SwiftUI.Color.alias(.lineNeutral))
                            .frame(height: 1)
                    }
                }
            } else {
                backgroundColor
                    .frame(height: 0)
                    .overlay {
                        if !clearBackground {
                            LinearGradient(
                                colors: gradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 40)
                            .offset(y: -20)
                        }
                    }
            }
            
            VStack(spacing: 16) {
                captionView
                
                Buttons(variant)
            }
            .padding(.horizontal, 20)
            .background(backgroundColor)
        }
        .onReceive(keyboardPublisher) { isKeyboardVisible = $0 }
    }
    
    // MARK: - Modifiers
    
    private var clearBackground = false
    private var caption: String?
    private var extra: (() -> any View)?
    private var extraDivider = false
    
    public func clearBackground(_ clearBackground: Bool = true) -> Self {
        var zelf = self
        zelf.clearBackground = clearBackground
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
}
    
// MARK: - Types
extension ActionArea {
    public enum Variant {
        case strong(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        case neutral(main: ButtonInfo, sub: ButtonInfo? = nil, alternative: ButtonInfo? = nil)
        case cancel(main: ButtonInfo)
        
        fileprivate var isCaptionAvailable: Bool {
            switch self {
            case .strong, .neutral: true
            default: false
            }
        }
    }
    
    public struct ButtonInfo {
        internal let text: String
        internal let action: () -> Void
        internal var custom: (() -> any View)?
        
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
        
        private init(
            custom: @escaping (() -> any View)
        ) {
            text = ""
            action = {}
            self.custom = custom
        }
        
        /// ActionArea/Bottom의 항목을 커스텀하여 생성합니다.
        /// - Parameter custom: 커스텀 Montage/Button 컴포넌트입니다.
        /// > 버튼 크기가 가능한 한 최대 크기가 되도록 하려면 fill(horizontal:vertical:) 모디파이어를 사용하십시오.
        public static func custom(
            _ custom: @escaping (() -> any View)
        ) -> Self {
            self.init(custom: custom)
        }
    }
}

// MARK: - Private
private extension ActionArea {
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
        !clearBackground || showExtraContents ? .alias(.backgroundElevated) : .clear
    }
}

// MARK: - Inner Views

private extension ActionArea {
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
                case let .cancel(main):
                    cancel(main)
                }
            }
        }
        
        @ViewBuilder
        private func strong(
            _ main: ButtonInfo,
            _ sub: ButtonInfo?,
            _ alternative: ButtonInfo?
        ) -> some View {
            VStack(spacing: 8) {
                primarySolidButton(main)
                if let alternative {
                    secondaryOutlinedButton(alternative)
                }
                if let sub {
                    assistiveTextButton(sub)
                }
            }
        }
        
        @ViewBuilder
        private func neutral(
            _ main: ButtonInfo,
            _ sub: ButtonInfo?,
            _ alternative: ButtonInfo?
        ) -> some View {
            HStack(spacing: 12) {
                if let sub {
                    assistiveOutlinedButton(sub, fillWidth: false)
                }
                if let alternative {
                    secondaryOutlinedButton(alternative)
                }
                primarySolidButton(main)
            }
        }
        
        @ViewBuilder
        private func cancel(
            _ main: ButtonInfo
        ) -> some View {
            assistiveOutlinedButton(main)
        }
        
        private func primarySolidButton(_ buttonInfo: ButtonInfo) -> some View {
            Group {
                if let customButton = buttonInfo.custom {
                    AnyView(customButton())
                } else {
                    Button.SolidButton(
                        variant: .primary,
                        size: .large,
                        text: buttonInfo.text,
                        handler: buttonInfo.action
                    )
                    .fill(horizontal: true, vertical: false)
                }
            }
        }
        
        private func secondaryOutlinedButton(_ buttonInfo: ButtonInfo) -> some View {
            Group {
                if let customButton = buttonInfo.custom {
                    AnyView(customButton())
                } else {
                    Button.OutlinedButton(
                        variant: .secondary,
                        size: .large,
                        text: buttonInfo.text,
                        handler: buttonInfo.action
                    )
                    .fill(horizontal: true, vertical: false)
                }
            }
        }
        
        private func assistiveOutlinedButton(_ buttonInfo: ButtonInfo, fillWidth: Bool = true) -> some View {
            Group {
                if let customButton = buttonInfo.custom {
                    AnyView(customButton())
                } else {
                    Button.OutlinedButton(
                        variant: .assistive,
                        size: .large,
                        text: buttonInfo.text,
                        handler: buttonInfo.action
                    )
                    .if(fillWidth) {
                        $0.fill(horizontal: true, vertical: false)
                    }
                }
            }
        }
        
        private func assistiveTextButton(_ buttonInfo: ButtonInfo) -> some View {
            Group {
                if let customButton = buttonInfo.custom {
                    AnyView(customButton())
                } else {
                    Button.TextButton(
                        variant: .assistive,
                        size: .small,
                        text: buttonInfo.text,
                        handler: buttonInfo.action
                    )
                }
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
                .caption(model.caption)
                .extra(model.extra, divider: model.extraDivider)
                .if(true) {
                    if case .manual(let visibility) = model.backgroundVisibility {
                        $0.clearBackground(visibility)
                    } else {
                        $0
                    }
                }
        }
    }
    
    // MARK: - Types
    
    public struct Model {
        let variant: ActionArea.Variant
        let backgroundVisibility: BackgroundVisibility
        let caption: String?
        let extra: (() -> any View)?
        let extraDivider: Bool
        
        public init(
            variant: ActionArea.Variant,
            backgroundVisibility: BackgroundVisibility = .automatic,
            caption: String? = nil,
            extra: (() -> any View)? = nil,
            extraDivider: Bool = false
        ) {
            self.variant = variant
            self.backgroundVisibility = backgroundVisibility
            self.caption = caption
            self.extra = extra
            self.extraDivider = extraDivider
        }
    }
    
    public enum BackgroundVisibility {
        case automatic
        case manual(_ visible: Bool)
        
        var isManual: Bool {
            switch self {
            case .automatic:
                return false
            case .manual:
                return true
            }
        }
    }
}
