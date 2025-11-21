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
    @State private var showTransparentChecker: Bool = false
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
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Options").bold()
                        Spacer()
                        Button(action: {
                            showTransparentChecker.toggle()
                        }) {
                            Image(systemName: "checkerboard.rectangle")
                                .foregroundColor(.semantic(.primaryNormal))
                        }
                    }
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: variants.map { $0.description })
                            .size(.small)
                    }
                    if case .normal = variants[variantIndex] {
                        HStack {
                            Text("show icon")
                            Switch(checked: icon) { icon = $0 }
                        }
                    }
                    HStack {
                        Text("message")
                        TextField(text: $message)
                    }
                    HStack {
                        Text("short duration")
                        Switch(checked: toastShortDuration) { toastShortDuration = $0 }
                    }
                    Button(
                        variant: .outlined,
                        text: "토스트 띄우기"
                    ) {
                        toastModel = Toast.Model(variants[variantIndex], message: message)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .toast($toastModel, duration: toastShortDuration ? .short : .long)
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

extension Toast.Variant: CaseDescribable {}

#Preview {
    ToastPreview()
}
