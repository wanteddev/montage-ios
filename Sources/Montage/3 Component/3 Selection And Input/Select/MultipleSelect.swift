//
//  MultipleSelect.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/12/24.
//

import SwiftUI

extension Select {
    /// 드롭다운(dropdown) 메뉴와 같이 여러 옵션 중 하나를 확인하고 고르는 용도로 사용합니다.
    public struct Multiple: View {
        public struct Item: Identifiable, Equatable {
            public enum State {
                case normal
                case negative
            }
            
            public var id: String { text }
            public let state: State
            public let text: String
            public var icon: Icon?
            
            public init(
                state: State = .normal,
                text: String,
                icon: Icon? = nil
            ) {
                self.state = state
                self.text = text
                self.icon = icon
            }
        }
        
        /// MultipleSelect에 표시될 내용의 형태를 결정하는 열거형입니다.
        public enum Render {
            case normal
            case chip
        }
        
        /// MultipleSelect의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case normal
            case negative
        }
        
        /// MultipleSelect의 포커싱 여부입니다.
        /// 외부에서 포커싱 여부를 변경할 수 있습니다.
        @Binding var focus: Bool
        
        /// MultipleSelect의 활성화(=값이 있는지) 여부입니다.
        @State private var active = true

        /// MultipleSelect의 텍스트와 외곽선을 포함하는 영역의 사이즈입니다.
        @State private var contentSize: CGSize = .zero
        
        /// MultipleSelect의 표시될 내용의 형태입니다.
        private let render: Render
        
        /// MultipleSelect에 표시될 내용들입니다.
        private let items: [Item]
        
        /// MultipleSelect의 외관입니다.
        private let variant: Variant
        
        /// MultipleSelect의 텍스트가 없는 경우 나타낼 placeholder입니다.
        private let placeholder: String
        
        /// MultipleSelect의 사용가능 여부입니다.
        private let disable: Bool
        
        /// MultipleSelect의 제목입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let heading: String?
        
        /// MultipleSelect의 필수 표시 노출 여부입니다.
        /// > 기본값은 false입니다.
        private let requiredBadge: Bool
        
        /// MultipleSelect의 설명입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let description: String?
        
        /// MultipleSelect의 shadow 배경색입니다.
        /// > 기본값은 systemBackgroundColor 입니다.
        /// >
        /// > shadow 배경색 변경이 필요할때 사용합니다.
        private let shadowBackgroundColor: SwiftUI.Color

        /// MultipleSelect의 왼쪽 컨텐츠입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private var leftContent: (() -> any View)?
        
        /// MultipleSelect의 chip item을 터치했을 때의 handler 입니다.
        /// > render가 normal인 경우에는 동작하지 않습니다.
        private var onTapItem: ((Select.Multiple.Item) -> Void)?
        
        /// MultipleSelect의 Tap에 대한 handler 입니다.
        private var onTap: (() -> Void)?
        
        public init(
            items: [Item] = [],
            focus: Binding<Bool>,
            render: Render = .normal,
            variant: Variant = .normal,
            placeholder: String,
            disable: Bool = false,
            heading: String? = nil,
            requiredBadge: Bool = false,
            description: String? = nil,
            backgroundColor: SwiftUI.Color = .init(uiColor: UIColor.systemBackground),
            leftContent: (() -> any View)? = nil,
            onTapItem: ((Select.Multiple.Item) -> Void)? = nil,
            onTap: (() -> Void)? = nil
        ) {
            self.items = items
            _focus = focus
            self.render = render
            self.variant = variant
            self.placeholder = placeholder
            self.disable = disable
            self.heading = heading
            self.requiredBadge = requiredBadge
            self.description = description
            shadowBackgroundColor = backgroundColor
            self.leftContent = leftContent
            self.onTapItem = onTapItem
            self.onTap = onTap
        }

        private var strokeColor: SwiftUI.Color {
            if disable {
                .alias(.lineNeutral)
            } else {
                if variant == .normal {
                    focus ? .alias(.primaryNormal).opacity(0.43) : .alias(.lineNeutral)
                } else {
                    .alias(.statusNegative).opacity(0.28)
                }
            }
        }
        
        private var placeholderTextColor: SwiftUI.Color {
            disable ? .alias(.labelDisable) : .alias(.labelAssistive)
        }
        
