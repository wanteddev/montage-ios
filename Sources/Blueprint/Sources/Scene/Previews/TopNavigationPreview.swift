//
//  TopNavigationPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/16/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct TopNavigationPreview: View {
    enum LeadingContentsKind: String, CaseIterable {
        case back
        case icon
        case text
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
    }
    
    enum TrailingButton: String, CaseIterable {
        case icon
        case text
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showTransparentChecker: Bool = false
    @State private var title = "제목"
    @State var variantIndex: Int = 0
    @State var leading = false
    @State var trailing: [TrailingButton] = []
    @State var toast: Toast.Model? = nil
    @State var backgroundColor: SwiftUI.Color = .semantic(.backgroundNormal)
    @State var actionArea = false
    @State var actionAreaSub = false
    @State var actionAreaAlt = false
    @State var actionAreaCaption = false
    @State var actionAreaExtra = false
    
    private var currentVariant: TopNavigation.Variant {
        let cases = TopNavigation.Variant.allCases
        return cases[min(max(0, variantIndex), cases.count - 1)]
    }
    
    private var isSearchVariant: Bool {
        currentVariant == .search
    }
    
    private var trailingContents: [() -> any View] {
        return trailing.map {
            switch $0 {
            case .icon: {
                TopNavigation.TrailingIconButton(
                    icon: .bell,
                    action: { closure() }
                )
            }
            case .text: {
                TopNavigation.TrailingTextButton(
                    text: isSearchVariant ? "취소" : "알림",
                    action: {
                        closure()
                        focused = false
                    }
                )
            }
            }
        }
    }
    
    private var actionAreaModel: ActionArea.Model? {
        if actionArea {
            .init(
                variant: .strong(
                    main: .init(text: "메인", action: {}),
                    sub: actionAreaSub ? .init(text: "서브", action: {}) : nil,
                    alternative: actionAreaAlt ? .init(text: "대체", action: {}) : nil
                ),
                caption: actionAreaCaption ? "캡션" : nil,
                extra: {
                    if actionAreaExtra {
                        Rectangle()
                            .foregroundStyle(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08))
                            .frame(height: 100)
                    }
                },
                extraDivider: true
            )
        } else {
            nil
        }
    }
    
    private var closure: () -> Void {
        {
            toast = .init(message: "알림센터로 갑시다")
        }
    }
    
    @State private var term = ""
    @State private var focused = false
    @State private var showPreview = true
    
    var body: some View {
        SwiftUI.Button("TopNavigation Preview") {
            showPreview = true
        }
        .fullScreenCover(isPresented: $showPreview) {
            VStack(spacing: 0) {
                VStack(alignment: .leading) {
                    ForEach(0..<Color.Semantic.allCases.count, id: \.self) { index in
                        ZStack {
                            SwiftUI.Color.semantic(.allCases[index]).opacity(0.3)
                            Text("Item \(index)")
                                .padding()
                        }
                    }
                }
                .padding(.horizontal)
                .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
                .topNavigation(
                    variant: currentVariant,
                    title: title,
                    backgroundColor: backgroundColor,
                    leadingContent: leading ? {
                        IconButton(
                            variant: .default,
                            icon: .chevronLeft
                        ) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(width: 24, height: 24)
                    } : nil,
                    trailingContents: trailingContents,
                    withBottom: actionAreaModel,
                    searchPlaceholder: "검색하세요",
                    searchTerm: $term,
                    searchFocused: $focused
                ) {
                    print("\(term) 검색됨")
                }
                .onChange(of: focused) { newValue in
                    if isSearchVariant {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            trailing = newValue ? [.text] : []
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Options").bold()
                        Spacer()
                        Button(action: {
                            showPreview = false
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image.icon(.flipBackward).foregroundColor(.semantic(.primaryNormal))
                        }
                        Button(action: {
                            showTransparentChecker.toggle()
                        }) {
                            Image(systemName: "checkerboard.rectangle")
                                .foregroundColor(.semantic(.primaryNormal))
                        }
                    }
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: TopNavigation.Variant.allCases.map(\.description))
                            .size(.small)
                    }
                    HStack {
                        Text("title")
                        TextField(text: $title)
                    }
                    HStack {
                        Text("leadingContent")
                        Control.switch(checked: leading) { leading = $0 }
                    }
                    HStack {
                        Text("trailingContents")
                        Button(variant: .outlined, size: .small, text: "TextButton") {
                            trailing.append(.text)
                        }
                        Button(variant: .outlined, size: .small, text: "IconButton") {
                            trailing.append(.icon)
                        }
                        IconButton(variant: .outlined(size: .small), icon: .reset) {
                            trailing = []
                        }
                    }
                    HStack {
                        ColorPicker(
                            "backgroundColor",
                            selection: $backgroundColor
                        )
                    }
                    HStack {
                        Text("actionArea")
                        Control.switch(checked: actionArea) { actionArea = $0 }
                    }
                    if actionArea {
                        HStack {
                            Text("sub")
                            Control.switch(checked: actionAreaSub) { actionAreaSub = $0 }
                            Text("alt")
                            Control.switch(checked: actionAreaAlt) { actionAreaAlt = $0 }
                            Text("caption")
                            Control.switch(checked: actionAreaCaption) { actionAreaCaption = $0 }
                            Text("extra")
                            Control.switch(checked: actionAreaExtra) { actionAreaExtra = $0 }
                        }
                    }
                }
                .padding()
                .background(.regularMaterial)
            }
            .toast($toast)
        }
    }
}

extension TopNavigation.Variant: @retroactive CaseIterable, CaseDescribable {
    public static var allCases: [TopNavigation.Variant] {
        [.normal, .display, .search, .floating]
    }
}

#Preview {
    TopNavigationPreview()
}
