//
//  FormControlPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 6/30/26.
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI
import Montage

struct FormControlPreview: View {
    @State private var text: String = ""
    @State private var sizeIndex = 0
    @State private var statusIndex = 0
    @State private var placementIndex = 0
    @State private var label: String = "이메일"
    @State private var required: Bool = true
    @State private var message: String = "회사 이메일을 입력해 주세요."
    @State private var showCharacterCount: Bool = false
    @State private var guideLine: Bool = false
    @State private var inputIndex = 0
    @State private var selectItems: [Select.Item] = [
        Select.Item(text: "옵션 1"),
        Select.Item(text: "옵션 2"),
        Select.Item(text: "옵션 3"),
    ]

    private let sizeLabels = ["large", "medium"]
    private let statusLabels = ["normal", "positive", "negative"]
    private let placementLabels = ["top", "start"]
    private let inputLabels = ["TextField", "TextArea", "Select"]

    private let limit = 100

    private var size: FormControl.Size {
        sizeIndex == 0 ? .large : .medium
    }

    private var status: FormControl.Status {
        switch statusIndex {
        case 1: .positive
        case 2: .negative
        default: .normal
        }
    }

    private var placement: FormControl.LabelPlacement {
        placementIndex == 0 ? .top : .start
    }

    var body: some View {
        PreviewLayout {
            // FormControl에만 size·status를 설정하면, context로 전달되어 내부 입력 컴포넌트까지 반영된다.
            FormControl { context in
                switch inputIndex {
                case 1:
                    TextArea(text: $text)
                        .size(context.size == .medium ? .medium : .large)
                        .negative(context.status == .negative)
                        .maxLength(showCharacterCount ? limit : nil)
                        .placeholder("내용을 입력하세요")
                case 2:
                    Select(variant: .single(), items: $selectItems)
                        .negative(context.status == .negative)
                        .placeholder("선택하세요")
                default:
                    Montage.TextField(text: $text)
                        .size(context.size == .medium ? .medium : .large)
                        .status(context.status.textFieldStatus)
                        .maxLength(showCharacterCount ? limit : nil)
                        .placeholder("이메일을 입력하세요")
                }
            }
            .size(size)
            .status(status)
            .labelPlacement(placement)
            .label(label, required: required)
            .message(message)
            .if(showCharacterCount) {
                $0.characterCount(current: text.count, limit: limit)
            }
            .border(guideLine ? Color.blue : Color.clear)
        } options: {
            SegmentedIndexRow("input", index: $inputIndex, labels: inputLabels)
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizeLabels)
            SegmentedIndexRow("status", index: $statusIndex, labels: statusLabels)
            TextFieldOptionRow("label", text: $label)
            SegmentedIndexRow("placement", index: $placementIndex, labels: placementLabels)
            ToggleOptionRow("required", isOn: $required)
            TextFieldOptionRow("message", text: $message)
            ToggleOptionRow("characterCount", isOn: $showCharacterCount)
        } accessory: {
            SwiftUI.Button(action: { guideLine.toggle() }) {
                Image(systemName: "rectangle.dashed")
            }
        }
    }
}

#Preview {
    FormControlPreview()
}
