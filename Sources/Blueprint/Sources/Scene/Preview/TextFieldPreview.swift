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
            case .normal: .normal(description: "메세지에 마침표를 찍어요.")
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
                    Image.montage(.logoApple)
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(SwiftUI.Color.semantic(.labelAlternative))
                }
            case .text:
                return {
                    Text("텍스트")
                        .montage(variant: .body1, weight: .medium, semantic: .labelAssistive)
                        .paragraph(variant: .body1)
                }
            case .timer:
                return {
                    let second = 431
                    return Text(String(format: "%02d:%02d", (second / 60), (second % 60)))
                        .montage(variant: .label1, weight: .bold, semantic: .primaryNormal)
                        .paragraph(variant: .label1)
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
                .trailingContent(trailingContent.c)
                .onChange(of: text) { text in
                    if usingSuggestions {
                        let suggestions = candidates
                            .filter { $0.lowercased().contains(text.lowercased()) }
                        autoCompletionDataSource = .init(
                            numberOfSections: 2,
                            sectionTitleAt: { section in
                                "\(section+1)번째 섹션"
                            },
                            numberOfItemsInSection: { _ in
                                suggestions.count
                            },
                            cellForItemAt: { indexPath in
                                Cell(title: suggestions[indexPath.row]) {
                                    self.text = suggestions[indexPath.row]
                                    Task {
                                        autoCompletionDataSource = nil
                                    }
                                }
                                .highlight(text)
                                .leadingContent {
                                    Group {
                                        if indexPath.section == 0 {
                                            Image.montage(.search)
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
                                Cell(title: "'\(text)' 사용하기") {
                                    autoCompletionDataSource = nil
                                }
                                .highlight(text)
                            },
                            footerView: {
                                Cell(title: "'\(text)' 사용하기") {
                                    autoCompletionDataSource = nil
                                }
                                .highlight(text)
                            },
                            maxHeight: 200
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Options").bold()
                    
                    HStack {
                        Text("Status :")
                            .montage(variant: .headline2, weight: .medium)
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
                            Text("Disable :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                disable.toggle()
                            } label: {
                                Text(disable ? "On" : "Off")
                            }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Heading :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                heading.toggle()
                            } label: {
                                Text(heading ? "On" : "Off")
                            }
                        }
                        Spacer()
                        HStack {
                            Text("RequiredBadge :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                requiredBadge.toggle()
                            } label: {
                                Text(requiredBadge ? "On" : "Off")
                            }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Icon :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                icon.toggle()
                            } label: {
                                Text(icon ? "On" : "Off")
                            }
                        }
                        Spacer()
                        HStack {
                            Text("Placeholder :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                placeholder.toggle()
                            } label: {
                                Text(placeholder ? "On" : "Off")
                            }
                        }
                    }
                    HStack {
                        HStack {
                            Text("TrailingButton :")
                                .montage(variant: .headline2, weight: .medium)
                            Button {
                                trailingButton.toggle()
                            } label: {
                                Text(trailingButton ? "On" : "Off")
                            }
                        }
                        Spacer()
                        Text("TrailingContent :")
                            .montage(variant: .headline2, weight: .medium)
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
                        Text("AutoComplete :")
                            .montage(variant: .headline2, weight: .medium)
                        Button {
                            usingSuggestions.toggle()
                        } label: {
                            Text(usingSuggestions ? "On" : "Off")
                        }
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
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    TextFieldPreview()
}
