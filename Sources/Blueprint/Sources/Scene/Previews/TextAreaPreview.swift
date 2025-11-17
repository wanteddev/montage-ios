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
            .chip(
                title: "Action",
                handler: {}
            ),
            .filterButton(
                title: "Filter",
                handler: {}
            )
        ]
    }
    
    @State private var showTransparentChecker: Bool = false
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
    @State private var leadingResources = [TextArea.Resource]()
    @State private var trailingResources = [TextArea.Resource]()
    @State private var limit: CGFloat = 10
    @State private var overflow: Bool = false
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(spacing: 12) {
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
                TextArea(text: $text, focus: $focusState)
                    .resize(resize.r)
                    .negative(negative)
                    .disable(disable)
                    .heading(heading ? "제목" : nil)
                    .requiredBadge(requiredBadge)
                    .bottomResources(
                        leading: leadingResources,
                        trailing: trailingResources
                    )
                    .description(description ? "메세지에 마침표를 찍어요." : nil)
                    .placeholder(placeholder ? "텍스트를 입력해주세요" : nil)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Options").bold()
                    HStack {
                        HStack {
                            Text("Resize :")
                                .typography(variant: .headline2, weight: .medium)
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
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: placeholder) { placeholder = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Focus :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: focus) {
                                focusState = $0
                            }
                        }
                        HStack {
                            Text("Disable :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: disable) { disable = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Heading :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: heading) { heading = $0 }
                        }
                        HStack {
                            Text("RequiredBadge :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: requiredBadge) { requiredBadge = $0 }
                        }
                    }
                    HStack {
                        HStack {
                            Text("Description :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Control.switch(checked: description) { description = $0 }
                        }
                        Text("Negative :")
                            .typography(variant: .headline2, weight: .medium)
                        Spacer()
                        Control.switch(checked: negative) { negative = $0 }
                    }
                    HStack {
                        HStack {
                            Text("Leading :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Menu("add") {
                                ForEach(resources.indices, id: \.self) { index in
                                    Button {
                                        if let resource = resources[index] {
                                            leadingResources.append(resource)
                                        }
                                    } label: {
                                        Text(resources[index]?.description ?? "none")
                                    }
                                }
                            }
                            Button("reset") {
                                leadingResources.removeAll()
                            }
                        }
                        HStack {
                            Text("Trailing :")
                                .typography(variant: .headline2, weight: .medium)
                            Spacer()
                            Menu("add") {
                                ForEach(resources.indices, id: \.self) { index in
                                    Button {
                                        if let resource = resources[index] {
                                            trailingResources.append(resource)
                                        }
                                    } label: {
                                        Text(resources[index]?.description ?? "none")
                                    }
                                }
                            }
                            Button("reset") {
                                trailingResources.removeAll()
                            }
                        }
                    }
                    .font(.font(variant: .label1))
                    if leadingResources.contains(where: { $0.isCharacterCount }) ||
                        trailingResources.contains(where: { $0.isCharacterCount })
                    {
                        HStack {
                            Text("characterCount")
                                .layoutPriority(1)
                            Text("limit")
                            SwiftUI.Slider(value: $limit, in: 10...1000, step: 10)
                            Text("overflow")
                            Control.switch(checked: overflow) { overflow = $0 }
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
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
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
