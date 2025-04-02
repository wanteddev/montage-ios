//
//  Slider.swift
//  Montage
//
//  Created by 김삼열 on 1/24/25.
//

import SwiftUI

public struct Slider: View {
    // MARK: - Initializer
    private let range: ClosedRange<CGFloat>
    private let labelFormat: (CGFloat) -> String
    private let onChanged: ((CGFloat, CGFloat) -> Void)?
    
    public init(
        range: ClosedRange<CGFloat> = 0 ... 1,
        labelFormat: ((CGFloat) -> String)? = nil,
        onChanged: ((CGFloat, CGFloat) -> Void)? = nil
    ) {
        self.range = range
        self.labelFormat = labelFormat ?? { String(format: "%.1f", $0) }
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
    
    public var body: some View {
        VStack(spacing: 32) {
            if heading {
                Text(headingLabel)
                    .montage(
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
                                Circle().stroke(lineWidth: 2)
                                    .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                    .offset(x: max(0, lineLength * thumbRatio1) + 5, y: 5)
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
                Thumb(
                    title: label ? labelFormat(value(from: thumbRatio1)) : nil,
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
                
                Thumb(
                    title: label ? labelFormat(value(from: thumbRatio2)) : nil,
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
                            Circle().stroke(lineWidth: 2)
                                .frame(width: Slider.diameter + 2, height: Slider.diameter + 2)
                                .offset(x: max(0, lineLength * thumbRatio1) - 1, y: -1)
                                .blendMode(
                                    focusedThumb == 2 && distanceBetweenThumbs <= Slider
                                        .diameter + 12 ? .normal : .destinationOut
                                )
                                .zIndex(focusedThumb == 1 ? 1 : 0)
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
    }
    
    // MARK: - Modifiers
    private var heading = false
    private var label = false
    private var disable = false
    
    public func heading(_ heading: Bool = true) -> Self {
        var zelf = self
        zelf.heading = heading
        return zelf
    }
    
    public func label(_ label: Bool = true) -> Self {
        var zelf = self
        zelf.label = label
        return zelf
    }
    
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    // MARK: - private
    
    private func updateValues() {
        lowValue = (range.upperBound - range.lowerBound) * lowThumbRatio + range.lowerBound
        highValue = (range.upperBound - range.lowerBound) * highThumbRatio + range.lowerBound
    }
    
    private func value(from thumbRatio: CGFloat) -> CGFloat {
        (range.upperBound - range.lowerBound) * thumbRatio + range.lowerBound
    }
    
    private var distanceBetweenThumbs: CGFloat {
        lineLength * (highThumbRatio - lowThumbRatio)
    }
    
    private var headingLabel: String {
        "\(labelFormat(lowValue) ?? "") ~ \(labelFormat(highValue) ?? "")"
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
                        Decorate.Interaction(
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
                .montage(
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
