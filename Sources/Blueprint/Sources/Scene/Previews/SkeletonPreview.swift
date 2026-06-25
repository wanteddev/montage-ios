//
//  SkeletonPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

public struct SkeletonPreview: View {
    @State private var isPresented = true
    @State private var text = "텍스트 스켈레톤 테스트 길이가 긴 텍스트입니다. 텍스트를 더 길게 입력해보세요. 어떤 변화가 일어나는지 확인해보세요."
    @State private var kindIndex = 0
    @State private var alignmentIndex = 0
    @State private var variantIndex = 0
    @State private var cornerRadius: CGFloat = 3
    @State private var color: SwiftUI.Color = .semantic(.fillNormal)
    @State private var opacity: CGFloat = 1

    private enum PreviewKind: CaseIterable, CaseDescribable {
        case text, rectangle, circle, custom
    }

    private let alignments: [Skeleton.Align] = [
        .leading,
        .center,
        .trailing
    ]

    private let variants: [Typography.Variant] = [
        .display1, .display2, .display3,
        .title1, .title2, .title3,
        .heading1, .heading2,
        .headline1, .headline2,
        .body1, .body2,
        .label1, .label2,
        .caption1, .caption2
    ]

    private let variantLabels: [String] = [
        "display1", "display2", "display3",
        "title1", "title2", "title3",
        "heading1", "heading2",
        "headline1", "headline2",
        "body1", "body2",
        "label1", "label2",
        "caption1", "caption2"
    ]

    public var body: some View {
        PreviewLayout {
            switch PreviewKind.allCases[kindIndex] {
            case .text:
                Text(text)
                    .paragraph(variant: variants[variantIndex])
                    .skeleton(
                        isPresented: isPresented,
                        kind: .text(
                            variant: variants[variantIndex],
                            alignment: alignments[alignmentIndex],
                            cornerRadius: cornerRadius
                        ),
                        color: color,
                        opacity: opacity,
                        size: text.isEmpty ? .init(width: 200, height: 24) : nil
                    )
            case .rectangle:
                Image(.placeholder)
                    .cornerRadius(cornerRadius)
                    .skeleton(
                        isPresented: isPresented,
                        kind: .rectangle(cornerRadius: cornerRadius),
                        color: color,
                        opacity: opacity
                    )
            case .circle:
                Avatar("https://cdn.pixabay.com/photo/2024/03/11/11/41/ai-generated-8626442_640.jpg", variant: .person, size: .large)
                    .skeleton(
                        isPresented: isPresented,
                        kind: .circle,
                        color: color,
                        opacity: opacity
                    )
            case .custom:
                Triangle()
                    .fill(.blue)
                    .frame(width: 100, height: 100)
                    .skeleton(isPresented: isPresented) {
                        Triangle()
                            .fill(color)
                            .frame(width: 100, height: 100)
                    }
            }
        } options: {
            ToggleOptionRow("show skeleton", isOn: $isPresented)
            SegmentedIndexRow("kind", index: $kindIndex, labels: PreviewKind.allCases.map(\.description))
            switch PreviewKind.allCases[kindIndex] {
            case .text:
                TextFieldOptionRow("text", text: $text)
                HStack {
                    Text("variant")
                    Picker("variant", selection: $variantIndex) {
                        ForEach(0..<variantLabels.count, id: \.self) { index in
                            SwiftUI.Text(variantLabels[index]).tag(index)
                        }
                    }
                }
                SegmentedIndexRow("align", index: $alignmentIndex, labels: alignments.map(\.description))
                SliderOptionRow("cornerRadius", value: $cornerRadius, in: 0...20, format: { String(format: "%.1f", Double($0)) })
            case .rectangle:
                SliderOptionRow("cornerRadius", value: $cornerRadius, in: 0...20, format: { String(format: "%.1f", Double($0)) })
            default:
                EmptyView()
            }
            HStack {
                SwiftUI.ColorPicker("color", selection: $color)
            }
            SliderOptionRow("opacity", value: $opacity, in: 0...1, format: { String(format: "%.1f", Double($0)) })
        }
        .onAppear {
            variantIndex = variants.firstIndex { $0 == .label1 } ?? 0
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.midX, y: rect.minY),
                CGPoint(x: rect.maxX, y: rect.maxY),
            ])
        }
    }
}

extension Skeleton.Align: CaseDescribable {}

#Preview {
    SkeletonPreview()
}
