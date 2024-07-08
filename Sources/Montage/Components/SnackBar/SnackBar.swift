//
//  SnackBar.swift
//
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

public struct SnackBar: View {
    public struct Model {
        var heading: String? = nil
        var description: String? = nil
        var extraContents: (any View)? = nil
        let action: String
        let handler: (() -> Void)
        
        public init(
            heading: String? = nil,
            description: String? = nil,
            extraContents: (any View)? = nil,
            action: String,
            handler: @escaping () -> Void
        ) {
            self.heading = heading
            self.description = description
            self.extraContents = extraContents
            self.action = action
            self.handler = handler
        }
    }
    
    private var heading: String?
    private var description: String?
    private var extraContents: (any View)?
    private let action: String
    private let handler: (() -> Void)
    
    init(
        heading: String? = nil,
        description: String? = nil,
        extraContents: (any View)? = nil,
        action: String,
        handler: @escaping () -> Void
    ) {
        self.heading = heading
        self.description = description
        self.extraContents = extraContents
        self.action = action
        self.handler = handler
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Contents(
                heading: heading,
                description: description,
                extraContents: extraContents,
                action: action,
                handler: handler
            )
            .padding(.horizontal, 20)
        }
        
    }
    
    fileprivate struct Contents: View {
        private var heading: String?
        private var description: String?
        private var extraContents: (any View)?
        private let action: String
        private let handler: (() -> Void)
        
        public init(
            heading: String? = nil,
            description: String? = nil,
            extraContents: (any View)? = nil,
            action: String,
            handler: @escaping () -> Void
        ) {
            self.heading = heading
            self.description = description
            self.extraContents = extraContents
            self.action = action
            self.handler = handler
        }
        
        var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: .zero) {
                    if let extraContents {
                        AnyView(extraContents)
                        Spacer()
                            .frame(width: 12)
                    }
                    ZStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: .zero) {
                            if let heading {
                                Text(heading)
                                    .montage(variant: .body2, weight: .bold, color: .staticWhite)
                                    .paragraph(variant: .body2)
                            }
                            if let description {
                                Text(description)
                                    .montage(variant: .label2, weight: .regular, color: .staticWhite)
                                    .paragraph(variant: .label2)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.vertical, 5)
                    }
                    Spacer()
                    Action(action, handler)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(
                BackgroundView()
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private struct Action: View {
        @State private var isPressed = false
        @State private var interaction: Decorate.Interaction.State = .normal
        
        private let action: String
        private let handler: (() -> Void)
        
        init(_ action: String, _ handler: @escaping () -> Void) {
            self.action = action
            self.handler = handler
        }
        
        var body: some View {
            Text(action)
                .montage(variant: .body2, weight: .bold, color: .staticWhite)
                .paragraph(variant: .body2)
                .background(
                    Decorate.InteractionController(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .backgroundNormal
                    )
                    .padding(.horizontal, -7)
                    .padding(.vertical, -4)
                )
                .onLongPressGesture(
                    minimumDuration: 2.0,
                    perform: {},
                    onPressingChanged: { state in
                        isPressed = state
                        if state == false {
                            handler()
                        }
                    }
                )
        }
    }
    
    private struct BackgroundView: View {
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            ZStack {
                SwiftUI.Color.alias(.inverseBackground).opacity(colorScheme == .light ? 0.5 : 0.46)
                SwiftUI.Color.alias(.primaryNormal).opacity(0.05)
            }
            .background(
                .ultraThinMaterial
            )
        }
    }
    
    public struct SnackBarModifier: ViewModifier {
        @Binding var model: SnackBar.Model?

        public func body(content: Content) -> some View {
            GeometryReader { proxy in
                content
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .overlay(
                        snackBar()
                            .onAppear {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                    )
            }
        }
        
        @ViewBuilder
        private func snackBar() -> some View {
            if let model {
                SnackBar(
                    heading: model.heading,
                    description: model.description,
                    extraContents: model.extraContents,
                    action: model.action,
                    handler: {
                        model.handler()
                        self.model = nil
                    }
                )
            }
        }
    }
}

struct SnackBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SnackBar(heading: "메시지에 마침표를 찍어요.", description: "설명은 필요할 때만 써요.", action: "텍스트") { }
            SnackBar(description: "메시지가 두 줄 이상 길어지는 경우 예외적으로 사용해요.", action: "텍스트") { }
            SnackBar(description: "메시지에 마침표를 찍어요.", extraContents: Image.montage(.android).resizable().frame(width: 32, height: 32), action: "텍스트") { }
            SnackBar(heading: "메시지에 마침표를 찍어요.", description: "설명은 필요할 때만 써요.", extraContents: Image.montage(.android).resizable().frame(width: 32, height: 32), action: "텍스트") { }
            SnackBar(heading: "흠", description: "흠 이게 몇줄까지되는걸까용가리어카메라이터보닥트리오리꽥꼬ㅒㄱ고양이는띠방", extraContents: Image.montage(.android).resizable().frame(width: 32, height: 32), action: "텍스트") { }
            
        }
    }
}
