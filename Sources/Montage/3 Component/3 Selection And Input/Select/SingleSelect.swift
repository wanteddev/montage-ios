//
//  SingleSelect.swift
//  Montage
//
//  Created by ahn sanghoon on 8/9/24.
//

import SwiftUI

extension Select {
    /// 드롭다운(dropdown) 메뉴와 같이 옵션을 확인하고 고르는 용도로 사용합니다.
    public struct Single: View {
        /// SingleSelect의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case normal
            case negative
        }
        
        /// SingleSelect의 포커싱 여부입니다.
        /// 외부에서 포커싱 여부를 변경할 수 있습니다.
        @Binding var focus: Bool
        
        /// SingleSelect의 활성화(=값이 있는지) 여부입니다.
        @State private var active = true
        
        /// SingleSelect의 텍스트와 외곽선을 포함하는 영역의 사이즈입니다.
        @State private var contentSize: CGSize = .zero
        
        /// SingleSelect에 표시될 텍스트입니다.
        private let text: String
        
        /// SingleSelect의 외관입니다.
        private let variant: Variant
        
        /// SingleSelect의 텍스트가 없는 경우 나타낼 placeholder입니다.
        private let placeholder: String
        
        /// SingleSelect의 사용가능 여부입니다.
        private let disable: Bool
        
        /// SingleSelect의 제목입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let heading: String?
        
        /// SingleSelect의 필수 표시 노출 여부입니다.
        /// > 기본값은 false입니다.
        private let requiredBadge: Bool
        
        /// SingleSelect의 설명입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let description: String?
        
        /// SingleSelect의 왼쪽 컨텐츠입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private var leftContent: (() -> any View)?
        
        /// SingleSelect의 shadow 배경색입니다.
        /// > 기본값은 systemBackgroundColor 입니다.
        /// >
        /// > shadow 배경색 변경이 필요할때 사용합니다.
        private let shadowBackgroundColor: SwiftUI.Color
        
        /// SingleSelect Tap에 대한 handler 입니다.
        private var onTap: (() -> Void)?

        public init(
            text: String,
            focus: Binding<Bool>,
            variant: Variant = .normal,
            placeholder: String,
            disable: Bool = false,
            heading: String? = nil,
            requiredBadge: Bool = false,
            description: String? = nil,
            leftContent: (() -> any View)? = nil,
            backgroundColor: SwiftUI.Color = .init(uiColor: UIColor.systemBackground),
            onTap: (() -> Void)? = nil
        ) {
            self.text = text
            _focus = focus
            self.variant = variant
            self.placeholder = placeholder
            self.disable = disable
            self.heading = heading
            self.requiredBadge = requiredBadge
            self.description = description
            self.leftContent = leftContent
            shadowBackgroundColor = backgroundColor
            self.onTap = onTap
        }

        private var strokeColor: SwiftUI.Color {
            if disable == false {
                if variant == .normal {
                    focus ? .alias(.primaryNormal).opacity(0.43) : .alias(.lineNeutral)
                } else {
                    .alias(.statusNegative).opacity(0.28)
                }
            } else {
                .alias(.lineNeutral)
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
                        .frame(width: contentSize.width, height: contentSize.height)
                    
                    HStack(spacing: 8) {
                        if let leftContent {
                            AnyView(leftContent())
                        }
                        
                        ZStack {
                            HStack {
                                if text.isEmpty {
                                    Text(placeholder)
                                        .montage(
                                            variant: .body1,
                                            weight: .regular,
                                            color: placeholderTextColor
                                        )
                                        .paragraph(variant: .body1)
                                } else {
                                    Text(text)
                                        .montage(
                                            variant: .body1,
                                            weight: .regular,
                                            color: textColor
                                        )
                                        .paragraph(variant: .body1)
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
                        .padding(.trailing, 4)
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
                }
                .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
                
                if let description {
                    Text(description)
                        .montage(
                            variant: .caption1,
                            weight: .regular,
                            alias: .labelAlternative
                        )
                }
            }
            .onChange(of: text, perform: { newValue in
                active = (newValue.isEmpty == false)
            })
            .allowsHitTesting(disable == false)
            .onTapGesture {
                onTap?()
            }
        }
    }
}

struct SingleSelect_Preview: PreviewProvider {
    static var previews: some View {
        Select.Single(
            text: "",
            focus: .constant(false),
            variant: .negative,
            placeholder: "선택해주세요.",
            disable: false,
            heading: "주제",
            requiredBadge: true,
            description: "메세지에 마침표를 찍어요.",
            leftContent: nil
        )
    }
}
