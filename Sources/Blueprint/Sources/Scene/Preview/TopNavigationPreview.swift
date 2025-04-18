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
    
    enum LeadingButton: String, CaseIterable {
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
    
    @State var variant: Variant = .normal
    @State var alternative: Bool = false
    @State var background: Bool = false
    @State var leading: LeadingButton = .back
    @State var trailing: [TrailingButton] = []
    @State var trailingButtonDisable: Bool = false
    @State var toast: Toast.Model? = nil
    @State var backgroundColor: ColorResolvable? = nil
    @State var selectedBackgroundColorName: Montage.Color.Semantic = .backgroundNormal
    @State var actionArea = false
    @State var actionAreaSub = false
    @State var actionAreaAlt = false
    @State var actionAreaCaption = false
    @State var actionAreaExtra = false
    
    
    private var v: Bar.TopNavigation.Variant {
        switch variant {
        case .normal: return .normal
        case .extended: return .extended
        case .floating: return .floating(alternative: alternative, background: background)
        }
    }
    
    private var leadingButton: Bar.TopNavigation.Resource.LeadingButton {
        switch leading {
        case .back: return .back(action: { presentationMode.wrappedValue.dismiss() })
        case .icon: return .icon(.arrowLeft, action: { presentationMode.wrappedValue.dismiss()})
        case .text: return .text("뒤로", action: { presentationMode.wrappedValue.dismiss()})
        }
    }
    
    private var trailingButton: [Bar.TopNavigation.Resource.TrailingButton] {
        return trailing.map {
            switch $0 {
            case .icon: return .icon(.bell, disable: trailingButtonDisable, action: { closure() })
            case .text: return .text("알림", disable: trailingButtonDisable, action: { closure() })
            }
        }
    }
    
    private var actionAreaModel: ActionAreaModifier.Model? {
        if actionArea {
            .init(
                variant: .strong(
                    main: .init(text: "메인", action: {}),
                    sub: actionAreaSub ? .init(text: "서브", action: {}) : nil,
                    alternative: actionAreaAlt ? .init(text: "대체", action: {}) : nil
                ),
                caption: actionAreaCaption ? "캡션" : nil,
                extra: actionAreaExtra ? {
                    Rectangle()
                        .foregroundStyle(SwiftUI.Color.semantic(.accentBackgroundViolet).opacity(0.08))
                        .frame(height: 100)
                } : nil,
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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Varint :")
                    .montage(variant: .headline2, weight: .medium)
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
                        .montage(variant: .headline2, weight: .medium)
                    Spacer()
                    Button {
                        alternative.toggle()
                    } label: {
                        Text(alternative ? "On" : "Off")
                    }
                }
                HStack {
                    Text("Background :")
                        .montage(variant: .headline2, weight: .medium)
                    Spacer()
                    Button {
                        background.toggle()
                    } label: {
                        Text(background ? "On" : "Off")
                    }
                }
            }
            HStack {
                Text("LeadingButton :")
                    .montage(variant: .headline2, weight: .medium)
                Spacer()
                Menu(leading.selectableTitle) {
                    ForEach(LeadingButton.allCases, id: \.self) { action in
                        Button {
                            leading = action
                        } label: {
                            Text(action.selectableTitle)
                        }
                    }
                }
            }
            HStack {
                Text("Add TrailingButton: ")
                    .montage(variant: .headline2, weight: .medium)
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
                Text("TrailingButton Disable: ")
                    .montage(variant: .headline2, weight: .medium)
                Spacer()
                Button {
                    trailingButtonDisable.toggle()
                } label: {
                    Text(trailingButtonDisable ? "true" : "false")
                }
            }
            HStack {
                Text("BackgroundColor: ")
                    .montage(variant: .headline2, weight: .medium)
                Spacer()
                Picker(
                    "BackgroundColor",
                    selection: $selectedBackgroundColorName,
                    content: {
                        ForEach(Color.Semantic.allCases, id: \.self) { color in
                            Text(color.name)
                        }
                    }
                )
                .pickerStyle(.menu)
            }
            HStack {
                Text("ActionArea:")
                    .montage(variant: .headline2, weight: .medium)
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
                    Control.Switch($actionAreaSub)
                    Text("alt")
                    Control.Switch($actionAreaAlt)
                    Text("caption")
                    Control.Switch($actionAreaCaption)
                    Text("extra")
                    Control.Switch($actionAreaExtra)
                }
            }
            VStack(spacing: 0) {
                ForEach(0..<Color.Semantic.allCases.count*2, id: \.self) { index in
                    ZStack {
                        SwiftUI.Color.semantic(.allCases[index % Color.Semantic.allCases.count]).opacity(0.3)
                        Text("Item \(index)")
                            .padding()
                    }
                }
            }
        }
        .padding(.all, 20)
        .topNavigation(
            variant: v,
            title: "제목",
            backgroundColorResolvable: backgroundColor,
            leadingButton: leadingButton,
            trailingButtons: trailingButton,
            withBottom: actionAreaModel
        )
        .toast($toast)
        .navigationBarHidden(true)
        .onChange(
            of: selectedBackgroundColorName
        ) { color in
            backgroundColor = color
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    TopNavigationPreview()
}
