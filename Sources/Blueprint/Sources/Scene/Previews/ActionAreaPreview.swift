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

    @State var variantIndex: Int = 0
    @State private var caption = false
    @State private var extra = false
    @State private var extraDivider = true
    @State private var gradientIndex = 0
    @State private var transparency = false
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
            alternativeToastModel = .init(.normal(.company, tint: .accentBackgroundViolet), message: "대체 액션")
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
                    .contentColor(.semantic(.accentBackgroundLime))
                    .fillWidth()
                }
            )
        }
    }

    @State private var scrollStatus: Montage.ScrollView.ScrollStatus = .init()

    var body: some View {
        PreviewLayout(mode: .overlay) {
            ScrollView(scrollStatus: $scrollStatus) {
                LazyVStack {
                    ForEach(0..<30, id: \.self) {
                        TextField(text: .constant("Item \($0)"))
                    }
                }
                .padding()
            }
            .actionArea(
                variant: currentVariant,
                backgroundTransparency: gradientIndex == 0 ? scrollStatus.scrolledToMax : transparency,
                caption: caption ? "caption" : nil,
                extra: {
                    if extra {
                        Rectangle().fill(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08))
                            .frame(height: 50)
                    }
                },
                extraDivider: extraDivider
            )
        } options: {
            HStack {
                Text("Variant: ")
                Menu(VariantKind.allCases[variantIndex].selectableTitle) {
                    ForEach(VariantKind.allCases.indices, id: \.self) { v in
                        Button {
                            variantIndex = v
                        } label: {
                            Text(VariantKind.allCases[v].selectableTitle)
                        }
                    }
                }
            }
            HStack {
                if VariantKind.allCases[variantIndex].isStrongOrNeutral {
                    ToggleOption("caption", isOn: $caption)
                }
                ToggleOption("extra", isOn: $extra)
                if extra {
                    ToggleOption("extraDivider", isOn: $extraDivider)
                }
            }
            HStack {
                Text("background Transparency")
                SegmentedControl(
                    selectedIndex: $gradientIndex,
                    labels: ["Scroll-synced", "Manually-controlled"]
                )
                .size(.small)
            }
            if gradientIndex == 1 {
                ToggleOptionRow("transparency", isOn: $transparency)
            }
        }
        .toast($mainToastModel)
        .toast($subToastModel)
        .toast($alternativeToastModel)
        .onChange(of: variantIndex) { _ in
            caption = false
        }
        .onChange(of: extra) { _ in
            extraDivider = true
        }
    }
}

#Preview {
    ActionAreaPreview()
}
