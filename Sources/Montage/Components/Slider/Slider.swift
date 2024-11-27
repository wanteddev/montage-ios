//
//  Slider.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/16/24.
//

import Combine
import SwiftUI

public struct Slider: View {
    @ObservedObject private var configuration: SliderConfiguration
    
    public init(configuration: SliderConfiguration) {
        self.configuration = configuration
    }
    
    public var body: some View {
        VStack(spacing: .zero) {
            if configuration.showHeading {
                Text(configuration.headingLabel)
                    .montage(variant: .headline2, weight: .bold, alias: configuration.disable ? .interactionDisable : .labelNormal)
                    .padding(.bottom, 32)
            }
            RoundedRectangle(cornerRadius: configuration.height)
                .fill(SwiftUI.Color.component(.fillStrong))
                .frame(
                    width: configuration.width,
                    height: configuration.height
                )
                .overlay(
                    ZStack {
                        SliderPathBetweenView(
                            slider: configuration,
                            color: configuration.color,
                            disable: configuration.disable
                        )
                        
                        Knob(configuraiton: configuration.lowKnobConfiguration)
                            .highPriorityGesture(
                                configuration.lowKnobConfiguration.sliderDragGesture
                            )
                        
                        Knob(configuraiton: configuration.highKnobConfiguration)
                            .highPriorityGesture(
                                configuration.highKnobConfiguration.sliderDragGesture
                            )
                    }
                )
            let showLabel = configuration.lowKnobConfiguration.labelConfiguration.show &&
            configuration.highKnobConfiguration.labelConfiguration.show
            Spacer()
                .frame(height: showLabel ? 28 : 8)
        }
    }
    
    private struct SliderPathBetweenView: View {
        @ObservedObject var slider: SliderConfiguration
        var color: SwiftUI.Color
        var disable: Bool
        
        var body: some View {
            Path { path in
                path.move(to: slider.lowKnobConfiguration.currentLocation)
                path.addLine(to: slider.highKnobConfiguration.currentLocation)
            }
            .stroke(disable ? .alias(.interactionDisable) : color, lineWidth: slider.height)
        }
    }
}

// MARK: - SliderConfiguration

extension Montage.Slider {
    public final class SliderConfiguration: ObservableObject {
        /// Slider의 총 길이
        /// > 기본값은 (화면의 width - 40) 이며, initializer를 통해 변경할 수 있습니다.
        let width: CGFloat
        
        /// Slider의 두께
        /// > 기본값은 4 이며, initializer를 통해 변경할 수 있습니다.
        let height: CGFloat
        
        /// Slider의 시작값
        let valueStart: Double
        /// Slider의 끝값
        let valueEnd: Double
        /// Slider의 disable 여부
        let disable: Bool
        
        /// Slider의 제목 노출 여부
        /// > 기본값은 false 입니다.
        @Published public var showHeading: Bool
        @Published public var highKnobConfiguration: KnobConfiguration
        @Published public var lowKnobConfiguration: KnobConfiguration
        
        /// SliderKnob의 끝 지점 비율
        @SliderValue var highKnobStartPercentage = 1.0
        
        /// SliderKnob의 시작 지점 비율
        @SliderValue var lowKnobStartPercentage = 0.0

        var anyCancellableHigh: AnyCancellable?
        var anyCancellableLow: AnyCancellable?
        
        /// Slider의 Color
        var color: SwiftUI.Color = .alias(.primaryNormal)
        
        /// heading에 표시될 내용
        public var headingLabel: String {
            if highKnobConfiguration.currentValue.rounded() == lowKnobConfiguration.currentValue.rounded() {
                return highKnobConfiguration.currentLabel
            }
            
            if highKnobConfiguration.currentLocation.x < lowKnobConfiguration.currentLocation.x {
                return "\(highKnobConfiguration.currentLabel) ~ \(lowKnobConfiguration.currentLabel)"
            } else {
                return "\(lowKnobConfiguration.currentLabel) ~ \(highKnobConfiguration.currentLabel)"
            }
        }

        /// Slider Knob의 작은값
        public var lowValue: Double {
            min(lowKnobConfiguration.currentValue, highKnobConfiguration.currentValue)
        }

        /// Slider Knob의 큰값
        public var highValue: Double {
            max(lowKnobConfiguration.currentValue, highKnobConfiguration.currentValue)
        }
        
