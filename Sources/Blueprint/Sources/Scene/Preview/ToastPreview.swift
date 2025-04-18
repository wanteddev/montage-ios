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
    @State private var variantIndex: Int = 0
    @State private var toastShortDuration: Bool = false
    @State private var showBGImage: Bool = false
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
        ZStack {
            if showBGImage {
                VStack {
                    Spacer()
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                }
            }
            ScrollView {
                VStack(spacing: 12) {
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: variants.map { $0.description })
                            .size(.small)
                    }
                    if case .normal = variants[variantIndex] {
                        Toggle(isOn: $icon) {
                            Text("show icon")
                        }
                    }
                    Toggle(isOn: $showBGImage) {
                        Text("show background Image")
                    }
                    Toggle(isOn: $toastShortDuration) {
                        Text("short duration")
                    }
                    Button.outlined(
                        text: "토스트 띄우기"
                    ) {
                        toastModel = Toast.Model(variants[variantIndex], message: "토스트는 이렇게 생겼습니다.")
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .toast($toastModel, duration: toastShortDuration ? .short : .long)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Toast.Variant: CaseDescribable {}

#Preview {
    ToastPreview()
}
