//
//  SearchFieldPreview.swift
//  Blueprint
//
//  Created by Samuel Kim on 8/5/26.
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct SearchFieldPreview: View {

    enum Variant: String, CaseIterable, PreviewSegment {
        case solid
        case outlined

        var selectableTitle: String {
            self.rawValue.capitalized
        }

        var v: Montage.SearchField.Variant {
            switch self {
            case .solid: .solid
            case .outlined: .outlined
            }
        }
    }

    enum FieldSize: String, CaseIterable, PreviewSegment {
        case large
        case medium

        var selectableTitle: String {
            self.rawValue.capitalized
        }

        var s: Montage.SearchField.Size {
            switch self {
            case .large: .large
            case .medium: .medium
            }
        }
    }

    @State private var text: String = ""
    @State private var variant: Variant = .solid
    @State private var fieldSize: FieldSize = .large
    @State private var disable: Bool = false
    @State private var placeholder: Bool = true
    @State private var focused: Bool = false
    @State private var submittedKeyword: String = ""
    @State private var autocorrectionDisabled: Bool = false

    var body: some View {
        PreviewLayout {
            SearchField(text: $text)
                .variant(variant.v)
                .size(fieldSize.s)
                .placeholder(placeholder ? "검색어를 입력해 주세요." : nil)
                .focused($focused)
                .autocorrectionDisabled(autocorrectionDisabled)
                .onSubmit { submittedKeyword = text }
                .disabled(disable)
        } options: {
            SegmentedOptionRow("variant", selection: $variant)
            SegmentedOptionRow("size", selection: $fieldSize)
            HStack {
                ToggleOption("placeholder", isOn: $placeholder)
                ToggleOption("disable", isOn: $disable)
            }
            ToggleOption("focused", isOn: $focused)
            ToggleOption("autocorrectionDisabled", isOn: $autocorrectionDisabled)
            Text("제출된 검색어: \(submittedKeyword.isEmpty ? "-" : submittedKeyword)")
                .foregroundStyle(SwiftUI.Color.secondary)
        }
    }
}

#Preview {
    SearchFieldPreview()
}
