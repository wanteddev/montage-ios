//
//  ThumbnailPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/22/25.
//

import SwiftUI
import Montage

struct ThumbnailPreview: View {
    @State private var selectedRatio: Ratio = .r1x1
    @State private var radius: Bool = false
    @State private var border: Bool = false
    @State private var useWidth: Bool = true
    @State private var size: CGFloat = 200
    @State private var invalidURL: Bool = false
    @State private var customPlaceholder: Bool = false
    
    var imageURL: URL? {
        if invalidURL {
            return URL(string: "https://invalid-url-that-does-not-exist.com/image.jpg")
        } else {
            return URL(string: "https://developer.apple.com/xcode/images/xcode-15-hero-large_2x.webp")
        }
    }
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    Thumbnail(
                        url: imageURL,
                        placeholder: customPlaceholder ? {
                            ProgressView()
                        } : nil
                    )
                    .radius(radius)
                    .border(border)
                    .modifying {
                        if useWidth {
                            $0.ratio(selectedRatio, width: size)
                        } else {
                            $0.ratio(selectedRatio, height: size)
                        }
                    }
                    Spacer(minLength: 0)
                }
                
                VStack(alignment: .leading) {
                    Text("Options").bold()
                    
                    HStack {
                        Text("Ratio")
                        Picker("Ratio", selection: $selectedRatio) {
                            // 가로가 긴 비율
                            Group {
                                Text("21:9").tag(Ratio.r21x9)
                                Text("2:1").tag(Ratio.r2x1)
                                Text("16:9").tag(Ratio.r16x9)
                                Text("1.618:1").tag(Ratio.r1_618x1)
                                Text("16:10").tag(Ratio.r16x10)
                                Text("3:2").tag(Ratio.r3x2)
                                Text("4:3").tag(Ratio.r4x3)
                                Text("5:4").tag(Ratio.r5x4)
                            }

                            // 정사각형
                            Text("1:1").tag(Ratio.r1x1)
                            
                            
                            // 세로가 긴 비율
                            Group {
                                Text("4:5").tag(Ratio.r4x5)
                                Text("3:4").tag(Ratio.r3x4)
                                Text("2:3").tag(Ratio.r2x3)
                                Text("10:16").tag(Ratio.r10x16)
                                Text("1:1.618").tag(Ratio.r1x1_618)
                                Text("9:16").tag(Ratio.r9x16)
                                Text("1:2").tag(Ratio.r1x2)
                                Text("9:21").tag(Ratio.r9x21)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    
                    HStack {
                        Text("Size Mode")
                        Picker("Size Mode", selection: $useWidth) {
                            Text("Width").tag(true)
                            Text("Height").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Text(useWidth ? "Width" : "Height")
                        Slider(value: $size, in: 50...maxSize, step: 10)
                        Text("\(Int(size))pt")
                    }
                    
                    HStack {
                        Text("Radius")
                        Control.Switch($radius)
                    }
                    
                    HStack {
                        Text("Border")
                        Control.Switch($border)
                    }
                    
                    HStack {
                        Text("Invalid URL (테스트용)")
                        Control.Switch($invalidURL)
                    }
                    
                    HStack {
                        Text("Custom Placeholder")
                        Control.Switch($customPlaceholder)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    var maxSize: CGFloat {
        useWidth ? maxWidth : maxHeight
    }
    
    var maxWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    var maxHeight: CGFloat {
        maxWidth / selectedRatio.rawValue
    }
}

#Preview {
    ThumbnailPreview()
}

