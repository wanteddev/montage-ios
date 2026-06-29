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

    enum Variant: String, CaseIterable, PreviewSegment {
        case normal
        case positive
        case negative
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
        
        var v: Montage.TextField.Status {
            switch self {
            case .normal: .normal
            case .positive: .positive
            case .negative: .negative
            }
        }
    }
    
    enum Content: String, CaseIterable, PreviewSegment {
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
                        variant: .normal(size: .custom(size: 8)),
                        icon: .send
                    )
                    .iconColor(.semantic(.labelAlternative))
                }
            }
        }
    }
    
    enum FieldSize: String, CaseIterable, PreviewSegment {
        case large
        case medium

        var selectableTitle: String {
            self.rawValue.capitalized
        }

        var s: Montage.TextField.Size {
            switch self {
            case .large: .large
            case .medium: .medium
            }
        }
    }

    @State private var text: String = ""
    @State private var fieldSize: FieldSize = .large
    @State private var variant: Variant = .normal
    @State private var disable: Bool = false
    @State private var icon: Bool = false
    @State private var placeholder: Bool = true
    @State private var trailingButton: Bool = false
    @State private var trailingContent: Content = .none
    @State private var usingSuggestions: Bool = false
    @State private var autoCompletionDataSource: Montage.TextField.AutoCompletionDataSource? = nil
    
    let candidates: [String] = [
        "aaa1", "bbb1", "ccc1", "ddd1", "eee1", "fff1", "ggg1", "hhh1", "iii1", "jjj1", "kkk1",
        "aaa2", "bbb2", "ccc2", "ddd2", "eee2", "fff2", "ggg2", "iii", "jjj"
    ]

    /// 현재 `text`와 `usingSuggestions` 상태를 기준으로 자동완성 데이터를 갱신한다.
    /// 텍스트 변경과 autoComplete 토글 양쪽에서 동일한 규칙으로 호출된다.
    private func refreshAutoCompletion() {
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

    var body: some View {
        PreviewLayout {
            Group {
                TextField(
                        text: $text,
                        autoCompletionDataSource: $autoCompletionDataSource
                    )
                    .size(fieldSize.s)
                    .status(variant.v)
                    .disable(disable)
                    .placeholder(placeholder ? "텍스트를 입력해 주세요." : nil)
                    .icon(icon ? .verifiedCheckFill : nil)
                    .trailingButton(
                        trailingButton ? TextField.TrailingButtonInfo(
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
                    .onChange(of: text) { _ in
                        refreshAutoCompletion()
                    }
                    // 텍스트 변경뿐 아니라 autoComplete 토글 시점에도 현재 텍스트 기준으로 즉시 동기화한다.
                    // (켜질 때 제안이 바로 뜨고, 꺼질 때 기존 제안이 남지 않도록)
                    .onChange(of: usingSuggestions) { _ in
                        refreshAutoCompletion()
                    }
            }
        } options: {
            SegmentedOptionRow("size", selection: $fieldSize)
            SegmentedOptionRow("status", selection: $variant)
            HStack {
                ToggleOption("placeholder", isOn: $placeholder)
                ToggleOption("icon", isOn: $icon)
            }
            HStack {
                ToggleOption("disable", isOn: $disable)
                ToggleOption("trailingButton", isOn: $trailingButton)
            }
            SegmentedOptionRow("trailingContent", selection: $trailingContent)
            HStack {
                ToggleOption("autoComplete", isOn: $usingSuggestions)
            }
            if usingSuggestions {
                Text("* 다음 목록 중 매칭되는 값들이 제안됩니다:\n  \(candidates.joined(separator: ", "))")
                    .foregroundStyle(SwiftUI.Color.secondary)
            }
        }
    }
}

#Preview {
    TextFieldPreview()
}
