//
//  NormalSelect.swift
//  Montage
//
//  Created by ahn sanghoon on 8/9/24.
//

import SwiftUI

extension Select {
    /// 드롭다운(dropdown) 메뉴와 같이 옵션을 확인하고 고르는 용도로 사용합니다.
    public struct Normal: View {
        /// NormalSelect의 외관을 결정하는 열거형입니다.
        public enum Variant {
            case normal
            case negative
        }
        
        /// NormalSelect의 포커싱 여부입니다.
        /// 외부에서 포커싱 여부를 변경할 수 있습니다.
        @Binding var focus: Bool
        
        /// NormalSelect의 활성화(=값이 있는지) 여부입니다.
        @State private var active: Bool = true
        
        /// NormalSelect에 표시될 텍스트입니다.
        private let text: String
        
        /// NormalSelect의 외관입니다.
        private let variant: Variant
        
        /// NormalSelect의 텍스트가 없는 경우 나타낼 placeholder입니다.
        private let placeholder: String
        
        /// NormalSelect의 사용가능 여부입니다.
        private let disable: Bool
        
        /// NormalSelect의 제목입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let heading: String?
        
        /// NormalSelect의 필수 표시 노출 여부입니다.
        /// > 기본값은 false입니다.
        private let requiredBadge: Bool
        
        /// NormalSelect의 왼쪽 아이콘 입니다.
        /// > 기본값은 nil이며, 값이 없는 경우 노출되지 않습니다.
        private let icon: Icon?
        
        /// NormalSelect Tap에 대한 handler 입니다.
        private var onTap: (() -> Void)?

        public init(
            text: String,
            focus: Binding<Bool>,
            variant: Variant = .normal,
            placeholder: String,
            disable: Bool = false,
            heading: String? = nil,
            requiredBadge: Bool = false,
            icon: Icon? = nil,
            onTap: (() -> Void)? = nil
        ) {
            self.text = text
            self._focus = focus
            self.variant = variant
            self.placeholder = placeholder
            self.disable = disable
            self.heading = heading
            self.requiredBadge = requiredBadge
            self.icon = icon
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

        public var body: some View {
            VStack(alignment: .leading) {
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
                
                HStack(spacing: 8) {
                    if let icon {
                        ZStack {
                            Image.montage(icon)
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(.all, 1)
                                .foregroundStyle(disable ? SwiftUI.Color.alias(.labelDisable) :  SwiftUI.Color.alias(.labelAlternative))
                        }
                    }
                    
                    ZStack {
                        HStack {
                            if text.isEmpty {
                                Text(placeholder)
                                    .montage(
                                        variant: .body1,
                                        weight: .regular,
                                        alias: disable ? .labelDisable : .labelAlternative
                                    )
                                    .paragraph(variant: .body1)
                            } else {
                                Text(text)
                                    .montage(
                                        variant: .body1,
                                        weight: .regular,
                                        alias: disable ? .labelDisable :
                                                .labelNormal
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
                        iconColor: disable ? SwiftUI.Color.alias(.labelDisable) : .alias(.labelAlternative)
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
                        .inset(by: focus ? 2 : 1)
                        .stroke(strokeColor, lineWidth: focus ? 2 : 1)
                }
                .shadow(
                    color: .alias(.staticBlack).opacity(0.03),
                    radius: 2,
                    x: 0, y: 1
                )
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

struct NormalSelect_Preview: PreviewProvider {
    static var previews: some View {
        Select.Normal(
            text: "",
            focus: .constant(false),
            variant: .negative,
            placeholder: "선택해주세요.",
            disable: false,
            heading: "주제",
            requiredBadge: true,
            icon: nil
        )
    }
}
