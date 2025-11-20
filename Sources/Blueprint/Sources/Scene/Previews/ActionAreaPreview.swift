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
    @State private var showTransparentChecker: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Preview(variant: VariantKind.allCases[variantIndex], showTransparentChecker: $showTransparentChecker) {
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
            }
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    struct Preview: View {
        let variant: VariantKind
        @Binding var showTransparentChecker: Bool
        let variantOptionView: () -> any View
        @State private var mainToastModel: Toast.Model?
        @State private var subToastModel: Toast.Model?
        @State private var alternativeToastModel: Toast.Model?
        @State private var caption = false
        @State private var extra = false
        @State private var extraDivider = true
        @State private var gradientIndex = 0
        @State private var transparency = false
        
        private let mainTitle = "메인 액션"
        private let subTitle = "보조 액션"
        private let alternativeTitle = "대체 액션"
        private var mainAction: (() -> Void)  {
            {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                mainToastModel = .init(message: "메인 액션")
            }
        }
        
        private var subAction: (() -> Void)  {
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
        
        private var p: ActionArea.Variant {
            switch variant {
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
                        .fill(horizontal: true)
                    },
                    sub: .custom {
                        Button(
                            color: .primary,
                            text: "커스텀 서브"
                        )
                        .contentColor(.semantic(.accentBackgroundLime))
                        .fill(horizontal: true, vertical: false)
                    }
                )
            }
        }
        
        @State private var scrollStatus: Montage.ScrollView.ScrollStatus = .init()
        
        var body: some View {
            VStack(alignment: .leading, spacing: .zero) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Options").bold()
                    AnyView(variantOptionView())
                    HStack {
                        if variant.isStrongOrNeutral {
                            Text("caption")
                            Switch(checked: caption) { caption = $0 }
                        }
                        Text("extra")
                        Switch(checked: extra) { extra = $0 }
                        if extra {
                            Text("extraDivider")
                            Switch(checked: extraDivider) { extraDivider = $0 }
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
                        HStack {
                            Text("transparency")
                            Switch(checked: transparency) { transparency = $0 }
                        }
                    }
                }
                .padding([.bottom, .horizontal], 20)
                
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                .padding(.horizontal)
                ScrollView(scrollStatus: $scrollStatus) {
                    LazyVStack {
                        ForEach(0..<30, id: \.self) {
                            TextField(text: .constant("Item \($0)"))
                        }
                    }
                    .padding()
                }
                .actionArea(
                    variant: p,
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
            }
            .toast($mainToastModel)
            .toast($subToastModel)
            .toast($alternativeToastModel)
            .onChange(of: variant) { _ in
                caption = false
            }
            .onChange(of: extra) { _ in
                extraDivider = true
            }
        }
    }
}

#Preview {
    ActionAreaPreview()
}

