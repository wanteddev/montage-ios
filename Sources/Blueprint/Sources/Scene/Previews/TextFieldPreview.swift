//
//  TextFieldPreview.swift
//  Blueprint
//
//  Created by ahn sanghoon on 8/5/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

/// SegmentedControl로 선택 가능한 Preview 옵션 enum을 위한 공통 프로토콜.
private protocol PreviewSegment: CaseIterable, Equatable {
    var selectableTitle: String { get }
}

struct TextFieldPreview: View {

    enum Variant: String, CaseIterable, PreviewSegment {
        case normal
        case positive
        case negative
        
        var selectableTitle: String {
            self.rawValue.capitalized
        }
        
        func v(description: Bool) -> Montage.TextField.Status {
            switch self {
            case .normal: .normal(description: description ? "설명 메세지를 나타내요." : "")
            case .positive: .positive(description: description ? "성공 메세지를 나타내요." : "")
            case .negative: .negative(description: description ? "에러 메세지를 나타내요." : "")
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

    @State private var showTransparentChecker: Bool = false
    @State private var text: String = ""
    @State private var fieldSize: FieldSize = .large
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

    /// 제목과 SegmentedControl을 묶은 옵션 행을 구성한다.
    @ViewBuilder
    private func optionRow<Option: PreviewSegment>(_ title: String, _ selection: Binding<Option>) -> some View {
        let all = Array(Option.allCases)
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
            SegmentedControl(
                selectedIndex: Binding(
                    get: { all.firstIndex(of: selection.wrappedValue) ?? 0 },
                    set: { selection.wrappedValue = all[$0] }
                ),
                labels: all.map(\.selectableTitle)
            )
            .size(.small)
        }
    }

    /// 제목과 Switch를 묶은 토글 행을 구성한다.
    private func toggleRow(_ title: String, _ isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
            Switch(checked: isOn.wrappedValue) { isOn.wrappedValue = $0 }
            Spacer()
        }
    }

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
                .size(fieldSize.s)
                .status(variant.v(description: description))
                .disable(disable)
                .heading(heading ? "제목" : nil)
                .requiredBadge(requiredBadge)
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
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Options").bold()

                    // 필드 외형
                    optionRow("Size", $fieldSize)
                    optionRow("Status", $variant)

                    Divider()

                    // 필드 콘텐츠/상태 토글
                    toggleRow("Placeholder", $placeholder)
                    toggleRow("Icon", $icon)
                    toggleRow("Disable", $disable)
                    toggleRow("Heading", $heading)
                    if heading {
                        // RequiredBadge는 Heading이 있을 때만 표시된다.
                        toggleRow("RequiredBadge", $requiredBadge)
                            .padding(.leading, 16)
                    }
                    toggleRow("Description", $description)

                    Divider()

                    // 트레일링 영역
                    toggleRow("TrailingButton", $trailingButton)
                    optionRow("Trailing Content", $trailingContent)

                    Divider()

                    // 자동완성
                    toggleRow("AutoComplete", $usingSuggestions)
                    if usingSuggestions {
                        Text("* 다음 목록 중 매칭되는 값들이 제안됩니다:\n  \(candidates.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(SwiftUI.Color.secondary)
                    }
                }
            }
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 201, checkerColor: .red)
    }
}

#Preview {
    TextFieldPreview()
}
