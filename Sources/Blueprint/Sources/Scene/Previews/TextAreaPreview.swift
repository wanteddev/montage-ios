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
    enum Size: String, CaseIterable {
        case large
        case medium

        var description: String {
            self.rawValue.capitalized
        }

        var s: TextArea.Size {
            switch self {
            case .large: .large
            case .medium: .medium
            }
        }
    }

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
            case .fixed: .fixed(min: 116, max: 200)
            }
        }
    }

    var resources: [TextArea.Resource?] {
        [
            .button(
                title: "Text",
                handler: {}
            ),
            .iconButton(
                icon: .send,
                handler: {}
            ),
            .primaryIconButton(
                icon: .send,
                handler: {}
            ),
            .icon(
                .chevronDown
            ),
            .contentBadge(
                title: "Badge"
            ),
            .segmentedControl(
                selectedIndex: $segmentIndex,
                icons: [.send, .chevronDown]
            ),
            .slot {
                Image(systemName: "star.fill")
                    .foregroundColor(.semantic(.primaryNormal))
            }
        ]
    }

    @State private var showTransparentChecker: Bool = false
    @State private var text: String = ""
    @State private var size: Size = .large
    @State private var resize: Resize = .normal
    @State private var negative: Bool = false
    @State private var focus: Bool = false
    @FocusState private var focusState: Bool
    @State private var disable: Bool = false
    @State private var placeholder: Bool = true
    @State private var leadingResources = [TextArea.Resource]()
    @State private var trailingResources = [TextArea.Resource]()
    @State private var maxLength: CGFloat = 0
    @State private var characterCount: Int = 0
    @State private var segmentIndex: Int = 0

    var body: some View {
        SwiftUI.ScrollView {
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
                Group {
                    TextArea(text: $text, focus: $focusState)
                        .size(size.s)
                        .resize(resize.r)
                        .negative(negative)
                        .disable(disable)
                        .bottomResources(
                            leading: leadingResources,
                            trailing: trailingResources
                        )
                        .maxLength(maxLength > 0 ? Int(maxLength) : nil)
                        .onTextChange { characterCount = $0.count }
                        .placeholder(placeholder ? "텍스트를 입력해주세요" : nil)
                }
                Text("Options").bold()
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: Binding(
                            get: { Size.allCases.firstIndex(of: size) ?? 0 },
                            set: { size = Size.allCases[$0] }
                        ),
                        labels: Size.allCases.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("resize")
                    SegmentedControl(
                        selectedIndex: Binding(
                            get: { Resize.allCases.firstIndex(of: resize) ?? 0 },
                            set: { resize = Resize.allCases[$0] }
                        ),
                        labels: Resize.allCases.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    Text("placeholder")
                    Switch(checked: placeholder) { placeholder = $0 }
                    Text("focus")
                    Switch(checked: focus) { focusState = $0 }
                }
                HStack {
                    Text("disable")
                    Switch(checked: disable) { disable = $0 }
                    Text("negative")
                    Switch(checked: negative) { negative = $0 }
                }
                HStack {
                    Text("leading")
                    Menu("add") {
                        ForEach(resources.indices, id: \.self) { index in
                            if resources[index]?.isLeadingAllowed ?? false {
                                Button {
                                    if let resource = resources[index] {
                                        leadingResources.append(resource)
                                        leadingResources = leadingResources.suffix(3)
                                    }
                                } label: {
                                    Text(resources[index]?.description ?? "none")
                                }
                            }
                        }
                    }
                    Button("reset") { leadingResources.removeAll() }
                    Spacer()
                    Text("trailing")
                    Menu("add") {
                        ForEach(resources.indices, id: \.self) { index in
                            Button {
                                if let resource = resources[index] {
                                    trailingResources.append(resource)
                                    trailingResources = trailingResources.suffix(3)
                                }
                            } label: {
                                Text(resources[index]?.description ?? "none")
                            }
                        }
                    }
                    Button("reset") { trailingResources.removeAll() }
                }
                HStack {
                    Text("maxLength")
                        .layoutPriority(1)
                    SwiftUI.Slider(value: $maxLength, in: 0...1000, step: 10)
                    Text(maxLength > 0 ? "\(characterCount)/\(Int(maxLength))" : "off")
                }
                Spacer(minLength: 0)
            }
            .font(.caption)
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

extension TextArea.Resource: CaseDescribable {}

#Preview {
    TextAreaPreview()
}
