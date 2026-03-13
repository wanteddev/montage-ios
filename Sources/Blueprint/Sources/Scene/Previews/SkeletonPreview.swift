//
//  SkeletonPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

public struct SkeletonPreview: View {
    @State private var showTransparentChecker: Bool = false
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
        SwiftUI.ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                .padding(.horizontal)
                Group {
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
                }
                .padding()

                options
                    .padding(.horizontal)
            }
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
        .onAppear {
            variantIndex = variants.firstIndex { $0 == .label1 } ?? 0
        }
    }

    var options: some View {
        VStack(alignment: .leading) {
            Text("Options").bold()
            HStack {
                Text("show skeleton")
                Switch(checked: isPresented) { isPresented = $0 }
            }
            HStack {
                Text("kind")
                SegmentedControl(selectedIndex: $kindIndex, labels: PreviewKind.allCases.map(\.description))
                    .size(.small)
            }
            switch PreviewKind.allCases[kindIndex] {
            case .text:
                HStack {
                    Text("text")
                    TextField(text: $text)
                }
                HStack {
                    Text("variant")
                    Picker("variant", selection: $variantIndex) {
                        ForEach(0..<variantLabels.count, id: \.self) { index in
                            SwiftUI.Text(variantLabels[index]).tag(index)
                        }
                    }
                }
                HStack {
                    Text("align")
                    SegmentedControl(
                        selectedIndex: $alignmentIndex,
                        labels: alignments.map(\.description)
                    )
                    .size(.small)
                }
                HStack {
                    VStack(spacing: 0) {
                        Text("cornerRadius")
                        Text(String(format: "%.1f", cornerRadius))
                    }
                    Slider(value: $cornerRadius, in: 0...20)
                }
            case .rectangle:
                HStack {
                    VStack(spacing: 0) {
                        Text("cornerRadius")
                        Text(String(format: "%.1f", cornerRadius))
                    }
                    Slider(value: $cornerRadius, in: 0...20)
                }
            default:
                EmptyView()
            }
            HStack {
                SwiftUI.ColorPicker("color", selection: $color)
            }
            HStack {
                VStack(spacing: 0) {
                    Text("opacity")
                    Text(String(format: "%.1f", opacity))
                }
                Slider(value: $opacity, in: 0...1)
            }
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
extension Skeleton.Length: CaseDescribable {}

#Preview {
    SkeletonPreview()
}
