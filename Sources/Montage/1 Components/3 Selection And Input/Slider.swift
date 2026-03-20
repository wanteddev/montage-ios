//
//  Slider.swift
//  Montage
//
//  Created by 김삼열 on 1/24/25.
//

import SwiftUI

/// 범위 값을 선택할 수 있는 슬라이더 컴포넌트입니다.
///
/// 단일 또는 이중 슬라이더 노브를 사용하여 지정된 범위 내에서 값을 선택할 수 있습니다.
/// 두 개의 노브를 사용하여 최소값과 최대값을 동시에 설정할 수 있으며, 
/// 각 노브에 레이블을 표시하고 값이 변경될 때 콜백을 받을 수 있습니다.
///
/// ```swift
/// // 기본 슬라이더 (0.0 ~ 1.0 범위)
/// Slider()
///
/// // 사용자 정의 범위 및 레이블 포맷이 있는 슬라이더
/// Slider(
///     isRangeSlider: true,
///     valueRange: 0...100,
///     labelFormatter: { "\(Int($0))%" },
///     onChanged: { low, high in
///         print("범위: \(low) ~ \(high)")
///     }
/// )
/// .label()
/// .heading()
/// ```
public struct Slider: View {
    // MARK: - Initializer
    private let isRangeSlider: Bool
    private let valueRange: ClosedRange<CGFloat>
    private let labelFormatter: (CGFloat) -> String
    private let onChanged: ((CGFloat, CGFloat) -> Void)?
    
    /// 슬라이더를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isRangeSlider: 슬라이더의 변형, 생략하면 기본값으로 `false` 적용 (단일 값 슬라이더)
    ///   - valueRange: 슬라이더가 표현하는 값의 범위, 생략하면 기본값으로 `0...1` 적용
    ///   - labelFormatter: 슬라이더 노브에 표시될 레이블 형식을 지정하는 클로저, 생략하면 기본값으로 `nil` 적용 (소수점 한 자리)
    ///   - onChanged: 슬라이더 값이 변경될 때 호출되는 클로저, 생략하면 기본값으로 `nil` 적용
    public init(
        isRangeSlider: Bool = false,
        valueRange: ClosedRange<CGFloat> = 0...1,
        labelFormatter: ((CGFloat) -> String)? = nil,
        onChanged: ((CGFloat, CGFloat) -> Void)? = nil
    ) {
        self.init(
            isRangeSlider: isRangeSlider,
            minValue: valueRange.lowerBound,
            maxValue: valueRange.upperBound,
            labelFormatter: labelFormatter,
            onChanged: onChanged
        )
    }
    
    /// 슬라이더를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isRangeSlider: 슬라이더의 변형, 생략하면 기본값으로 `false` 적용 (단일 값 슬라이더)
    ///   - minValue: 슬라이더의 최소값, 생략하면 기본값으로 `0` 적용
    ///   - maxValue: 슬라이더의 최대값, 생략하면 기본값으로 `1` 적용
    ///   - labelFormatter: 슬라이더 노브에 표시될 레이블 형식을 지정하는 클로저, 생략하면 기본값으로 `nil` 적용 (소수점 한 자리)
    ///   - onChanged: 슬라이더 값이 변경될 때 호출되는 클로저, 생략하면 기본값으로 `nil` 적용
    public init(
        isRangeSlider: Bool = false,
        minValue: CGFloat = 0,
        maxValue: CGFloat = 1,
        labelFormatter: ((CGFloat) -> String)? = nil,
        onChanged: ((CGFloat, CGFloat) -> Void)? = nil
    ) {
        self.isRangeSlider = isRangeSlider
        self.valueRange = minValue...maxValue
        self.labelFormatter = labelFormatter ?? { String(format: "%.1f", $0) }
        self.onChanged = onChanged
    }
    
    // MARK: - Constants
    
    private static let diameter = 20.0
    private static let lineWidth: CGFloat = 4
    
    // MARK: - Body
    
