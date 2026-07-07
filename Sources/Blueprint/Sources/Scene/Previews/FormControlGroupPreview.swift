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

    @State private var grouped = true
    @State private var guideLine = false

    var body: some View {
        PreviewLayout {
            Group {
                if grouped {
                    FormControlGroup {
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
        } accessory: {
            SwiftUI.Button(action: { guideLine.toggle() }) {
                Image(systemName: "rectangle.dashed")
            }
        }
    }

    /// 라벨 길이가 제각각인 leading FormControl 묶음. 마지막은 TextArea라 높이가 커진다.
    @ViewBuilder
    private var fields: some View {
        textField("이름", text: $name, placeholder: "이름")
        textField("이메일 주소", text: $email, placeholder: "이메일")
        textField("전화번호", text: $phone, placeholder: "전화")
        FormControl { context in
            TextArea(text: $bio)
                .negative(context.status == .negative)
                .placeholder("자기소개를 입력하세요")
        }
        .labelPlacement(.leading)
        .label("자기소개")
    }

    private func textField(_ label: String, text: Binding<String>, placeholder: String) -> some View {
        FormControl { context in
            Montage.TextField(text: text)
                .status(context.status.textFieldStatus)
                .placeholder(placeholder)
        }
        .labelPlacement(.leading)
        .label(label)
    }
}

#Preview {
    FormControlGroupPreview()
}
