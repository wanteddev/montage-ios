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
    
    var body: some View {
        VStack {
            Text("Avatar").font(.title)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Preview").bold()
                    HStack {
                        Spacer()
                        Avatar(invalidUrl ? "https://invalid-url" : "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg", variant: Avatar.Variant.allCases[variantIndex], size: Avatar.Size.allCases[sizeIndex])
                            .pushBadge(pushBadge)
                            .border(color: borderColor, width: borderWidth)
                        Spacer()
                    }
                    
                    Text("Options").bold()
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: Avatar.Variant.allCases.map(\.rawValue))
                            .size(.small)
                    }
                    if Avatar.Variant.allCases[variantIndex] == .person {
                        HStack {
                            Text("pushBadge")
                            Control.Switch($pushBadge)
                        }
                    }
                    HStack {
                        Text("size")
                        SegmentedControl(selectedIndex: $sizeIndex, labels: Avatar.Size.allCases.map(\.rawValue))
                            .size(.small)
                    }
                    HStack {
                        Text("invalid image url")
                        Control.Switch($invalidUrl)
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
            
            AvatarGroupPreview()
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

struct AvatarGroupPreview: View {
    let url1 = "https://static.wanted.co.kr/images/company/3778/brr1yf93dsndmgce__1080_790.png"
    let url2 = "https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg"
    let url3 = "https://static.wanted.co.kr/images/school/PNG_162.png"
    let url4 = "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fwdes%2F0_5.c4c61c5a.png&w=100&q=100"
    let url5 = "https://image.wanted.co.kr/optimize?src=https%3A%2F%2Fstatic.wanted.co.kr%2Fimages%2Fschool%2FPNG_195.png&w=120&q=90"
    
    @State var variantIndex: Int = 0
    @State var sizeIndex: Int = 0
    @State var alertLabel = ""
    @State var alertPresented: Bool = false
    @State var itemCount: CGFloat = 5
    @State var trailingContent = false
    @State var invalidUrl: Bool = false

    var body: some View {
        Text("AvatarGroup").font(.title)
        ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                HStack {
                    Spacer()
                    Avatar.Group(imageUrls, variant: Avatar.Variant.allCases[variantIndex], size: Avatar.Group.Size.allCases[sizeIndex]) {
                        alertLabel = "Item at index \($0) pressed"
                        alertPresented.toggle()
                    }
                    .if(trailingContent) {
                        $0.trailingContent {
                            Button.text(variant: .assistive, size: .small, text: "외 30명이 좋아합니다") {
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
                    SegmentedControl(selectedIndex: $variantIndex, labels: Avatar.Variant.allCases.map(\.rawValue))
                        .size(.small)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: Avatar.Group.Size.allCases.map(\.rawValue))
                        .size(.small)
                }
                HStack {
                    Text("random invalid image url")
                    Control.Switch($invalidUrl)
                }
                HStack {
                    Text("item count")
                    SwiftUI.Slider(value: $itemCount, in: 1...5)
                    Text("trailing content")
                    Control.Switch($trailingContent)
                }
            }
            .font(.caption)
            .padding(.horizontal)
        }
        .hidesIndicators()
    }
    
    var imageUrls: [String] {
        var urls = Array([url1, url2, url3, url4, url5].prefix(Int(itemCount)))
        if invalidUrl {
            urls[Int.random(in: 0..<urls.count)] = "https://invalid-url"
        }
        return urls
    }
}

#Preview {
    AvatarPreview()
}