    @State private var thumbRatio1 = 0.0
    @State private var thumbRatio2 = 1.0
    @State private var focusedThumb: Int?
    @State private var lineLength = 0.0
    @State private var lowValue: CGFloat = 0
    @State private var highValue: CGFloat = 0
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(spacing: 32) {
            if heading {
                Text(headingLabel)
                    .typography(
                        variant: .headline2,
                        weight: .bold,
                        semantic: disable ? .interactionDisable : .labelNormal
                    )
            }
            
            ZStack(alignment: .topLeading) {
                // lines
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Line(kind: .outer, disable: disable)
                            .frame(width: lineLength)
                        
                        Line(kind: .inner, disable: disable)
                            .frame(width: min(lineLength, lineLength * (highThumbRatio - lowThumbRatio)))
                            .offset(x: max(0, lineLength * lowThumbRatio))
                    }
                    .padding(.horizontal, Slider.diameter / 2)
                    .onAppear {
                        lineLength = geo.size.width - Slider.diameter
                    }
                }
                .frame(height: Slider.lineWidth)
                .offset(y: (Slider.diameter - Slider.lineWidth) / 2)
                .mask {
                    GeometryReader { geo in
                        ZStack(alignment: .topLeading) {
                            Rectangle()
                                .frame(width: geo.size.width + 12, height: Slider.diameter + 12)
                            Group {
                                if isRangeSlider {
                                    Circle().stroke(lineWidth: 2)
                                        .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                        .offset(x: max(0, lineLength * thumbRatio1) + 5, y: 5)
                                }
                                Circle().stroke(lineWidth: 2)
                                    .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                    .offset(x: max(0, lineLength * thumbRatio2) + 5, y: 5)
                            }
                            .blendMode(.destinationOut)
                        }
                        .offset(x: -6, y: -6)
                    }
                }
                
