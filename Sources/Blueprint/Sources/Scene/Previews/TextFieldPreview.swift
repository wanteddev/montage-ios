//
//  TextFieldPreview.swift
//  Blueprint
//
//  Created by ahn sanghoon on 8/5/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct TextFieldPreview: View {
    
    enum Variant: String, CaseIterable {
        case normal
        case positive
        case negative
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
        
        var v: Montage.TextField.Status {
            switch self {
            case .normal: .normal()
            case .positive: .positive(description: "성공 메세지를 나타내요.")
            case .negative: .negative(description: "에러 메세지를 나타내요.")
            }
        }
    }
    
    enum Content: String, CaseIterable {
        case none
        case icon
        case text
        case timer
        case badge
        case iconButton
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
        
        var c: (() -> any View)? {
            switch self {
            case .none:
                return nil
            case .icon:
                return {
                    Image.icon(.logoApple)
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                }
            case .text:
                return {
                    Text("텍스트")
                        .paragraph(variant: .body1, weight: .medium, semantic: .labelAssistive)
                }
            case .timer:
                return {
                    let second = 431
                    return Text(String(format: "%02d:%02d", (second / 60), (second % 60)))
                        .paragraph(variant: .label1, weight: .bold, semantic: .primaryNormal)
                        .monospacedDigit()
                }
            case .badge:
                return {
                    ContentBadge(variant: .solid, text: "뱃지")
                        .size(.xsmall)
                        .colorStyle(.accent(.semantic(.statusPositive)))
                }
            case .iconButton:
                return {
                    IconButton(
                        variant: .normal(size: 8),
                        icon: .send
                    )
                    .iconColor(.semantic(.labelAlternative))
                }
            }
        }
    }
    
    @State private var showTransparentChecker: Bool = false
    @State private var text: String = ""
    @State private var variant: Variant = .normal
    @State private var disable: Bool = false
    @State private var heading: Bool = false
    @State private var requiredBadge: Bool = false
    @State private var icon: Bool = false
    @State private var description: Bool = false
    @State private var placeholder: Bool = true
    @State private var trailingButton: Bool = false
    @State private var trailingContent: Content = .none
    @State private var usingSuggestions: Bool = false
    @State private var autoCompletionDataSource: Montage.TextField.AutoCompletionDataSource? = nil
    
    let candidates: [String] = [
        "aaa1", "bbb1", "ccc1", "ddd1", "eee1", "fff1", "ggg1", "hhh1", "iii1", "jjj1", "kkk1",
        "aaa2", "bbb2", "ccc2", "ddd2", "eee2", "fff2", "ggg2", "iii", "jjj"
    ]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack {
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
                TextField(
                    text: $text,
                    autoCompletionDataSource: $autoCompletionDataSource
                )
                .status(variant.v)
                .disable(disable)
                .heading(heading ? "제목" : nil)
                .requiredBadge(requiredBadge)
                .placeholder(placeholder ? "텍스트를 입력해 주세요." : nil)
                .icon(icon ? .verifiedCheckFill : nil)
                .trailingButton(
                    trailingButton ? TextField.TrailingButtonInfo(
                        variant: .primary,
                        title: "텍스트",
                        handler: { print("trailing button tapped") }
                    ) : nil
                )
                .trailingContent {
                    if let content = trailingContent.c {
                        AnyView(content())
                    } else {
                        EmptyView()
                    }
                }
                .onChange(of: text) { text in
                    guard usingSuggestions else {
                        autoCompletionDataSource = nil
                        return
                    }
                    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else {
                        autoCompletionDataSource = nil
                        return
                    }
                    let suggestions = candidates
                        .filter { $0.lowercased().contains(trimmed.lowercased()) }
                    autoCompletionDataSource = .init(
                        numberOfSections: 2,
                        sectionTitleAt: { section in
                            "\(section+1)번째 섹션"
                        },
                        numberOfItemsInSection: { _ in
                            suggestions.count
                        },
                        cellForItemAt: { indexPath in
                            ListCell(title: suggestions[indexPath.row]) {
                                self.text = suggestions[indexPath.row]
                                Task {
                                    autoCompletionDataSource = nil
                                }
                            }
                            .highlight(trimmed)
                            .leadingContent {
                                Group {
                                    if indexPath.section == 0 {
                                        Image.icon(.search)
                                            .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                                    } else {
                                        Avatar("", variant: .company, size: .medium)
                                    }
                                }
                            }
                            .if(indexPath.section == 1) {
                                $0.caption("캡션")
                            }
                        },
                        headerView: {
                            ListCell(title: "'\(trimmed)' 사용하기") {
                                autoCompletionDataSource = nil
                            }
                            .highlight(trimmed)
                        },
                        footerView: {
                            ListCell(title: "'\(trimmed)' 사용하기") {
                                autoCompletionDataSource = nil
                            }
                            .highlight(trimmed)
                        },
                        maxHeight: 200
                    )
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Options").bold()
                    
                    HStack {
                        Text("Status")
                        Menu(variant.selectableTitle) {
                            ForEach(Variant.allCases, id: \.self) { v in
                                Button {
                                    variant = v
                                } label: {
                                    Text(v.selectableTitle)
                                }
                            }
                        }
                        Spacer()
                        HStack {
                            Text("Disable")
                            Control.switch(checked: disable) { disable = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Heading")
                            Control.switch(checked: heading) { heading = $0 }
                        }
                        Spacer()
                        HStack {
                            Text("RequiredBadge")
                            Control.switch(checked: requiredBadge) { requiredBadge = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Icon")
                            Control.switch(checked: icon) { icon = $0 }
                        }
                        Spacer()
                        HStack {
                            Text("Placeholder")
                            Control.switch(checked: placeholder) { placeholder = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("TrailingButton")
                            Control.switch(checked: trailingButton) { trailingButton = $0 }
                        }
                        Spacer()
                        Text("TrailingContent")
                        Menu(trailingContent.selectableTitle) {
                            ForEach(Content.allCases, id: \.self) { c in
                                Button {
                                    trailingContent = c
                                } label: {
                                    Text(c.selectableTitle)
                                }
                            }
                        }
                    }
                    HStack {
                        Text("AutoComplete")
                        Control.switch(checked: usingSuggestions) { usingSuggestions = $0 }
                    }
                    if usingSuggestions {
                        Text("* 다음 목록 중 매칭되는 값들이 제안됩니다:\n  \(candidates.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(SwiftUI.Color.secondary)
                    }
                }
            }
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

#Preview {
    TextFieldPreview()
}