        public init(
            knobLabelConfiguration: KnobConfiguration.LabelConfiguration = .init(),
            start: Double,
            end: Double
        ) {
            self.width = UIScreen.main.bounds.width - 40
            self.height = 4
            self.showHeading = false
            valueStart = start
            valueEnd = end
            self.disable = false
            
            highKnobConfiguration = KnobConfiguration(
                sliderWidth: self.width,
                sliderHeight: self.height,
                sliderValueStart: valueStart,
                sliderValueEnd: valueEnd,
                disable: disable,
                labelConfiguration: knobLabelConfiguration,
                startPercentage: _highKnobStartPercentage
            )
            
            lowKnobConfiguration = KnobConfiguration(
                sliderWidth: self.width,
                sliderHeight: self.height,
                sliderValueStart: valueStart,
                sliderValueEnd: valueEnd,
                disable: disable,
                labelConfiguration: knobLabelConfiguration,
                startPercentage: _lowKnobStartPercentage
            )
            
            anyCancellableHigh = highKnobConfiguration.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
            anyCancellableLow = lowKnobConfiguration.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
        }
        
        fileprivate init(
            width: CGFloat,
            height: CGFloat,
            showHeading: Bool,
            disable: Bool,
            knobLabelConfiguration: KnobConfiguration.LabelConfiguration = .init(),
            start: Double,
            end: Double
        ) {
            self.width = width
            self.height = height
            self.showHeading = showHeading
            valueStart = start
            valueEnd = end
            self.disable = disable
            
            highKnobConfiguration = KnobConfiguration(
                sliderWidth: self.width,
                sliderHeight: self.height,
                sliderValueStart: valueStart,
                sliderValueEnd: valueEnd,
                disable: disable,
                labelConfiguration: knobLabelConfiguration,
                startPercentage: _highKnobStartPercentage
            )
            
            lowKnobConfiguration = KnobConfiguration(
                sliderWidth: self.width,
                sliderHeight: self.height,
                sliderValueStart: valueStart,
                sliderValueEnd: valueEnd,
                disable: disable,
                labelConfiguration: knobLabelConfiguration,
                startPercentage: _lowKnobStartPercentage
            )
            
            anyCancellableHigh = highKnobConfiguration.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
            anyCancellableLow = lowKnobConfiguration.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
        }
    }
}

// MARK: - Slider Modifier

extension Montage.Slider {
    public func width(_ w: CGFloat) -> Slider {
        let config = SliderConfiguration(
            width: w,
            height: configuration.height,
            showHeading: configuration.showHeading,
            disable: configuration.disable,
            knobLabelConfiguration: configuration.lowKnobConfiguration.labelConfiguration,
            start: configuration.valueStart,
            end: configuration.valueEnd
        )
        return Slider(configuration: config)
    }
    
    public func height(_ h: CGFloat) -> Slider {
        let config = SliderConfiguration(
            width: configuration.width,
            height: h,
            showHeading: configuration.showHeading,
            disable: configuration.disable,
            knobLabelConfiguration: configuration.lowKnobConfiguration.labelConfiguration,
            start: configuration.valueStart,
            end: configuration.valueEnd
        )
        return Slider(configuration: config)
    }
    
    public func showHeading(_ show: Bool) -> Slider {
        let config = SliderConfiguration(
            width: configuration.width,
            height: configuration.height,
            showHeading: show,
            disable: configuration.disable,
            knobLabelConfiguration: configuration.lowKnobConfiguration.labelConfiguration,
            start: configuration.valueStart,
            end: configuration.valueEnd
        )
        return Slider(configuration: config)
    }
    
    public func disable(_ disable: Bool) -> Slider {
        let config = SliderConfiguration(
            width: configuration.width,
            height: configuration.height,
            showHeading: configuration.showHeading,
            disable: disable,
            knobLabelConfiguration: configuration.lowKnobConfiguration.labelConfiguration,
            start: configuration.valueStart,
            end: configuration.valueEnd
        )
        return Slider(configuration: config)
    }
}

// MARK: - PropertyWrapper

extension Montage.Slider {
    // SliderValue to restrict double range: 0.0 to 1.0
    @propertyWrapper
    struct SliderValue {
        var value: Double
        
        init(wrappedValue: Double) {
            self.value = wrappedValue
        }
        
        var wrappedValue: Double {
            get { value }
            set { value = min(max(0.0, newValue), 1.0) }
        }
    }
}

// MARK: - Knob

extension Montage.Slider {
    struct Knob: View {
        @ObservedObject var configuraiton: KnobConfiguration
        @State private var textSize: CGSize = .zero
        
