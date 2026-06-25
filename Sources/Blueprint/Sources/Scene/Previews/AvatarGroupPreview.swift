//
//  AvatarGroupPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import Montage
import SwiftUI

struct AvatarGroupPreview: View {
    private let allUrls = [
        "https://static.wanted.co.kr/images/company/3778/brr1yf93dsndmgce__1080_790.png",
        "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg",
        "https://static.wanted.co.kr/images/school/PNG_162.png",
        "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fwdes%2F0_5.c4c61c5a.png&w=100&q=100",
        "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fschool%2FPNG_195.png&w=120&q=90",
    ]

    @State private var variantIndex: Int = 0
    @State private var sizeIndex: Int = 0
    @State private var contentModeIndex: Int = 0
    @State private var alertLabel = ""
    @State private var alertPresented: Bool = false
    @State private var itemCount: CGFloat = 5
    @State private var trailingContent = false
    @State private var useLocalImage: Bool = false
    @State private var invalidUrl: Bool = false

    let contentModes: [ContentMode] = [.fit, .fill]

    let variants: [Avatar.Variant] = [.person, .company, .academy]
    let sizes: [AvatarGroup.Size] = [.xsmall, .small]

    var body: some View {
        PreviewLayout {
            HStack {
                Spacer()
                avatarGroup
                    .contentMode(contentModes[contentModeIndex])
                    .if(trailingContent) {
                        $0.trailingContent {
                            TextButton(
                                color: .assistive, size: .small,
                                text: "외 30명이 좋아합니다"
                            ) {
                                alertLabel = "TextButton pressed"
                                alertPresented.toggle()
                            }
                        }
                    }
                    .alert(alertLabel, isPresented: $alertPresented) {
                        SwiftUI.Button("OK") {
                            alertLabel = ""
                        }
                    }
                Spacer()
            }
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
            SegmentedIndexRow("contentMode", index: $contentModeIndex, labels: ["fit", "fill"])
            ToggleOptionRow("local image", isOn: $useLocalImage)
            if !useLocalImage {
                ToggleOptionRow("random invalid image url", isOn: $invalidUrl)
            }
            HStack {
                Text("item count \(Int(itemCount))")
                SwiftUI.Slider(value: $itemCount, in: 1...10)
                ToggleOption("trailing content", isOn: $trailingContent)
            }
        }
    }

    private var avatarGroup: AvatarGroup {
        let onTap: (Int) -> Void = { index in
            alertLabel = "Item at index \(index) pressed"
            alertPresented.toggle()
        }
        if useLocalImage {
            let images = Array(
                repeating: Image("portrait", bundle: .main), count: Int(itemCount)
            )
            return AvatarGroup(
                images, variant: variants[variantIndex], size: sizes[sizeIndex], onTap: onTap
            )
        } else {
            return AvatarGroup(
                imageUrls, variant: variants[variantIndex], size: sizes[sizeIndex], onTap: onTap
            )
        }
    }

    private var imageUrls: [String] {
        let count = min(allUrls.count, Int(itemCount))
        var urls = Array(allUrls.prefix(count))
        if invalidUrl {
            urls[Int.random(in: 0..<urls.count)] = "https://invalid-url"
        }
        return urls
    }
}

extension AvatarGroup.Size: CaseDescribable {}

#Preview {
    AvatarGroupPreview()
}
