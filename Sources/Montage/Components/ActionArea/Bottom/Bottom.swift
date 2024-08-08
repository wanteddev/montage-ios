//
//  Bottom.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/9/24.
//

import SwiftUI

extension ActionArea {
    public enum Bottom {
        public struct Component<ExtraContents: View>: View {
            // MARK: - Environment
            
            @Environment(\.safeAreaInsets) private var safeAreaInsets
            
            // MARK: - Local state
            
            @State private var height: CGFloat = .zero
            @State private var captionHeight: CGFloat = .zero
            
            // MARK: - Uninitialised properties
            
            private let model: ActionArea.Bottom.Model<ExtraContents>
            
            // MARK: - Computed properties
            
            private var enableCaption: Bool {
                switch model.priority {
                case .strong, .neutral: true
                default: false
                }
            }
            private var showExtraContents: Bool { model.extraContents != nil }
            private var gradient: [SwiftUI.Color] {
                if showExtraContents {
                    [.clear, .alias(.backgroundElevated)]
                } else {
                    [.clear, .alias(.backgroundNormal)]
                }
            }
            private var backgroundColor: SwiftUI.Color {
                showExtraContents ? .alias(.backgroundElevated) : .alias(.backgroundNormal)
            }
            private var sizeMeasurer: some View {
                GeometryReader { proxy in
                    Text("")
                        .onAppear {
                            height = proxy.size.height
                        }
                }
            }
            private var captionSizeMeasurer: some View {
                GeometryReader { proxy in
                    Text("")
                        .onAppear {
                            captionHeight = proxy.size.height
                        }
                        .onDisappear {
                            captionHeight = .zero
                        }
                }
            }
            
            // MARK: - Initialisers
           
            public init(model: ActionArea.Bottom.Model<ExtraContents>) {
                self.model = model
            }
            
            public var body: some View {
                ZStack(alignment: .top) {
                    VStack(spacing: .zero) {
                        if model.sticky, showExtraContents == false {
                            ZStack(alignment: .bottom) {
                                backgroundColor
                                    .frame(height: 20)
                                LinearGradient(
                                    colors: gradient,
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: 40)
                                .offset(y: -20)
                            }
                        }
                        backgroundColor
                    }
                    .frame(height: height + captionHeight)
                    VStack(spacing: .zero) {
                        if let extraContents = model.extraContents {
                            extraContents
                                .background(SwiftUI.Color.alias(.backgroundElevated))
                                .padding([.top, .horizontal], 20)
                                .padding(.bottom, 4)
                        }
                        VStack(spacing: .zero) {
                            if let caption = model.caption, enableCaption {
                                Text(caption)
                                    .montage(variant: .label2, alias: .labelAlternative)
                                    .paragraph(variant: .label2)
                                    .padding(.bottom, 16)
                                    .background(
                                        captionSizeMeasurer
                                    )
                            }
                            ActionView(model.priority)
                                .background(
                                    backgroundColor
                                )
                        }
                        .padding([.top, .horizontal], 20)
                    }
                    .padding(.bottom, safeAreaInsets.bottom)
                    if showExtraContents {
                        Divider()
                            .background(SwiftUI.Color.alias(.lineNeutral))
                    }
                }
                .background(sizeMeasurer)
            }
            
            private struct ActionView: View {
                private let priority: Priority
                
                init( _ priority: Priority) {
                    self.priority = priority
                }
                
                var body: some View {
                    switch priority {
                    case let .strong(main, sub, alternative):
                        strong(main, sub, alternative)
                    case let .neutral(main, sub, alternative):
                        neutral(main, sub, alternative)
                    case let .compact(main, sub):
                        compact(main, sub)
                    case let .single(main):
                        single(main)
                    }
                }
                
