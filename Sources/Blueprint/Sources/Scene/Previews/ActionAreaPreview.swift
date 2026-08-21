//
//  ActionAreaPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/11/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct ActionAreaPreview: View {
    enum VariantKind: String, CaseIterable, Equatable {
        case strongOne
        case strongTwo
        case strongAll
        case neutralOne
        case neutralTwo
        case neutralAll
        case cancel
        case custom

        var selectableTitle: String {
            switch self {
            case .strongOne: "Strong(Main)"
            case .strongTwo: "Strong(Main / Sub)"
            case .strongAll: "Strong(Main / Sub / Alternative)"
            case .neutralOne: "Neutral(Main)"
            case .neutralTwo: "Neutral(Main / Sub)"
            case .neutralAll: "Neutral(Main / Sub / Alternative)"
            case .cancel: "Cancel"
            case .custom: "Custom(Strong Main / Sub)"
            }
        }

        var isStrongOrNeutral: Bool {
            selectableTitle.starts(with: "Strong") ||
            selectableTitle.starts(with: "Neutral") ||
            selectableTitle.starts(with: "Custom")
        }
    }

    @State private var variantIndex: Int = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true
    @State private var scrollSignalIndex = 0
    @State private var manualScrollReachedEnd = false
    @State private var customBackgroundColor = false
    @State private var backgroundColor: SwiftUI.Color = .semantic(.surfaceAccentVioletOpaque)
    @State private var captionIcon = false
    @State private var mainToastModel: Toast.Model?
    @State private var subToastModel: Toast.Model?
    @State private var alternativeToastModel: Toast.Model?

    private let mainTitle = "메인 액션"
    private let subTitle = "보조 액션"
    private let alternativeTitle = "대체 액션"
    private var mainAction: (() -> Void) {
        {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            mainToastModel = .init(message: "메인 액션")
        }
    }

    private var subAction: (() -> Void) {
        {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            subToastModel = .init(.cautionary, message: "보조 액션")
        }
    }

    private var alternativeAction: (() -> Void) {
        {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            alternativeToastModel = .init(.normal(.company, tint: .surfaceAccentVioletOpaque), message: "대체 액션")
        }
    }

    private var currentVariant: ActionArea.Variant {
        switch VariantKind.allCases[variantIndex] {
        case .strongOne:
            return .strong(main: .init(text: mainTitle, action: mainAction))
        case .strongTwo:
            return .strong(
                main: .init(text: mainTitle, action: mainAction),
                sub: .init(text: subTitle, action: subAction)
            )
        case .strongAll:
            return .strong(
                main: .init(text: mainTitle, action: mainAction),
                sub: .init(text: subTitle, action: subAction),
                alternative: .init(text: alternativeTitle, action: alternativeAction)
            )
        case .neutralOne:
            return .neutral(
                main: .init(text: mainTitle, action: mainAction)
            )
        case .neutralTwo:
            return .neutral(
                main: .init(text: mainTitle, action: mainAction),
                sub: .init(text: subTitle, action: subAction)
            )
        case .neutralAll:
            return .neutral(
                main: .init(text: mainTitle, action: mainAction),
                sub: .init(text: subTitle, action: subAction),
                alternative: .init(text: alternativeTitle, action: alternativeAction)
            )
        case .cancel:
            return .cancel(main: .init(text: mainTitle, action: mainAction))
        case .custom:
            return .strong(
                main: .custom {
                    Button(
                        variant: .outlined,
                        color: .primary,
                        text: "커스텀 메인"
                    )
                    .fillWidth()
                },
                sub: .custom {
                    Button(
                        color: .primary,
                        text: "커스텀 서브"
                    )
                    .contentColor(.semantic(.surfaceAccentLimeOpaque))
                    .fillWidth()
                }
            )
        }
    }

    /// `PreviewLayout`이 미리보기 영역에 주는 좌우 여백(`.padding(.horizontal)` 기본값).
    private let previewInset: CGFloat = 16

    /// ActionArea 뒤에 깔리는 페이지 바탕색.
    private var previewBackground: SwiftUI.Color {
        customBackgroundColor ? backgroundColor : .semantic(.backgroundNeutralPrimary)
    }

    var body: some View {
        PreviewLayout(mode: .upsideDown) {
            Montage.ScrollView {
                LazyVStack {
                    ForEach(0..<30, id: \.self) {
                        TextField(text: .constant("Item \($0)"))
                    }
                }
                // 아래에서 미리보기 전체를 화면 폭까지 넓히므로, 항목 자체의 좌우 여백은 여기서 되돌린다.
                // 하단 20은 ActionArea 그래디언트가 자기 경계 위로 덮는 만큼(offset -20)을 비워 준다.
                .padding(.horizontal, previewInset)
                .padding(.bottom, 20)
            }
            .actionArea(scrollReachedEnd: scrollSignalIndex == 0 ? nil : manualScrollReachedEnd) {
                ActionArea(variant: currentVariant)
                    .caption(caption ? "caption" : nil, icon: captionIcon ? .circleInfo : nil)
                    .extra({
                        if extra {
                            Rectangle().fill(SwiftUI.Color.semantic(.surfaceAccentVioletOpaque).opacity(0.08))
                                .frame(height: 50)
                        }
                    }, divider: extraDivider)
                    .backgroundColor(customBackgroundColor ? backgroundColor : nil)
            }
            // PreviewLayout이 미리보기에 좌우 여백을 주는데, ActionArea의 배경·그래디언트는 화면 폭을
            // 꽉 채워야 하므로 그만큼 되돌린다. (공용 컨테이너를 고치지 않고 이 프리뷰에서만 처리)
            .padding(.horizontal, -previewInset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } options: {
            MenuOptionRow("Variant: ", menuLabel: VariantKind.allCases[variantIndex].selectableTitle) {
                ForEach(VariantKind.allCases.indices, id: \.self) { v in
                    Button {
                        variantIndex = v
                    } label: {
                        Text(VariantKind.allCases[v].selectableTitle)
                    }
                }
            }
            // 토글 4개를 한 줄에 두면 라벨이 줄바꿈되므로 caption 쌍과 extra 쌍을 나눈다.
            if VariantKind.allCases[variantIndex].isStrongOrNeutral {
                HStack {
                    ToggleOption("caption", isOn: $caption)
                    if caption {
                        ToggleOption("captionIcon", isOn: $captionIcon)
                    }
                    Spacer(minLength: 0)
                }
            }
            HStack {
                ToggleOption("extra", isOn: $extra)
                if extra {
                    ToggleOption("extraDivider", isOn: $extraDivider)
                }
                Spacer(minLength: 0)
            }
            // Auto는 인자를 넘기지 않는 경로다. Montage.ScrollView가 하단 도달 여부를 스스로 올려 준다.
            SegmentedIndexRow("scroll signal", index: $scrollSignalIndex, labels: ["Auto", "Manual"])
            if scrollSignalIndex == 1 {
                ToggleOptionRow("scrollReachedEnd", isOn: $manualScrollReachedEnd)
            }
            ToggleOptionRow("backgroundColor", isOn: $customBackgroundColor)
            if customBackgroundColor {
                ColorPickerOptionRow("color", selection: $backgroundColor)
            }
        }
        // backgroundColor를 바꾸면 화면 바탕도 같이 칠한다. 그래디언트는 ActionArea 색에서 페이지
        // 색으로 넘어가는 구간이라, 바탕이 기본색이면 커스텀 색을 넣었을 때 경계만 도드라져
        // 실제 화면과 다르게 보인다.
        .backgroundColor(previewBackground)
        .toast($mainToastModel)
        .toast($subToastModel)
        .toast($alternativeToastModel)
        .onChange(of: variantIndex) { _ in
            // 캡션을 지원하지 않는 variant로 바뀔 때만 끈다. 지원 variant끼리 이동할 때
            // 초기화하면 켜 둔 캡션이 사라진다.
            if !VariantKind.allCases[variantIndex].isStrongOrNeutral {
                caption = false
            }
        }
        .onChange(of: caption) { _ in
            captionIcon = false
        }
        .onChange(of: extra) { _ in
            extraDivider = true
        }
    }
}

#Preview {
    ActionAreaPreview()
}
