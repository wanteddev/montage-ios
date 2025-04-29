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
            "https://invalid-url-that-does-not-exist.com/image.jpg"
        } else {
            "https://upload.wikimedia.org/wikipedia/commons/7/7d/%22_The_Calutron_Girls%22_Y-12_Oak_Ridge_1944_Large_Format_%2832093954911%29_%282%29.jpg"
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
                    
                    Thumbnail(urlString: imageURL, ratio: selectedRatio)
                        .radius(radius)
                        .border(border)
                    
                    Spacer(minLength: 0)
                }
                
                VStack(alignment: .leading) {
                    Text("Options").bold()
                    
                    HStack {
                        Text("Ratio")
                        Picker("Ratio", selection: $selectedRatio) {
                            // 가로가 긴 비율
                            Group {
                                Text("21:9").tag(Thumbnail.Ratio.r21x9)
                                Text("2:1").tag(Thumbnail.Ratio.r2x1)
                                Text("16:9").tag(Thumbnail.Ratio.r16x9)
                                Text("1.618:1").tag(Thumbnail.Ratio.r1_618x1)
                                Text("16:10").tag(Thumbnail.Ratio.r16x10)
                                Text("3:2").tag(Thumbnail.Ratio.r3x2)
                                Text("4:3").tag(Thumbnail.Ratio.r4x3)
                                Text("5:4").tag(Thumbnail.Ratio.r5x4)
                            }

                            // 정사각형
                            Text("1:1").tag(Thumbnail.Ratio.r1x1)
                            
                            
                            // 세로가 긴 비율
                            Group {
                                Text("4:5").tag(Thumbnail.Ratio.r4x5)
                                Text("3:4").tag(Thumbnail.Ratio.r3x4)
                                Text("2:3").tag(Thumbnail.Ratio.r2x3)
                                Text("10:16").tag(Thumbnail.Ratio.r10x16)
                                Text("1:1.618").tag(Thumbnail.Ratio.r1x1_618)
                                Text("9:16").tag(Thumbnail.Ratio.r9x16)
                                Text("1:2").tag(Thumbnail.Ratio.r1x2)
                                Text("9:21").tag(Thumbnail.Ratio.r9x21)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 130)
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
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ThumbnailPreview()
}

