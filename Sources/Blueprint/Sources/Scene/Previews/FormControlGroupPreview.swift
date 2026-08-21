//
//  FormControlGroupPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 7/7/26.
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI
import Montage

struct FormControlGroupPreview: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var bio = ""
    @State private var regions: [Select.Item] = [
        Select.Item(text: "서울"),
        Select.Item(text: "성남"),
        Select.Item(text: "부산"),
    ]

    @State private var grouped = true
    @State private var autoLabelWidth = true
    @State private var labelWidth: CGFloat = 64
    @State private var guideLine = false

    var body: some View {
        PreviewLayout {
            Group {
                if grouped {
                    FormControlGroup(labelWidth: autoLabelWidth ? nil : labelWidth) {
                        fields
                    }
                } else {
                    VStack(alignment: .leading, spacing: .spacing16) {
                        fields
                    }
                }
            }
            .border(guideLine ? SwiftUI.Color.blue : SwiftUI.Color.clear)
        } options: {
            ToggleOptionRow("grouped", isOn: $grouped)
            ToggleOptionRow("자동 labelWidth", isOn: $autoLabelWidth)
            SliderOptionRow("labelWidth", value: $labelWidth, in: 40...160, step: 4, format: { "\(Int($0))" })
                .if(!autoLabelWidth)
        } accessory: {
            SwiftUI.Button(action: { guideLine.toggle() }) {
                Image(systemName: "rectangle.dashed")
            }
        }
    }

    /// 라벨 길이가 제각각인 leading 입력 묶음. 마지막은 TextArea라 높이가 커진다.
    ///
    /// 입력 컴포넌트가 `label`·`labelPlacement`를 직접 제공하므로 FormControl로 감싸지 않는다.
    @ViewBuilder
    private var fields: some View {
        Montage.TextField(text: $name)
            .placeholder("이름")
            .labelPlacement(.leading)
            .label("이름")

        Montage.TextField(text: $email)
            .placeholder("이메일")
            .labelPlacement(.leading)
            .label("이메일 주소")

        Montage.TextField(text: $phone)
            .placeholder("전화")
            .labelPlacement(.leading)
            .label("전화번호")
            .message("'-' 없이 숫자만 입력해 주세요.")

        Select(variant: .single(), items: $regions)
            .placeholder("지역을 선택하세요")
            .labelPlacement(.leading)
            .label("근무 지역", required: true)

        TextArea(text: $bio)
            .resize(.fixed(min: 200, max: 300))
            .placeholder("자기소개를 입력하세요")
            .label("자기소개")
    }
}

#Preview {
    FormControlGroupPreview()
}
