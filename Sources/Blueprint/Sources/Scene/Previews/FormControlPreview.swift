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
    @State private var showAccessory: Bool = false
    @State private var autoLabelWidth: Bool = true
    @State private var labelWidth: CGFloat = 64
    @State private var guideLine: Bool = false
    @State private var inputIndex = 0
    @State private var selectItems: [Select.Item] = [
        Select.Item(text: "옵션 1"),
        Select.Item(text: "옵션 2"),
        Select.Item(text: "옵션 3"),
    ]

    private let sizeLabels = ["large", "medium"]
    private let statusLabels = ["normal", "positive", "negative"]
    private let placementLabels = ["top", "leading"]
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
        placementIndex == 0 ? .top : .leading
    }

    var body: some View {
        PreviewLayout {
            configuredControl
        } options: {
            SegmentedIndexRow("input", index: $inputIndex, labels: inputLabels)
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizeLabels)
            SegmentedIndexRow("status", index: $statusIndex, labels: statusLabels)
            TextFieldOptionRow("label", text: $label)
            SegmentedIndexRow("placement", index: $placementIndex, labels: placementLabels)
            // labelWidth는 leading 배치에서만 의미가 있으므로 그때만 노출한다.
            if placement == .leading {
                ToggleOptionRow("자동 labelWidth", isOn: $autoLabelWidth)
                SliderOptionRow("labelWidth", value: $labelWidth, in: 40...160, step: 4, format: { "\(Int($0))" })
                    .if(!autoLabelWidth)
            }
            ToggleOptionRow("required", isOn: $required)
            TextFieldOptionRow("message", text: $message)
            ToggleOptionRow("accessory", isOn: $showAccessory)
        } accessory: {
            SwiftUI.Button(action: { guideLine.toggle() }) {
                Image(systemName: "rectangle.dashed")
            }
        }
    }

    /// 옵션 상태를 반영해 구성한 FormControl. `labelWidth`는 leading 배치 + 토글 ON일 때만 적용한다.
    private var configuredControl: some View {
        // FormControl에만 size·status를 설정하면, context로 전달되어 내부 입력 컴포넌트까지 반영된다.
        var control = FormControl { context in
            switch inputIndex {
            case 1:
                TextArea(text: $text)
                    .size(context.size == .medium ? .medium : .large)
                    .negative(context.status == .negative)
                    .maxLength(showAccessory ? limit : nil)
                    .placeholder("내용을 입력하세요")
            case 2:
                Select(variant: .single(), items: $selectItems)
                    .negative(context.status == .negative)
                    .placeholder("선택하세요")
            default:
                Montage.TextField(text: $text)
                    .size(context.size == .medium ? .medium : .large)
                    .status(context.status.textFieldStatus)
                    .maxLength(showAccessory ? limit : nil)
                    .placeholder("이메일을 입력하세요")
            }
        }
        .size(size)
        .status(status)
        .labelPlacement(placement)
        .label(label, required: required)
        .message(message)

        if placement == .leading && !autoLabelWidth {
            control = control.labelWidth(labelWidth)
        }
        if showAccessory {
            control = control.accessory {
                Text("\(text.count)/\(limit)")
                    .typography(variant: .caption1, weight: .regular, semantic: .labelAlternative)
            }
        }
        return control.border(guideLine ? Color.blue : Color.clear)
    }
}

#Preview {
    FormControlPreview()
}
