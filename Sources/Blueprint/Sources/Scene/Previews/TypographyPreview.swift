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
    /// drawn 높이의 상·하 경계를 우측 defined 박스 쪽으로 연장해 비교하기 위한 가이드 라인 너비.
    /// 프리뷰 레이아웃에 맞춘 고정값이며, 매우 큰 Dynamic Type에서는 샘플 텍스트가 이보다 넓어질 수 있다.
    private let guideLineWidth: CGFloat = 125

    var body: some View {
        HStack {
            Text("Multiline Count: \(Int(lineCount))")
                .font(.system(size: 10, weight: .medium))
            SwiftUI.Slider(value: $lineCount, in: 1...20, step: 1)
        }
        .padding(.horizontal, 16)
        ScrollView {
            Grid(horizontalSpacing: 0) {
                GridRow {
                    Text("variant")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 8))
                    
                    Text("metrics based on\nLarge dynamic type")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 8))
                        .frame(width: 109)
                    
                    Spacer().frame(width: 20)
                    
                    Text("drawn\nheight")
                        .font(.system(size: 8))

                    Text("rendered\nsample")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 8))

                    Text("defined\nheight")
                        .multilineTextAlignment(.trailing)
                        .font(.system(size: 8))
                }
                ForEach(Typography.Variant.allCases, id: \.self) { variant in
                    GridRow(alignment: .top) {
                        Text(String(describing: variant))
                            .font(.system(size: 14, weight: .bold))
                        
                        VStack{
                            Text("fontSize: " + String(format: "%.0f", variant.fontSize))
                            Text("fontHeight: " + String(format: "%.1f", variant.fontHeight))
                            Text("lineSpacing: " + String(format: "%.1f", variant.lineSpacing))
                            Text("lineHeight: " + String(format: "%.1f", variant.lineHeight))
                            Text("letterSpacing: " + String(format: "%.1f", variant.tracking))
                        }
                        .monospacedDigit()
                        .font(.system(size: 10, weight: .medium))
                        .frame(width: 109)
                        
                        Spacer().frame(width: 20)
                        
                        Text([String](repeating: " ", count: Int(lineCount)).joined(separator: "\n"))
                            .paragraph(variant: variant)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 30)
                            .dimensioning(axis: .vertical, drawOnPreviewOnly: false)
                        
                        Text([String](repeating: "AA", count: Int(lineCount)).joined(separator: "\n"))
                            .paragraph(variant: variant)
                            .fixedSize(horizontal: false, vertical: true)
                            .border(.red, width: 1 / UIScreen.main.scale)
                            .background {
                                VStack {
                                    Rectangle()
                                        .foregroundStyle(Color.red)
                                        .frame(width: guideLineWidth, height: 1 / UIScreen.main.scale)
                                    Spacer()
                                    Rectangle()
                                        .foregroundStyle(Color.red)
                                        .frame(width: guideLineWidth, height: 1 / UIScreen.main.scale)
                                }
                            }
                        
                        DefinedHeightBox(variant: variant, lineCount: lineCount)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .layoutPriority(1)
    }
}

/// "defined height" 박스. variant.lineHeight를 폰트와 동일한 곡선(`variant.textStyle`)으로
/// 스케일해, Dynamic Type가 커져도 실제 그려지는 높이(drawn)와 비교 가능하도록 한다.
private struct DefinedHeightBox: View {
    let lineCount: Double
    @ScaledMetric private var lineHeight: CGFloat

    init(variant: Typography.Variant, lineCount: Double) {
        self.lineCount = lineCount
        _lineHeight = ScaledMetric(wrappedValue: variant.lineHeight, relativeTo: variant.textStyle)
    }

    var body: some View {
        SwiftUI.Color.clear
            .frame(width: 30, height: lineHeight * lineCount)
            .dimensioning(axis: .vertical, drawOnPreviewOnly: false)
    }
}

#Preview {
    TypographyPreview()
}
