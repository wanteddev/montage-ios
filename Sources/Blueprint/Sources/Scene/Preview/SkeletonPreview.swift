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
    @State private var text = "텍스트 스켈레톤 테스트"
    @State private var kindIndex = 0
    @State private var alignmentIndex = 0
    @State private var lengthIndices: [Int] = [0]
    @State private var cornerRadius: CGFloat = 3
    @State private var color: SwiftUI.Color = .semantic(.fillNormal)
    @State private var opacity: CGFloat = 1
    
    private let kinds: [Skeleton.Kind] = [
        .text(),
        .rectangle(),
        .circle
    ]
    
    private let alignments: [Skeleton.Align] = [
        .leading,
        .center,
        .trailing
    ]
    
    private let lengths: [Skeleton.Length] = [
        ._100, ._75, ._50, ._25
    ]
    
    @State private var lineNumber: Int = 1
    public var body: some View {
        SwiftUI.ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                }
                .padding(.horizontal)
                Group {
                    switch kinds[kindIndex] {
                    case .text:
                        Text(text)
                            .skeleton(
                                isPresented: isPresented,
                                kind: .text(
                                    alignment: alignments[alignmentIndex],
                                    lengths: lengthIndices.map { lengths[$0] },
                                    cornerRadius: cornerRadius,
                                    lineNumber: lineNumber
                                ),
                                color: color,
                                opacity: opacity,
                                size: text.isEmpty ? .init(width: 200, height: 24) : nil
                            )
                            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                                self.lineNumber = Int($0 / 20)
                            })
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
                    }
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Options").bold()
                    HStack {
                        Text("show skeleton")
                        Switch($isPresented)
                    }
                    HStack {
                        Text("kind")
                        SegmentedControl(selectedIndex: $kindIndex, labels: kinds.map(\.description))
                            .size(.small)
                    }
                    switch kinds[kindIndex] {
                    case .text:
                        HStack {
                            Text("text")
                            TextField(text: $text)
                        }
                        HStack {
                            Text("align")
                            SegmentedControl(
                                selectedIndex: $alignmentIndex,
                                labels: alignments.map(\.description)
                            )
                            .size(.small)
                        }
                        ForEach(0..<lineNumber, id: \.self) { index in
                            HStack {
                                Text("length of line \(index + 1)")
                                SegmentedControl(selectedIndex: $lengthIndices[safe: index] ?? .constant(0), labels: lengths.map { "\(Int($0.rawValue * 100))%" })
                                    .size(.small)
                            }
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
                .padding(.horizontal)
            }
        }
        .onChange(of: lineNumber) { _ in
            lengthIndices = [Int](repeating: 0, count: lineNumber)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension Skeleton.Align: CaseDescribable {}
extension Skeleton.Length: CaseDescribable {}
extension Skeleton.Kind: CaseDescribable {}

#Preview {
    SkeletonPreview()
}