                @ViewBuilder
                private func strong(
                    _ main: Bottom.Action,
                    _ sub: Bottom.Action?,
                    _ alternative: Bottom.Action?
                ) -> some View {
                    VStack(spacing: 8) {
                        if let option = main.buttonOption {
                            button(option: option, text: main.text, action: main.action)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Button.SolidButtonController(
                                variant: .primary,
                                size: .large,
                                text: main.text,
                                handler: main.action
                            )
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        if let alternative {
                            if let option = alternative.buttonOption {
                                button(option: option, text: alternative.text, action: alternative.action)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Button.OutlinedButtonController(
                                    variant: .secondary,
                                    size: .large,
                                    text: alternative.text,
                                    handler: alternative.action
                                )
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        if let sub {
                            if let option = sub.buttonOption {
                                button(option: option, text: sub.text, action: sub.action)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Button.TextButton(
                                    variant: .assistive,
                                    size: .small,
                                    text: sub.text,
                                    handler: sub.action
                                )
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
                
                @ViewBuilder
                private func neutral(
                    _ main: Bottom.Action,
                    _ sub: Bottom.Action?,
                    _ alternative: Bottom.Action?
                ) -> some View {
                    HStack(spacing: 12) {
                        if let sub {
                            if let option = sub.buttonOption {
                                button(option: option, text: sub.text, action: sub.action)
                                    .fixedSize()
                            } else {
                                Button.OutlinedButtonController(
                                    variant: .secondary,
                                    size: .large,
                                    text: sub.text,
                                    handler: sub.action
                                )
                                .fixedSize()
                            }
                        }
                        if let alternative {
                            if let option = alternative.buttonOption {
                                button(option: option, text: alternative.text, action: alternative.action)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                Button.OutlinedButtonController(
                                    variant: .secondary,
                                    size: .large,
                                    text: alternative.text,
                                    handler: alternative.action
                                )
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        if let option = main.buttonOption {
                            button(option: option, text: main.text, action: main.action)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Button.SolidButtonController(
                                variant: .primary,
                                size: .large,
                                text: main.text,
                                handler: main.action
                            )
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                
                @ViewBuilder
                private func compact(
                    _ main: Bottom.Action,
                    _ sub: Bottom.Action?
                ) -> some View {
                    HStack(spacing: 12) {
                        Spacer()
                        if let sub {
                            if let option = sub.buttonOption {
                                button(option: option, text: sub.text, action: sub.action)
                                    .fixedSize()
                            } else {
                                Button.OutlinedButtonController(
                                    variant: .secondary,
                                    size: .large,
                                    text: sub.text,
                                    handler: sub.action
                                )
                                .fixedSize()
                            }
                        }
                        if let option = main.buttonOption {
                            button(option: option, text: main.text, action: main.action)
                                .fixedSize()
                        } else {
                            Button.SolidButtonController(
                                variant: .primary,
                                size: .large,
                                text: main.text,
                                handler: main.action
                            )
                            .fixedSize()
                        }
                    }
                }
                
                @ViewBuilder
                private func single(
                    _ main: Bottom.Action
                ) -> some View {
                    if let option = main.buttonOption {
                        button(option: option, text: main.text, action: main.action)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Button.OutlinedButtonController(
                            variant: .assistive,
                            size: .large,
                            text: main.text,
                            handler: main.action
                        )
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                @ViewBuilder
                private func button(
                    option: Bottom.ButtonOption,
                    text: String,
                    action: @escaping (() -> Void)
                ) -> some View {
                    switch option {
                    case .soild(let variant):
                        Button.SolidButtonController(
                            variant: variant,
                            size: .large,
                            text: text,
                            handler: action
                        )
                    case .outline(let variant):
                        Button.OutlinedButtonController(
                            variant: variant,
                            size: .large,
                            text: text,
                            handler: action
                        )
                    case .text(let variant):
                        Button.TextButton(
                            variant: variant,
                            text: text,
                            handler: action
                        )
                    }
                }
            }
        }
    }
}

extension ActionArea.Bottom {
    public enum Variant {
        case normal
        case extra
    }
    
    public enum Priority {
        case strong(main: Action, sub: Action? = nil, alternative: Action? = nil)
        case neutral(main: Action, sub: Action? = nil, alternative: Action? = nil)
        case compact(main: Action, sub: Action? = nil)
        case single(main: Action)
    }
    
    public struct Action {
        let text: String
        var buttonOption: ButtonOption?
        let action: (() -> Void)
        
        public init(
            text: String,
            buttonOption: ButtonOption? = nil,
            action: @escaping () -> Void
        ) {
            self.text = text
            self.buttonOption = buttonOption
            self.action = action
        }
    }
    
    public enum ButtonOption {
        case soild(Button.SolidButton.Variant = .primary)
        case outline(Button.OutlinedButton.Variant = .assistive)
        case text(Button.TextButton.Variant = .assistive)
    }
    
    public struct Model<ExtraContents: View> {
        let variant: Variant
        let priority: Priority
        let sticky: Bool
        var caption: String?
        var extraContents: ExtraContents?
        
        public init(
            variant: Variant = .normal,
            priority: Priority,
            sticky: Bool = false,
            caption: String? = nil,
            @ViewBuilder extraContents: () -> ExtraContents?
        ) {
            self.variant = variant
            self.priority = priority
            self.sticky = sticky
            self.caption = caption
            self.extraContents = extraContents()
        }
        
        public init(
            variant: Variant = .normal,
            priority: Priority,
            sticky: Bool = false,
            caption: String? = nil
        ) {
            self.variant = variant
            self.priority = priority
            self.sticky = sticky
            self.caption = caption
            self.extraContents = nil
        }
    }
}

struct Bottom_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            SwiftUI.Color.red
            ActionArea.Bottom.Component<AnyView>(
                model: .init(
                    variant: .normal,
                    priority: .single(
                        main: .init(text: "메인", buttonOption: .outline(.assistive), action: {})
                    )
                )
            )
        }
    }
}
