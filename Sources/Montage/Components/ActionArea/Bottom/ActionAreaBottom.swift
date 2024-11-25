//
//  ActionAreaBottom.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/9/24.
//

import SwiftUI

extension ActionArea {
    /// ActionArea/Bottom Component입니다.
    ///
    /// - Parameters:
    ///     - model: 하단 영역에 노출될 Component에 대한 configuration입니다.
    ///     - content: 하단 영역을 제외하고 노출될 내용 입니다.
    public struct Bottom: View {
        @State private var bottomActionHeight: CGFloat = .zero
        private let model: ActionArea.Bottom.Model
        private let content: () -> any View
     
        public init(
            model: ActionArea.Bottom.Model,
            content: @escaping () -> any View
        ) {
            self.model = model
            self.content = content
        }
        
        public var body: some View {
            VStack(spacing: .zero) {
                AnyView(content())
                    .padding(.bottom, -20)
                Component(model: model)
                    .readSize { bottomActionHeight = $0.height }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        
        /// 하단 영역에 노출될 Gradient, Button들이 집합된 Component입니다.
        public struct Component: View {
            // MARK: - Environment
            
            @Environment(\.safeAreaInsets) private var safeAreaInsets
            
            // MARK: - Local state
            
            @State private var height: CGFloat = .zero
            @State private var captionHeight: CGFloat = .zero
            
            // MARK: - Uninitialised properties
            
            private let model: ActionArea.Bottom.Model
            
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
                    [
                        .clear,
                        .alias(.backgroundElevated).opacity(0.14),
                        .alias(.backgroundElevated).opacity(0.29),
                        .alias(.backgroundElevated).opacity(0.34),
                        .alias(.backgroundElevated).opacity(0.40),
                        .alias(.backgroundElevated).opacity(0.54),
                        .alias(.backgroundElevated).opacity(0.74),
                        .alias(.backgroundElevated).opacity(0.86),
                        .alias(.backgroundElevated)
                    ]
                } else {
                    [
                        .clear,
                        .alias(.backgroundNormal).opacity(0.14),
                        .alias(.backgroundNormal).opacity(0.29),
                        .alias(.backgroundNormal).opacity(0.34),
                        .alias(.backgroundNormal).opacity(0.40),
                        .alias(.backgroundNormal).opacity(0.54),
                        .alias(.backgroundNormal).opacity(0.74),
                        .alias(.backgroundNormal).opacity(0.86),
                        .alias(.backgroundNormal)
                    ]
                }
            }
            private let gradientHeight: CGFloat = 40
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
           
            public init(model: ActionArea.Bottom.Model) {
                self.model = model
            }
            
            public var body: some View {
                ZStack(alignment: .top) {
                    VStack(spacing: .zero) {
                        if model.sticky || showExtraContents {
                            ZStack(alignment: .bottom) {
                                backgroundColor
                                    .frame(height: 20)
                                LinearGradient(
                                    colors: gradient,
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .frame(height: gradientHeight)
                                .offset(y: -20)
                            }
                            backgroundColor
                                .frame(height: height + captionHeight - gradientHeight)
                        }
                    }
                    .frame(height: height + captionHeight)
                    
                    VStack(spacing: .zero) {
                        if model.variant == .extra, let extraContents = model.extraContents {
                            AnyView(
                                extraContents()
                            )
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
                        }
                        .padding([.top, .horizontal], 20)
                    }
                    .padding(.bottom, 20)
                    
                    if showExtraContents {
                        Divider()
                            .background(SwiftUI.Color.alias(.lineNeutral))
                    }
                }
                .background(sizeMeasurer)
                .overlay {
                    if model.sticky, showExtraContents == false {
                        VStack {
                            Spacer()
                            backgroundColor
                                .frame(height: safeAreaInsets.bottom != .zero ? 14 : .zero)
                        }
                    }
                }
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
                    case let .cancel(main):
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
                        if let customButton = main.custom {
                            AnyView(customButton())
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
                            if let customButton = alternative.custom {
                                AnyView(customButton())
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
                            if let customButton = sub.custom {
                                AnyView(customButton())
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
                            if let customButton = sub.custom {
                                AnyView(customButton())
                            } else {
                                Button.OutlinedButtonController(
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
                        if let customButton = main.custom {
                            AnyView(customButton())
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
                            if let customButton = sub.custom {
                                AnyView(customButton())
                            } else {
                                Button.OutlinedButtonController(
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
                            Button.SolidButtonController(
                                variant: .primary,
                                size: .large,
                                text: main.text,
                                handler: main.action
                            )
                        }
                    }
                }
                
                @ViewBuilder
                private func single(
                    _ main: Bottom.Action
                ) -> some View {
                    if let customButton = main.custom {
                        AnyView(customButton())
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
        case cancel(main: Action)
    }
    
    public struct Action {
        let text: String
        let action: (() -> Void)
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
            self.custom = nil
        }
        
        /// ActionArea/Bottom의 항목을 커스텀하여 생성합니다.
        /// - Parameter custom: 커스텀 Montage/Button 컴포넌트입니다.
        /// > Component 사용하는 과정에서 fixedSize를 내부에서 지정하기 때문에
        /// > 전달하는 Button 컴포넌트는 fixedSize를 지정하여 전달하면 안됩니다.
        public init(
            custom: @escaping (() -> any View)
        ) {
            self.text = ""
            self.action = {}
            self.custom = custom
        }
    }
    
    public struct Model {
        let variant: Variant
        let priority: Priority
        let sticky: Bool
        var caption: String?
        var extraContents: (() -> any View)?
        
        public init(
            variant: Variant = .normal,
            priority: Priority,
            sticky: Bool = false,
            caption: String? = nil,
            extraContents: (() -> any View)?
        ) {
            self.variant = variant
            self.priority = priority
            self.sticky = sticky
            self.caption = caption
            self.extraContents = extraContents
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

#Preview {
    ActionArea.Bottom(
        model: .init(
            variant: .normal,
            priority: .strong(
                main: .init(text: "메인", action: {}),
                sub: .init(text: "서브", action: {}),
                alternative: .init(text: "대안", action: {})
            ),
            sticky: true
        )
    ) {
        ScrollView {
            SwiftUI.Color.red.frame(height: 1400)
        }
    }
}
