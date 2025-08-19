//
//  SwiftUI+Debug.swift
//  Montage
//
//  Created by 김삼열 on 11/22/24.
//

import SwiftUI

extension View {
    /// 프리뷰에서 View의 frame을 인식합니다.
    ///
    /// - Parameters:
    ///   - color: 인식 색상
    ///   - fill: 배경 채우기 여부
    /// - Returns: 인식된 View
    @ViewBuilder
    public func recognizeView(_ color: SwiftUI.Color = .blue, fill: Bool = false, drawOnPreviewOnly: Bool = true) -> some View {
        if !drawOnPreviewOnly || ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
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
    /// 프리뷰에서 뷰 위에 로그를 출력합니다.
    ///
    /// - Parameters:
    ///   - message: 출력할 메시지
    ///   - font: 폰트
    ///   - alignment: 정렬
    /// - Returns: 로그가 출력된 View
    public func carveLog(
        _ message: String,
        font: Font? = nil,
        alignment: Alignment = .center,
        drawOnPreviewOnly: Bool = true
    ) -> some View {
        Group {
            if !drawOnPreviewOnly || ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
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
    /// 프리뷰에서 값이 변경될 때마다 콘솔에 출력합니다.
    ///
    /// - Parameters:
    ///   - value: 출력할 값
    ///   - label: 출력할 레이블
    /// - Returns: 값이 출력된 View
    public func printValue<V: Equatable>(_ value: V, _ label: String = "Unknown") -> some View {
        onChange(of: value) {
            print("🐞\(label) = \($0)")
        }
    }

    /// 프리뷰에서 크기가 변경될 때마다 콘솔에 출력합니다.
    ///
    /// - Parameter label: 출력할 레이블
    /// - Returns: 크기가 출력된 View
    public func printSize(_ label: String = "Unknown") -> some View {
        onGeometryChange(for: CGSize.self, of: { $0.size }, action: { print("🐞\(label) = \($0)") })
    }
}

extension View {
    /// 프리뷰에서 뷰의 주어진 축의 크기를 측정하여 뷰 위에 출력합니다.
    ///
    /// - Parameter axis: 측정할 축
    /// - Returns: 뷰 크기가 그려진 View
    public func dimensioning(axis: Axis? = nil, drawOnPreviewOnly: Bool = true) -> some View {
        Group {
            if !drawOnPreviewOnly || ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                modifier(DimensionModifier(axis: axis))
            } else {
                self
            }
        }
    }
}

private struct DimensionModifier: ViewModifier {
    @State private var size: CGSize = .zero

    private let axis: Axis?
    init(axis: Axis? = nil) {
        self.axis = axis
    }

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
            .overlay {
                if let axis {
                    DimensionView(axis: axis, value: axis == .horizontal ? size.width : size.height)
                } else {
                    DimensionBoxView(width: size.width, height: size.height)
                }
            }
    }
}

private struct DimensionView: View {
    private let axis: Axis
    private let value: CGFloat

    init(axis: Axis, value: CGFloat) {
        self.axis = axis
        self.value = value
    }

    var body: some View {
        switch axis {
        case .horizontal:
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: 1)
                    Rectangle()
                        .frame(height: 1)
                        .frame(width: CGFloat(max(0, value - 2)))
                    Rectangle()
                        .frame(width: 1)
                }
                .frame(width: CGFloat(value))
                Text("\(String(format: "%.1f", value))")
                    .font(.system(size: 10))
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
                        .frame(height: CGFloat(max(0, value - 2)))
                    Rectangle()
                        .frame(height: 1)
                }
                .frame(height: CGFloat(value))
                Rectangle()
                    .frame(width: 1, height: CGFloat(value))
                Text("\(String(format: "%.1f", value))")
                    .font(.system(size: 10))
                    .background {
                        Rectangle().foregroundStyle(SwiftUI.Color.white).opacity(0.7)
                    }
            }
            .foregroundStyle(.red)
        }
    }
}

private struct DimensionBoxView: View {
    private let width: CGFloat
    private let height: CGFloat
    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }

    var body: some View {
        Rectangle()
            .stroke()
            .frame(width: CGFloat(width), height: CGFloat(height))
            .overlay {
                Text("\(String(format: "%.1f", width))x\(String(format: "%.1f", height))")
                    .font(.system(size: 6))
                    .background(Rectangle().foregroundStyle(SwiftUI.Color.white).opacity(0.7))
            }
            .foregroundStyle(.red)
    }
}
