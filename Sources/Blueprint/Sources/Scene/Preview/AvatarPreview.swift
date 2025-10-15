//
//  AvatarPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct AvatarPreview: View {
    @State var variantIndex: Int = 0
    @State var sizeIndex: Int = 0
    @State var customSize: CGFloat = 100
    @State var pushBadge = false
    @State var borderColor: SwiftUI.Color = .semantic(.lineAlternative)
    @State var borderWidth: CGFloat = 1
    @State var invalidUrl: Bool = false
    
    let variants: [Avatar.Variant] = [.person, .company, .academy]
    let sizes: [Avatar.Size] = [.xsmall, .small, .medium, .large, .xlarge]
    
    var body: some View {
        VStack {
            Text("Avatar").font(.title)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Preview").bold()
                    HStack {
                        Spacer()
                        Avatar(invalidUrl ? "https://invalid-url" : "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg", variant: variants[variantIndex], size: sizes[sizeIndex])
                            .pushBadge(pushBadge)
                            .border(color: borderColor, width: borderWidth)
                        Spacer()
                    }
                    
                    Text("Options").bold()
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                            .size(.small)
                    }
                    if variants[variantIndex] == .person {
                        HStack {
                            Text("pushBadge")
                            Switch($pushBadge)
                        }
                    }
                    HStack {
                        Text("size")
                        SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                            .size(.small)
                    }
                    HStack {
                        Text("invalid image url")
                        Switch($invalidUrl)
                    }
                    HStack {
                        SwiftUI.ColorPicker("borderColor", selection: $borderColor)
                        Text("borderWidth")
                        SwiftUI.Slider(value: $borderWidth, in: 0...5)
                    }
                }
                .font(.caption)
                .padding(.horizontal)
            }
            .hidesIndicators()
            
            GroupAvatarPreview()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

struct GroupAvatarPreview: View {
    private let allUrls = [        "https://static.wanted.co.kr/images/company/3778/brr1yf93dsndmgce__1080_790.png",        "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg",        "https://static.wanted.co.kr/images/school/PNG_162.png",        "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fwdes%2F0_5.c4c61c5a.png&w=100&q=100",        "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fschool%2FPNG_195.png&w=120&q=90"
    ]
    
    @State var variantIndex: Int = 0
    @State var sizeIndex: Int = 0
    @State var alertLabel = ""
    @State var alertPresented: Bool = false
    @State var itemCount: CGFloat = 5
    @State var trailingContent = false
    @State var invalidUrl: Bool = false
    
    let variants: [Avatar.Variant] = [.person, .company, .academy]
    let sizes: [GroupAvatar.Size] = [.xsmall, .small]

    var body: some View {
        Text("GroupAvatar").font(.title)
        ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                HStack {
                    Spacer()
                    GroupAvatar(imageUrls, variant: variants[variantIndex], size: sizes[sizeIndex]) {
                        alertLabel = "Item at index \($0) pressed"
                        alertPresented.toggle()
                    }
                    .if(trailingContent) {
                        $0.trailingContent {
                            TextButton(color: .assistive, size: .small, text: "외 30명이 좋아합니다") {
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
                
                Text("Options").bold()
                HStack {
                    Text("variant")
                    SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                        .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
                HStack {
                    Text("random invalid image url")
                    Switch($invalidUrl)
                }
                HStack {
                    Text("item count")
                    SwiftUI.Slider(value: $itemCount, in: 1...CGFloat(allUrls.count))
                    Text("trailing content")
                    Switch($trailingContent)
                }
            }
            .font(.caption)
            .padding(.horizontal)
        }
        .hidesIndicators()
    }
    
    var imageUrls: [String] {
        var urls = Array(allUrls.prefix(Int(itemCount)))
        if invalidUrl {
            urls[Int.random(in: 0..<urls.count)] = "https://invalid-url"
        }
        return urls
    }
}

extension Avatar.Variant: CaseDescribable {}
extension Avatar.Size: CaseDescribable {}
extension GroupAvatar.Size: CaseDescribable {}

#Preview {
    AvatarPreview()
}
