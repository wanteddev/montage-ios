//
//  TextAreaPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/30/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct TextAreaPreview: View {
    enum Resize: String, CaseIterable {
        case normal
        case limit
        case fixed
        
        var description: String {
            self.rawValue.capitalized
        }
        
        var r: TextArea.Resize {
            switch self {
            case .normal: .normal
            case .limit: .limit
            case .fixed: .fixed(min: 100, max: 200)
            }
        }
    }
    
    var resources: [TextArea.Resource?] {
        [
            .none,
            .characterCount(limit: Int(limit), overflow: overflow),
            .textButton(
                title: "Text",
                handler: {}
            ),
            .iconButton(
                icon: .send,
                handler: {}
            ),
            .icon(
                .chevronDown
            ),
            .actionChip(
                title: "Action",
                handler: {}
            ),
            .filterChip(
                title: "Filter",
                handler: {}
            )
        ]
    }
    
    @State private var text: String = ""
    @State private var resize: Resize = .normal
    @State private var negative: Bool = false
    @State private var focus: Bool = false
    @FocusState private var focusState: Bool
    @State private var disable: Bool = false
    @State private var heading: Bool = false
    @State private var requiredBadge: Bool = false
    @State private var description: Bool = false
    @State private var placeholder: Bool = true
    @State private var leadingResourceIndex = 0
    @State private var trailingResourceIndex = 0
    @State private var limit: CGFloat = 10
    @State private var overflow: Bool = false
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                TextArea(text: $text, focus: $focusState)
                    .resize(resize.r)
                    .negative(negative)
                    .disable(disable)
                    .heading(heading ? "제목" : nil)
                    .requiredBadge(requiredBadge)
                    .bottomResources(
                        leading: [resources[leadingResourceIndex]].compactMap { $0 },
                        trailing: [resources[trailingResourceIndex]].compactMap { $0 }
                    )
                    .description(description ? "메세지에 마침표를 찍어요." : nil)
                    .placeholder(placeholder ? "텍스트를 입력해주세요" : nil)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Options").bold()
                    HStack {
                        HStack {
                            Text("Resize :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Menu(resize.description) {
                                ForEach(Resize.allCases, id: \.self) { r in
                                    Button {
                                        resize = r
                                    } label: {
                                        Text(r.description)
                                    }
                                }
                            }
                        }
                        HStack {
                            Text("Placeholder :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($placeholder)
                        }
                    }
                    HStack {
                        HStack {
                            Text("Focus :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($focus) {
                                focusState = $0
                            }
                        }
                        HStack {
                            Text("Disable :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($disable)
                        }
                    }
                    HStack {
                        HStack {
                            Text("Heading :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($heading)
                        }
                        HStack {
                            Text("RequiredBadge :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($requiredBadge)
                        }
                    }
                    HStack {
                        HStack {
                            Text("Description :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Switch($description)
                        }
                        Text("Negative :")
                            .montage(variant: .headline2, weight: .medium)
                        Spacer()
                        Switch($negative)
                    }
                    HStack {
                        HStack {
                            Text("Leading :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Menu(resources[leadingResourceIndex]?.description ?? "none") {
                                ForEach(resources.indices, id: \.self) { index in
                                    Button {
                                        leadingResourceIndex = index
                                    } label: {
                                        Text(resources[index]?.description ?? "none")
                                    }
                                }
                            }
                            .font(.montage(variant: .label1))
                        }
                        HStack {
                            Text("Trailing :")
                                .montage(variant: .headline2, weight: .medium)
                            Spacer()
                            Menu(resources[trailingResourceIndex]?.description ?? "none") {
                                ForEach(resources.indices, id: \.self) { index in
                                    Button {
                                        trailingResourceIndex = index
                                    } label: {
                                        Text(resources[index]?.description ?? "none")
                                    }
                                }
                            }
                            .font(.montage(variant: .label1))
                        }
                    }
                    if resources[leadingResourceIndex]?.isCharacterCount == true ||
                        resources[trailingResourceIndex]?.isCharacterCount == true
                    {
                        HStack {
                            Text("characterCount")
                                .layoutPriority(1)
                            Text("limit")
                            SwiftUI.Slider(value: $limit, in: 10...1000, step: 10)
                            Text("overflow")
                            Switch($overflow)
                        }
                    }
                }
            }
            .padding()
        }
        .onChange(of: focusState) {
            focus = $0
        }
        .onChange(of: resize) { _ in
            // resize 값이 바뀔 때 프리뷰에서 높이가 제대로 갱신되지 않아서 꼼수로 처리
            text = " "
            Task {
                text = ""
            }
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension TextArea.Resource {
    var isCharacterCount: Bool {
        if case .characterCount = self {
            return true
        } else {
            return false
        }
    }
}

extension TextArea.Resource: CaseDescribable {}

#Preview {
    TextAreaPreview()
}