                // thumbs
                if isRangeSlider {
                    Thumb(
                        title: label ? labelFormatter(value(from: thumbRatio1)) : nil,
                        value: thumbRatio1,
                        maxValue: lineLength,
                        disable: disable
                    )
                    .zIndex(focusedThumb == 1 ? 1 : 0)
                    .offset(x: max(0, lineLength * thumbRatio1))
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged {
                                thumbRatio1 = thumbRatio(from: $0.location.x)
                                focusedThumb = 1
                            }.onEnded {
                                thumbRatio1 = thumbRatio(from: $0.location.x)
                            }
                    )
                }
                
                Thumb(
                    title: label ? labelFormatter(value(from: thumbRatio2)) : nil,
                    value: thumbRatio2,
                    maxValue: lineLength,
                    disable: disable
                )
                .zIndex(focusedThumb == 2 ? 1 : 0)
                .offset(x: max(0, lineLength * thumbRatio2))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged {
                            thumbRatio2 = thumbRatio(from: $0.location.x)
                            focusedThumb = 2
                        }
                        .onEnded {
                            thumbRatio2 = thumbRatio(from: $0.location.x)
                        }
                )
            }
            .mask {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        Rectangle()
                            .frame(width: geo.size.width + 12, height: geo.size.height + 12)
                            .offset(x: -6, y: -6)
                        Group {
                            if isRangeSlider {
                                Circle().stroke(lineWidth: 2)
                                    .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                    .offset(x: max(0, lineLength * thumbRatio1) - 1, y: -1)
                                    .blendMode(
                                        focusedThumb == 2 && distanceBetweenThumbs <= Slider
                                            .diameter + 12 ? .normal : .destinationOut
                                    )
                                    .zIndex(focusedThumb == 1 ? 1 : 0)
                            }
                            Circle().stroke(lineWidth: 2)
                                .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                .offset(x: max(0, lineLength * thumbRatio2) - 1, y: -1)
                                .blendMode(
                                    focusedThumb == 1 && distanceBetweenThumbs <= Slider
                                        .diameter + 12 ? .normal : .destinationOut
                                )
                                .zIndex(focusedThumb == 2 ? 1 : 0)
                        }
                    }
                }
            }
            .onAppear {
                if isRangeSlider {
                    thumbRatio2 = 0.0
                    thumbRatio2 = 1.0
                } else {
                    thumbRatio1 = 0.0
                }
                updateValues()
            }
            .onChange(of: lowThumbRatio) { _ in
                updateValues()
                onChanged?(lowValue, highValue)
            }
            .onChange(of: highThumbRatio) { _ in
                updateValues()
                onChanged?(lowValue, highValue)
            }
        }
        .allowsHitTesting(!disable)
        .accessibilityElement(children: .ignore)
        .accessibilityValue(headingLabel)
        .accessibilityAdjustableAction { direction in
            let step = 0.05
            switch direction {
            case .increment:
                thumbRatio2 = min(1.0, thumbRatio2 + step)
            case .decrement:
                if isRangeSlider {
                    thumbRatio1 = max(0.0, thumbRatio1 - step)
                } else {
                    thumbRatio2 = max(0.0, thumbRatio2 - step)
                }
            @unknown default:
                break
            }
        }
    }
    
    // MARK: - Modifiers
    private var heading = false
    private var label = false
    private var disable = false
    /// 슬라이더 상단에 제목을 표시할지 여부를 설정합니다.
    ///
    /// - Parameter heading: 제목 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 슬라이더 인스턴스
    public func heading(_ heading: Bool = true) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    /// 슬라이더 노브에 값 레이블을 표시할지 여부를 설정합니다.
    ///
    /// - Parameter label: 레이블 표시 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 슬라이더 인스턴스
    public func label(_ label: Bool = true) -> Self {
        var zelf = self
        zelf.label = label
        return zelf
    }
    
    /// 슬라이더의 활성화 상태를 설정합니다.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 슬라이더 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    // MARK: - private
    
    private func updateValues() {
        lowValue = (valueRange.upperBound - valueRange.lowerBound) * lowThumbRatio + valueRange.lowerBound
        highValue = (valueRange.upperBound - valueRange.lowerBound) * highThumbRatio + valueRange.lowerBound
    }
    
    private func value(from thumbRatio: CGFloat) -> CGFloat {
        (valueRange.upperBound - valueRange.lowerBound) * thumbRatio + valueRange.lowerBound
    }
    
    private var distanceBetweenThumbs: CGFloat {
        lineLength * (highThumbRatio - lowThumbRatio)
    }
    
    private var headingLabel: String {
        "\(labelFormatter(lowValue)) ~ \(labelFormatter(highValue))"
    }
    
    private var lowThumbRatio: CGFloat {
        min(thumbRatio1, thumbRatio2)
    }
    
    private var highThumbRatio: CGFloat {
        max(thumbRatio1, thumbRatio2)
    }
    
    private func thumbRatio(from thumbLocation: CGFloat) -> CGFloat {
        min(lineLength, max(0, thumbLocation - (Slider.diameter / 2))) / lineLength
    }
    
    // MARK: - Inner Views
    
    private struct Line: View {
        enum Kind {
            case inner, outer
        }
        
        private let kind: Kind
        private let disable: Bool
        
        init(kind: Kind, disable: Bool) {
            self.kind = kind
            self.disable = disable
        }
        
        var body: some View {
            RoundedRectangle(cornerRadius: .infinity)
                .fill(lineColor)
        }
        
        var lineColor: SwiftUI.Color {
            guard !disable else { return .semantic(.interactionDisable) }
            return switch kind {
            case .inner:
                .semantic(.primaryNormal)
            case .outer:
                .semantic(.fillStrong)
            }
        }
    }
    
    private struct Thumb: View {
        private let title: String?
        private let value: CGFloat
        private let maxValue: CGFloat
        private let disable: Bool

        init(title: String?, value: CGFloat, maxValue: CGFloat, disable: Bool) {
            self.title = title
            self.value = value
            self.maxValue = maxValue
            self.disable = disable
        }
        
        @State private var isDragging = false
        @State private var textSize: CGSize = .zero
        var body: some View {
            VStack(spacing: 8) {
                Circle()
                    .frame(width: Slider.diameter, height: Slider.diameter)
                    .foregroundStyle(
                        SwiftUI.Color.semantic(disable ? .interactionDisable : .primaryNormal)
                    )
                    .contentShape(Rectangle())
                    .background {
                        Interaction(
                            state: isDragging ? .pressed : .normal,
                            variant: .strong,
                            color: .primaryNormal
                        )
                        .frame(width: Slider.diameter + 12, height: Slider.diameter + 12)
                        .clipShape(Circle())
                    }
                    .overlay {
                        if let title {
                            Label(title: title, value: value, maxValue: maxValue, disable: disable)
                        }
                    }
                
                if let title {
                    Label.spacer(for: title)
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isDragging = true }
                    .onEnded { _ in isDragging = false }
            )
        }
    }
    
    private struct Label: View {
        private let title: String
        private let value: CGFloat
        private let maxValue: CGFloat
        private let disable: Bool
        private var isSpacer = false
        
        init(title: String, value: CGFloat, maxValue: CGFloat, disable: Bool) {
            self.title = title
            self.value = value
            self.maxValue = maxValue
            self.disable = disable
        }
        
        static func spacer(for title: String) -> Label {
            var view = Label(title: title, value: 0, maxValue: 0, disable: false)
            view.isSpacer = true
            return view
        }
        
        @State private var textSize: CGSize = .zero
        
        var body: some View {
            let textView = Text(title)
                .typography(
                    variant: .label1,
                    weight: .medium,
                    semantic: disable ? .interactionDisable : .labelNormal
                )
            Group {
                if isSpacer {
                    textView
                        .lineLimit(1)
                        .frame(width: Slider.diameter)
                        .hidden()
                } else {
                    textView
                        .fixedSize()
                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { textSize = $0 })
                        .offset(
                            x: leadingOverflow - trailingOverflow,
                            y: textSize.height + 8
                        )
                }
            }
        }
        
        private var leadingOverflow: CGFloat {
            max(0, textSize.width / 2 - distanceToLeadingEdge)
        }
        
        private var trailingOverflow: CGFloat {
            max(0, textSize.width / 2 - distanceToTrailingEdge)
        }
        
        private var distanceToTrailingEdge: CGFloat {
            maxValue - value * maxValue + Slider.diameter / 2
        }
        
        private var distanceToLeadingEdge: CGFloat {
            value * maxValue + Slider.diameter / 2
        }
    }
}
