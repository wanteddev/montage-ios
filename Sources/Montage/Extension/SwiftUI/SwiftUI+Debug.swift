//
//  SwiftUI+Debug.swift
//  Montage
//
//  Created by 김삼열 on 11/22/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func recognizeViewForPreview(_ color: SwiftUI.Color = .blue, fill: Bool = false) -> some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            if fill {
                background(color)
            } else {
                border(color)
            }
        } else {
            self
        }
    }
}

extension View {
    public func carveLogForPreview(
        _ message: String,
        font: Font? = nil,
        alignment: Alignment = .center
    ) -> some View {
        Group {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                ZStack(alignment: alignment) {
                    self
                    SwiftUI.Button {
                        let pasteBoard = UIPasteboard.general
                        pasteBoard.string = message
                    } label: {
                        StrokeText(text: message, font: font ?? .system(size: 12), color: .gray.opacity(0.5))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                            .padding(3)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                self
            }
        }
    }
}

private struct StrokeText: View {
    let text: String
    let font: Font
    let color: SwiftUI.Color

    var body: some View {
        Text(text)
            .font(font)
            .padding(.horizontal, 2)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(color)
            )
    }
}

extension View {
    public func printValue<V: Equatable>(_ value: V, _ label: String = "Unknown") -> some View {
        onChange(of: value) {
            print("🐞\(label) = \($0)")
        }
    }

    public func printSize(_ label: String = "Unknown") -> some View {
        onGeometryChange(for: CGSize.self, of: { $0.size }, action: { print("🐞\(label) = \($0)") })
    }
}

extension View {
    public func measureForPreview(axis: Axis) -> some View {
        modifier(MeasureModifier(axis: axis))
    }

    public func measureBoxForPreview() -> some View {
        modifier(MeasureBoxModifier())
    }
}

public struct MeasureModifier: ViewModifier {
    @State private var size: CGSize = .zero

    private let axis: Axis
    public init(axis: Axis) {
        self.axis = axis
    }

    public func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
            .overlay {
                MeasureView(axis: axis, value: axis == .horizontal ? size.width : size.height)
            }
    }
}

public struct MeasureBoxModifier: ViewModifier {
    @State private var size: CGSize = .zero

    public func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
            .overlay {
                MeasureBoxView(width: size.width, height: size.height)
            }
    }
}

public struct MeasureView: View {
    private let axis: Axis
    private let value: CGFloat

    public init(axis: Axis, value: CGFloat) {
        self.axis = axis
        self.value = value
    }

    public var body: some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            switch axis {
            case .horizontal:
                ZStack {
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: 1)
                        Rectangle()
                            .frame(height: 1)
                            .frame(width: CGFloat(value - 2))
                        Rectangle()
                            .frame(width: 1)
                    }
                    .frame(width: CGFloat(value))
                    Text("\(Int(value))")
                        .font(.system(size: 6))
                        .background {
                            Rectangle().foregroundStyle(SwiftUI.Color.white).opacity(0.7)
                        }
                }
                .foregroundStyle(.red)
            case .vertical:
                ZStack {
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 1)
                        Rectangle()
                            .frame(width: 1)
                            .frame(height: CGFloat(value - 2))
                        Rectangle()
                            .frame(height: 1)
                    }
                    .frame(height: CGFloat(value))
                    Rectangle()
                        .frame(width: 1, height: CGFloat(value))
                    Text("\(Int(value))")
                        .font(.system(size: 6))
                        .background {
                            Rectangle().foregroundStyle(SwiftUI.Color.white).opacity(0.7)
                        }
                }
                .foregroundStyle(.red)
            }
        }
    }
}

public struct MeasureBoxView: View {
    private let width: CGFloat
    private let height: CGFloat
    public init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    public var body: some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            Rectangle()
                .stroke()
                .frame(width: CGFloat(width), height: CGFloat(height))
                .overlay {
                    Text("\(Int(width))x\(Int(height))")
                        .font(.system(size: 6))
                        .background(Rectangle().foregroundStyle(SwiftUI.Color.white).opacity(0.7))
                }
                .foregroundStyle(.red)
        }
    }
}
