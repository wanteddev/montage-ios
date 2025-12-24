//
//  TypographyPreview.swift
//  Montage
//
//  Created by 김삼열 on 8/14/25.
//

import SwiftUI

import Montage

struct TypographyPreview: View {
    @State private var lineCount = 1.0
    
    var body: some View {
        HStack {
            Text("Line Count \(Int(lineCount))")
            SwiftUI.Slider(value: $lineCount, in: 1...20, step: 1)
        }
        .padding(.horizontal, 16)
        HStack {
            SwiftUI.Color.clear
                .frame(width: 109)
            HStack {
                Text("drawn\nheight")
                    .font(.system(size: 8))
                Spacer()
                Text("defined\nheight")
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 8))
            }
            .frame(width: 134)
        }
        .frame(height: 20)
        ScrollView {
            ForEach(Typography.Variant.allCases, id: \.self) { variant in
                HStack(spacing: 4) {
                    VStack{
                        Text(String(describing: variant))
                            .typography(weight: .bold)
                        Text("fontSize: " + String(format: "%.0f", variant.fontSize))
                        Text("fontHeight: " + String(format: "%.1f", variant.fontHeight))
                        Text("lineSpacing: " + String(format: "%.1f", variant.lineSpacing))
                        Text("lineHeight: " + String(format: "%.1f", variant.lineHeight))
                        Text("letterSpacing: " + String(format: "%.1f", variant.tracking))
                    }
                    .monospacedDigit()
                    .font(.system(size: 10, weight: .medium))
                    .frame(width: 109)
                    
                    HStack(alignment: .top, spacing: 1) {
                        Text([String](repeating: " ", count: Int(lineCount)).joined(separator: "\n"))
                            .paragraph(variant: variant)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 30)
                            .dimensioning(axis: .vertical, drawOnPreviewOnly: false)
                        Text([String](repeating: "AA", count: Int(lineCount)).joined(separator: "\n"))
                            .paragraph(variant: variant)
                            .frame(width: 69)
                            .fixedSize(horizontal: false, vertical: true)
                            .border(.red, width: 1 / UIScreen.main.scale)
                        SwiftUI.Color.clear
                            .frame(width: 30, height: variant.lineHeight * lineCount)
                            .dimensioning(axis: .vertical, drawOnPreviewOnly: false)
                    }
                    .frame(width: 134)
                }
            }
            .padding(.horizontal, 16)
        }
        .layoutPriority(1)
    }
}

#Preview {
    return TypographyPreview()
}