        private var textColor: SwiftUI.Color {
            disable ? .alias(.labelAlternative) : .alias(.labelNormal)
        }

        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let heading {
                    HStack(spacing: 4) {
                        Text(heading)
                            .montage(
                                variant: .label1,
                                weight: .bold,
                                alias: .labelNormal
                            )
                        if requiredBadge {
                            Text("*")
                                .montage(
                                    variant: .label1,
                                    weight: .medium,
                                    alias: .statusNegative
                                )
                        }
                    }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(shadowBackgroundColor)
                        .shadow(
                            color: .alias(.staticBlack).opacity(0.03),
                            radius: 2,
                            x: 0,
                            y: 1
                        )
                        .frame(
                            width: contentSize.width,
                            height: contentSize.height
                        )

                    HStack(spacing: 8) {
                        if let leftContent {
                            AnyView(leftContent())
                        }
                        
                        ZStack {
                            HStack {
                                if items.isEmpty {
                                    Text(placeholder)
                                        .montage(
                                            variant: .body1,
                                            weight: .regular,
                                            color: placeholderTextColor
                                        )
                                        .paragraph(variant: .body1)
                                } else {
                                    if render == .normal {
                                        Text(items.map { $0.text }.joined(separator: ", "))
                                            .montage(
                                                variant: .body1,
                                                weight: .regular,
                                                color: textColor
                                            )
                                            .paragraph(variant: .body1)
                                    } else {
                                        Chip(
                                            items: items,
                                            disable: disable,
                                            onTapItem: onTapItem
                                        )
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                            .contentShape(Rectangle())
                        }
                        
                        if active, variant == .negative {
                            Image.montage(.circleExclamationFill)
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(SwiftUI.Color.alias(.statusNegative))
                        }
                        
                        Button.IconButton(
                            variant: .normal(size: 16),
                            icon: .chevronDownThickSmall,
                            iconColor: disable ? SwiftUI.Color
                                .alias(.labelDisable) : .alias(.labelAlternative)
                        ) {
                            onTap?()
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(.all, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(disable ? SwiftUI.Color.alias(.interactionDisable) : .clear)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: 0.5)
                            .stroke(strokeColor, lineWidth: focus ? 2 : 1)
                    }
                    .shadow(
                        color: .alias(.staticBlack).opacity(0.03),
                        radius: 2,
                        x: 0,
                        y: 1
                    )
                }
                
                if let description {
                    Text(description)
                        .montage(
                            variant: .caption1,
                            weight: .regular,
                            alias: .labelAlternative
                        )
                }
            }
            .onChange(of: items, perform: { newValue in
                active = (newValue.isEmpty == false)
            })
            .allowsHitTesting(disable == false)
            .onTapGesture {
                onTap?()
            }
        }
        
        private struct Chip: View {
            var items: [Select.Multiple.Item]
            var disable: Bool
            var onTapItem: ((Select.Multiple.Item) -> Void)?

            var body: some View {
                HStack {
                    ForEach(Array(items.indices), id: \.self) {
                        let item = items[$0]
                        Montage.Chip.Action(
                            variant: .solid,
                            size: .xsmall,
                            text: item.text,
                            backgroundColor: backgroundColor(item),
                            fontColor: fontColor(item)
                        )
                        .imageColor(iconColor(item))
                        .rightImage(Image.montage(.closeThick))
                        .if(item.icon != nil) {
                            $0.leftImage(Image.montage(item.icon!))
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onTapItem?(item)
                        }
                    }
                }
            }

            private func iconColor(_ item: Select.Multiple.Item) -> SwiftUI.Color {
                guard disable == false else { return .alias(.labelDisable) }
                switch item.state {
                case .normal:
                    return .alias(.labelAlternative)
                case .negative:
                    return .alias(.statusNegative)
                }
            }

            private func backgroundColor(_ item: Select.Multiple.Item) -> SwiftUI.Color? {
                guard disable == false else { return nil }
                switch item.state {
                case .normal:
                    return nil
                case .negative:
                    return .alias(.statusNegative).opacity(0.05)
                }
            }

            private func fontColor(_ item: Select.Multiple.Item) -> SwiftUI.Color {
                guard disable == false else { return .alias(.labelDisable) }
                switch item.state {
                case .normal:
                    return .alias(.labelNormal)
                case .negative:
                    return .alias(.statusNegative)
                }
            }
        }
    }
}

struct MultipleSelect_Preview: PreviewProvider {
    static var previews: some View {
        Select.Multiple(
            items: [
                .init(state: .normal, text: "텍스트", icon: nil),
                .init(state: .negative, text: "텍스트", icon: nil),
                .init(state: .normal, text: "텍스트", icon: .apps),
            ],
            focus: .constant(false),
            render: .chip,
            variant: .normal,
            placeholder: "선택해주세요.",
            disable: false,
            heading: "제목",
            requiredBadge: true,
            description: "메세지에 마침표를 찍어요.",
            leftContent: nil,
            onTapItem: { _ in print("아이템 터치") },
            onTap: {
                print("컴포넌트 터치")
            }
        )
    }
}
