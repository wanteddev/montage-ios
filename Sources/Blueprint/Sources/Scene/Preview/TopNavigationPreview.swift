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
    enum Variant: String, CaseIterable {
        case normal
        case extended
        case floating
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
    }
    
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
    @State var variant: Variant = .normal
    @State var alternative: Bool = false
    @State var background: Bool = false
    @State var leading: LeadingContentsKind = .back
    @State var trailing: [TrailingButton] = []
    @State var trailingContentsDisable: Bool = false
    @State var toast: Toast.Model? = nil
    @State var backgroundColor: SwiftUI.Color? = nil
    @State var selectedBackgroundColorName: Montage.Color.Semantic = .backgroundNormal
    @State var actionArea = false
    @State var actionAreaSub = false
    @State var actionAreaAlt = false
    @State var actionAreaCaption = false
    @State var actionAreaExtra = false
    
    
    private var v: TopNavigation.Variant {
        switch variant {
        case .normal: return .normal
        case .extended: return .extended
        case .floating: return .floating(alternative: alternative, background: background)
        }
    }
    
    private var leadingContent: () -> any View {
        switch leading {
        case .back:
            return {
                IconButton(
                    variant: background
                    ? .background(size: 24, isAlternative: alternative)
                    : .default,
                    icon: background ? .chevronLeftThick : .chevronLeft
                ) {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 24, height: 24)
            }
        case .icon:
            return {
                IconButton(
                    variant: background
                    ? .background(size: 24, isAlternative: alternative)
                    : .default,
                    icon: .bell
                ) {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 24, height: 24)
            }
        case .text:
            return {
                if background {
                    SwiftUI.Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("텍스트")
                            .paragraph(
                                variant: .body2,
                                weight: .medium,
                                semantic: (alternative ? .staticWhite : .labelAlternative)
                            )
                            .if(alternative) {
                                $0.opacity(0.88)
                            } else: {
                                $0.blendMode(.plusDarker)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .modifying { original in
                                Group {
                                    if alternative {
                                        original.background(
                                            SwiftUI.Color.atomic(.coolNeutral30)
                                                .opacity(0.61)
                                        )
                                    } else {
                                        original.background(
                                            ZStack {
                                                SwiftUI.Color.semantic(.staticBlack)
                                                    .opacity(0.05)
                                                SwiftUI.Color.semantic(.staticWhite)
                                                    .opacity(0.35)
                                            }
                                        )
                                        .background(.thinMaterial)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 1000))
                            }
                    }
                } else {
                    TextButton(text: "텍스트") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .contentColor(.semantic(.labelNormal))
                    .fontVariant(.headline2)
                    .fontWeight(.regular)
                }
            }
        }
    }
    
    private var trailingContents: [() -> any View] {
        return trailing.map {
            switch $0 {
            case .icon: {
                TopNavigation.TrailingIconButton(
                    icon: .bell,
                    disable: trailingContentsDisable,
                    action: { closure() }
                )
            }
            case .text: {
                TopNavigation.TrailingTextButton(
                    text: "알림",
                    disable: trailingContentsDisable,
                    action: {
                        closure()
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
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
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
                    
                    VStack(spacing: 0) {
                        ForEach(0..<Color.Semantic.allCases.count, id: \.self) { index in
                            ZStack {
                                SwiftUI.Color.semantic(.allCases[index % Color.Semantic.allCases.count]).opacity(0.3)
                                Text("Item \(index)")
                                    .padding()
                            }
                        }
                    }
                }
                .padding()
            }
            .topNavigation(
                variant: v,
                title: {
                    TopNavigation.TitleView(
                        variant: v,
                        title: "제목"
                    )
                },
                backgroundColor: backgroundColor,
                leadingContent: leadingContent,
                trailingContents: trailingContents,
                withBottom: actionAreaModel
            )
            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Options").bold()
                    
                    HStack {
                        Text("Variant :")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Menu(variant.selectableTitle) {
                            ForEach(Variant.allCases, id: \.self) { v in
                                Button {
                                    variant = v
                                } label: {
                                    Text(v.selectableTitle)
                                }
                            }
                        }
                    }
                    if case .floating = variant {
                        HStack {
                            Text("Alternative :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Button {
                                alternative.toggle()
                            } label: {
                                Text(alternative ? "On" : "Off")
                            }
                        }
                        HStack {
                            Text("Background :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Button {
                                background.toggle()
                            } label: {
                                Text(background ? "On" : "Off")
                            }
                        }
                    }
                    HStack {
                        Text("LeadingContent :")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Menu(leading.selectableTitle) {
                            ForEach(LeadingContentsKind.allCases, id: \.self) { action in
                                Button {
                                    leading = action
                                } label: {
                                    Text(action.selectableTitle)
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Add TrailingContents : ")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Menu("추가") {
                            ForEach(TrailingButton.allCases, id: \.self) { action in
                                Button {
                                    trailing.append(action)
                                } label: {
                                    Text(action.selectableTitle)
                                }
                            }
                        }
                    }
                    HStack {
                        Text("TrailingContents Disable: ")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Button {
                            trailingContentsDisable.toggle()
                        } label: {
                            Text(trailingContentsDisable ? "true" : "false")
                        }
                    }
                    HStack {
                        Text("BackgroundColor: ")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Picker(
                            "BackgroundColor",
                            selection: $selectedBackgroundColorName,
                            content: {
                                ForEach(Color.Semantic.allCases, id: \.self) { color in
                                    Text(color.rawValue)
                                }
                            }
                        )
                        .pickerStyle(.menu)
                    }
                    HStack {
                        Text("ActionArea:")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Button {
                            actionArea.toggle()
                        } label: {
                            Text(actionArea ? "On" : "Off")
                        }
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
                .background(SwiftUI.Color.semantic(.backgroundElevated))
            }
        }
        .toast($toast)
        .navigationBarHidden(true)
        .onChange(
            of: selectedBackgroundColorName
        ) { color in
            backgroundColor = .semantic(color)
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    TopNavigationPreview()
}
