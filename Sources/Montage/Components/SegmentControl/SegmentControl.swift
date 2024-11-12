//
//  SegmentControl.swift
//  Montage
//
//  Created by 김삼열 on 11/11/24.
//

import SwiftUI

public struct SegmentControl: View {
    public struct Data {
        let image: Image?
        let title: String
        
        public init(image: Image? = nil, title: String) {
            self.image = image
            self.title = title
        }
    }
    
    public enum Variant {
        case solid, outlined
    }
    
    public enum Size {
        case large, medium, small
    }
    
    @Binding private var selectedIndex: Int
    private let data: [Data]
    private var variant: Variant = .solid
    private var size: Size = .large
    private let onSelect: (Int) -> Void
    
    public init(selectedIndex: Binding<Int>, data: [Data], onChangeDataSource: @escaping (Int) -> Void) {
        _selectedIndex = selectedIndex
        self.data = data
        self.onSelect = onChangeDataSource
    }
    
    @State private var frameSize: CGSize = .zero
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(data.indices, id: \.self) { index in
                SwiftUI.Button {
                    guard selectedIndex != index else { return }
                    withAnimation(.timingCurve(0.25, 1.25, 0.4, 0.99, duration: 0.5)) {
                        selectedIndex = index
                    }
                } label: {
                    HStack(spacing: 4) {
                        data[index].image?
                            .resizable()
                            .frame(width: buttonIconSize.width, height: buttonIconSize.height)
                            .padding(.vertical, 2)
                        
                        Text(data[index].title)
                            .montage(
                                variant: buttonTitleFont,
                                weight: .medium,
                                alias: selectedIndex == index ? .labelNormal : .labelAlternative
                            )
                            .paragraph(variant: buttonTitleFont)
                    }
                    .padding(buttonInsets)
                    .frame(width: max(0, buttonWidth))
                    .frame(maxHeight: .infinity)
                    .background {
                        Group {
                            switch variant {
                            case .solid:
                                RoundedRectangle(cornerRadius: buttonCornerRadius)
                                    .foregroundStyle(SwiftUI.Color.alias(.backgroundElevated))
                                    .offset(x: buttonWidth * CGFloat(selectedIndex), y: 0)
                                    .if(index == 0)
                            case .outlined:
                                ZStack {
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomTrailingRadius: index == data.count - 1 ? buttonCornerRadius : 0,
                                        topTrailingRadius: index == data.count - 1 ? buttonCornerRadius : 0
                                    )
                                    .foregroundStyle(buttonBackgroundColor(isSelected: selectedIndex == index))
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomTrailingRadius: index == data.count - 1 ? buttonCornerRadius : 0,
                                        topTrailingRadius: index == data.count - 1 ? buttonCornerRadius : 0
                                    )
                                    .stroke(buttonBorderColor(isSelected: selectedIndex == index))
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .padding(insets)
        .if(variant == .solid) {
            $0.background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundStyle(backgroundColor)
            }
        }
        .frame(height: frameHeight)
        .frame(maxWidth: .infinity)
        .readSize(onChange: {
            frameSize = $0
        })
        .onChange(of: selectedIndex) { index in
            onSelect(index)
        }
    }
    
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
}

extension SegmentControl {
    private var backgroundColor: SwiftUI.Color {
        switch variant {
        case .solid: .component(.fillNormal)
        case .outlined: .clear
        }
    }
    
    private var frameHeight: CGFloat {
        switch size {
        case .large:
            48
        case .medium:
            40
        case .small:
            32
        }
    }
    
    private var insets: EdgeInsets {
        switch variant {
        case .solid:
            switch size {
            case .large:
                .init(top: 3, leading: 3, bottom: 3, trailing: 3)
            case .medium, .small:
                .init(top: 2, leading: 2, bottom: 2, trailing: 2)
            }
        case .outlined:
                .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
    
    private var cornerRadius: CGFloat {
        switch size {
        case .large:
            12
        case .medium:
            10
        case .small:
            8
        }
    }
    
    private var buttonWidth: CGFloat {
        (frameSize.width - (insets.leading + insets.trailing)) / CGFloat(data.count)
    }
    
    private var buttonTitleFont: Typography.Variant {
        switch size {
        case .large:
                .headline2
        case .medium:
                .body2
        case .small:
                .label2
        }
    }
    
    private var buttonInsets: EdgeInsets {
        switch size {
        case .large:
                .init(top: 9, leading: 8, bottom: 9, trailing: 8)
        case .medium:
                .init(top: 7, leading: 8, bottom: 7, trailing: 8)
        case .small:
                .init(top: 5, leading: 6, bottom: 5, trailing: 6)
        }
    }
    
    private var buttonCornerRadius: CGFloat {
        switch size {
        case .large:
            10
        case .medium:
            8
        case .small:
            6
        }
    }
    
    private var buttonIconSize: CGSize {
        switch size {
        case .large:
                .init(width: 20, height: 20)
        case .medium:
                .init(width: 18, height: 18)
        case .small:
                .init(width: 14, height: 14)
        }
    }
    
    private func buttonBackgroundColor(isSelected: Bool) -> SwiftUI.Color {
        switch variant {
        case .solid: .clear
        case .outlined: isSelected ? .alias(.primaryNormal).opacity(0.05) : .clear
        }
    }
    
    private func buttonBorderColor(isSelected: Bool) -> SwiftUI.Color {
        switch variant {
        case .solid: .clear
        case .outlined: isSelected ? .alias(.primaryNormal).opacity(0.43) : .alias(.lineNormal)
        }
    }
}

import Pretendard
struct SegmentControl_Previews: PreviewProvider {
    @State static var selectedIndex: Int = 0
    static var previews: some View {
        _ = try? Pretendard.registerFonts()
        return VStack {
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            .size(.medium)
            
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            .size(.small)
            
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            .variant(.outlined)
            
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            .variant(.outlined)
            .size(.medium)
            
            SegmentControl(
                selectedIndex: $selectedIndex,
                data: [.init(image: .montage(.android), title: "Android"), .init(image: .montage(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onChangeDataSource: { _ in }
            )
            .variant(.outlined)
            .size(.small)
        }
        .padding()
    }
}
