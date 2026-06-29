//
//  ThumbnailPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/22/25.
//

import SwiftUI
import Montage

struct ThumbnailPreview: View {
    @State private var selectedRatio: Thumbnail.Ratio = .r1x1
    @State private var radius: Bool = true
    @State private var border: Bool = true
    @State private var invalidURL: Bool = false

    var imageURL: String {
        if invalidURL {
            "https://invalid-url"
        } else {
            "https://upload.wikimedia.org/wikipedia/commons/7/7d/%22_The_Calutron_Girls%22_Y-12_Oak_Ridge_1944_Large_Format_%2832093954911%29_%282%29.jpg"
        }
    }
    
    let ratios: [Thumbnail.Ratio] = [
        .r21x9, .r2x1, .r16x9, .r1_618x1, .r16x10, .r3x2, .r4x3, .r5x4, .r1x1,
        .r4x5, .r3x4, .r2x3, .r10x16, .r1x1_618, .r9x16, .r1x2, .r9x21
    ]

    var body: some View {
        PreviewLayout {
            Thumbnail(urlString: imageURL, ratio: selectedRatio)
                .radius(radius)
                .border(border)
        } options: {
            MenuOptionRow("Ratio", menuLabel: selectedRatio.description) {
                ForEach(ratios, id: \.self) { ratio in
                    Button(ratio.description) { selectedRatio = ratio }
                }
            }
            ToggleOptionRow("Radius", isOn: $radius)
            ToggleOptionRow("Border", isOn: $border)
            ToggleOptionRow("Invalid URL (테스트용)", isOn: $invalidURL)
        }
    }
}

extension Thumbnail.Ratio {
    var description: String {
        String("\(self)")
            .replacingOccurrences(of: "r", with: "")
            .replacingOccurrences(of: "_", with: ".")
            .replacingOccurrences(of: "x", with: ":")
    }
}

#Preview {
    ThumbnailPreview()
}
