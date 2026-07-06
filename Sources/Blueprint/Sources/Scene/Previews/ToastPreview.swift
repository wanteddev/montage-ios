//
//  ToastPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 6/25/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct ToastPreview: View {
    @State private var toastModel: Toast.Model?
    @State private var message: String = "토스트 메시지입니다."
    @State private var variantIndex: Int = 0
    @State private var toastShortDuration: Bool = false
    @State private var icon = false

    var variants: [Toast.Variant] {
        [
            .normal(icon ? .android : nil, tint: icon ? .accentBackgroundCyan : nil),
            .positive,
            .cautionary,
            .negative
        ]
    }

    var body: some View {
        PreviewLayout {
            Button(
                variant: .outlined,
                text: "Show Preview"
            ) {
                toastModel = Toast.Model(variants[variantIndex], message: message)
            }
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map { $0.description })
            if case .normal = variants[variantIndex] {
                ToggleOptionRow("show icon", isOn: $icon)
            }
            TextFieldOptionRow("message", text: $message)
            ToggleOptionRow("short duration", isOn: $toastShortDuration)
        }
        .toast($toastModel, duration: toastShortDuration ? .short : .long)
    }
}

extension Toast.Variant: CaseDescribable {}

#Preview {
    ToastPreview()
}