        var body: some View {
            ZStack {
                Decorate.InteractionController(
                    state: configuraiton.onDrag ? .pressed : .normal,
                    variant: .strong,
                    color: .primaryNormal
                )
                .frame(width: configuraiton.diameter + 12, height: configuraiton.diameter + 12)
                .clipShape(Circle())
                .position(x: configuraiton.currentLocation.x, y: configuraiton.currentLocation.y)
                
                
                Circle()
                    .frame(width: configuraiton.diameter, height: configuraiton.diameter)
                    .foregroundStyle(configuraiton.disable ? SwiftUI.Color.alias(.interactionDisable) : configuraiton.color)
                    .contentShape(Rectangle())
                    .overlay(
                        Circle()
                            .stroke(configuraiton.backgroundColor, lineWidth: 2)
                    )
                    .position(x: configuraiton.currentLocation.x, y: configuraiton.currentLocation.y)
            }
            .overlay(
                ZStack {
                    if configuraiton.labelConfiguration.show {
                        Text(
                            String(format: "%.f", configuraiton.currentValue)
                            + configuraiton.labelConfiguration.unit
                        )
                        .montage(variant: .label1, weight: .medium, alias: configuraiton.disable ? .interactionDisable : .labelNormal)
                        .onGeometryChange(for: CGSize.self, of: { $0.size }) { textSize = $0 }
                        .position(
                            x: configuraiton.currentLocation.x,
                            y: configuraiton.currentLocation.y + 8 + textSize.height
                        )
                    }
                }
            )
            .allowsHitTesting(configuraiton.disable == false)
        }
    }
    
    public final class KnobConfiguration: ObservableObject {
        public struct LabelConfiguration {
            let show: Bool
            let unit: String
            
            public init(show: Bool = false, unit: String = "") {
                self.show = show
                self.unit = unit
            }
        }

        private let sliderWidth: CGFloat
        private let sliderHeight: CGFloat
        
        private let sliderValueStart: Double
        private let sliderValueRange: Double
        
        let diameter: CGFloat = 20
        var startLocation: CGPoint
        let color: SwiftUI.Color
        let backgroundColor: SwiftUI.Color
        let disable: Bool
        
        @Published public var labelConfiguration: LabelConfiguration
        @Published var currentPercentage: SliderValue
        @Published var onDrag: Bool
        @Published var currentLocation: CGPoint
            
        init(
            sliderWidth: CGFloat,
            sliderHeight: CGFloat,
            sliderValueStart: Double,
            sliderValueEnd: Double,
            color: SwiftUI.Color = .alias(.primaryNormal),
            backgroundColor: SwiftUI.Color = .alias(.backgroundNormal),
            disable: Bool,
            labelConfiguration: LabelConfiguration,
            startPercentage: SliderValue
        ) {
            self.sliderWidth = sliderWidth
            self.sliderHeight = sliderHeight
            self.sliderValueStart = sliderValueStart
            self.sliderValueRange = sliderValueEnd - sliderValueStart
            
            self.color = color
            self.backgroundColor = backgroundColor
            self.disable = disable
            
            self.labelConfiguration = labelConfiguration
            
            let startLocation = CGPoint(x: (CGFloat(startPercentage.wrappedValue)/1.0)*sliderWidth, y: sliderHeight/2)
            
            self.startLocation = startLocation
            self.currentLocation = startLocation
            self.currentPercentage = startPercentage
            
            self.onDrag = false
        }
        
        lazy var sliderDragGesture: _EndedGesture<_ChangedGesture<DragGesture>> = DragGesture()
            .onChanged { value in
                self.onDrag = true
                
                let dragLocation = value.location
                
                // Restrict possible drag area
                self.restrictSliderBtnLocation(dragLocation)
                
                // Get current value
                self.currentPercentage.wrappedValue = Double(self.currentLocation.x / self.sliderWidth)
                
            }.onEnded { _ in
                self.onDrag = false
            }
        
        private func restrictSliderBtnLocation(_ dragLocation: CGPoint) {
            if dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth {
                calcSliderBtnLocation(dragLocation)
            }
        }
        
        private func calcSliderBtnLocation(_ dragLocation: CGPoint) {
            if dragLocation.y != sliderHeight/2 {
                currentLocation = CGPoint(x: dragLocation.x, y: sliderHeight/2)
            } else {
                currentLocation = dragLocation
            }
        }

        var currentValue: Double {
            sliderValueStart + currentPercentage.wrappedValue * sliderValueRange
        }
        
        var currentLabel: String {
            String(format: "%.f", currentValue) + labelConfiguration.unit
        }
    }
}

#Preview {
    Slider(
        configuration: .init(
            knobLabelConfiguration: .init(show: true, unit: "년"),
            start: 0,
            end: 10
        )
    )
    .showHeading(true)
    .disable(false)
}
