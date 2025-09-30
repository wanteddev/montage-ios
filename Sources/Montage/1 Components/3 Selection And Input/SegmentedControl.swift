//
//  SegmentedControl.swift
//  Montage
//
//  Created by 김삼열 on 11/11/24.
//

import SwiftUI

/// 여러 옵션 중 하나를 선택할 수 있는 세그먼트 컨트롤 컴포넌트입니다.
///
/// 제한된 옵션 세트 내에서 선택할 수 있도록 하는 가로로 정렬된 버튼 그룹입니다.
/// 각 세그먼트는 이미지와 텍스트를 포함할 수 있으며, 선택된 세그먼트는 시각적으로 강조됩니다.
///
/// ```swift
/// @State private var selectedIndex = 0
///
/// // 텍스트만 있는 세그먼트 컨트롤
/// SegmentedControl(
///     selectedIndex: $selectedIndex,
///     labels: ["첫 번째", "두 번째", "세 번째"]
/// )
///
/// // 이미지와 텍스트가 모두 있는 세그먼트 컨트롤
/// SegmentedControl(
///     selectedIndex: $selectedIndex,
///     items: [
///         .init(image: .icon(.home), title: "홈"),
///         .init(image: .icon(.person), title: "프로필"),
///         .init(title: "설정")
///     ]
/// )
/// .variant(.outlined)
/// .size(.medium)
/// ```
///
/// - Note: 기본 변형(.solid)은 배경이 있는 형태로, .outlined 변형은 테두리만 있는 형태로 표시됩니다.
public struct SegmentedControl: View {
    // MARK: - Types
    /// 세그먼트 컨트롤의 항목을 나타내는 구조체입니다.
    ///
    /// 각 항목은 이미지(선택 사항)와 텍스트로 구성됩니다.
    public struct Item {
        let image: Image?
        let title: String
        
        /// 세그먼트 항목을 초기화합니다.
        ///
        /// - Parameters:
        ///   - image: 표시할 이미지 (선택 사항)
        ///   - title: 표시할 텍스트
        public init(image: Image? = nil, title: String) {
            self.image = image
            self.title = title
        }
    }
    
    /// 세그먼트 컨트롤의 시각적 스타일을 정의하는 열거형입니다.
    public enum Variant {
        /// 배경이 채워진 스타일
        case solid
        /// 테두리만 있는 스타일
        case outlined
    }
    
    /// 세그먼트 컨트롤의 크기를 정의하는 열거형입니다.
    public enum Size {
        /// 큰 크기
        case large
        /// 중간 크기
        case medium
        /// 작은 크기
        case small
    }
    
    // MARK: - Initializer
    @Binding private var selectedIndex: Int
    private let items: [Item]
    private let onSelect: ((Int) -> Void)?
    
    /// 항목 배열을 이용해 세그먼트 컨트롤을 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedIndex: 현재 선택된 항목의 인덱스 바인딩
    ///   - items: 표시할 항목 배열
    ///   - onSelect: 항목 선택 시 호출될 클로저 (기본값: nil)
    public init(selectedIndex: Binding<Int>, items: [Item], onSelect: ((Int) -> Void)? = nil) {
        _selectedIndex = selectedIndex
        self.items = items
        self.onSelect = onSelect
    }
    
    /// 텍스트 배열을 이용해 세그먼트 컨트롤을 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedIndex: 현재 선택된 항목의 인덱스 바인딩
    ///   - labels: 표시할 텍스트 배열
    ///   - onSelect: 항목 선택 시 호출될 클로저 (기본값: nil)
    public init(selectedIndex: Binding<Int>, labels: [String], onSelect: ((Int) -> Void)? = nil) {
        _selectedIndex = selectedIndex
        items = labels.map { Item(title: $0) }
        self.onSelect = onSelect
    }
    
    // MARK: - Body
    @State private var frameSize: CGSize = .zero
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                SwiftUI.Button {
                    guard selectedIndex != index else { return }
                    withAnimation(.timingCurve(0.25, 1.25, 0.4, 0.99, duration: 0.5)) {
                        selectedIndex = index
                    }
                } label: {
                    HStack(spacing: 4) {
                        items[index].image?
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(buttonForegroundColor(isSelected: selectedIndex == index))
                            .frame(width: buttonIconSize.width, height: buttonIconSize.height)
                            .padding(.vertical, 2)
                        
                        Text(items[index].title)
                            .paragraph(
                                variant: buttonTitleFont,
                                weight: .medium,
                                color: buttonForegroundColor(isSelected: selectedIndex == index)
                            )
                    }
                    .padding(buttonInsets)
                    .frame(width: max(0, buttonWidth))
                    .frame(maxHeight: .infinity)
                    .background {
                        Group {
                            switch variant {
                            case .solid:
                                ZStack {
                                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                                        .foregroundStyle(SwiftUI.Color.semantic(.backgroundElevated))
                                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                                        .foregroundStyle(SwiftUI.Color.semantic(.staticWhite).opacity(0.28))
                                }
                                .shadow(
                                    color: .semantic(.staticBlack).opacity(0.08),
                                    radius: buttonCornerRadius
                                )
                                .offset(x: buttonWidth * CGFloat(selectedIndex), y: 0)
                                .if(index == 0)
                            case .outlined:
                                ZStack {
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomTrailingRadius: index == items
                                            .count - 1 ? buttonCornerRadius : 0,
                                        topTrailingRadius: index == items.count - 1 ? buttonCornerRadius : 0
                                    )
                                    .foregroundStyle(buttonBackgroundColor(
                                        isSelected: selectedIndex ==
                                            index
                                    ))
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomLeadingRadius: index == 0 ? buttonCornerRadius : 0,
                                        bottomTrailingRadius: index == items
                                            .count - 1 ? buttonCornerRadius : 0,
                                        topTrailingRadius: index == items.count - 1 ? buttonCornerRadius : 0
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
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { frameSize = $0 })
        .onChange(of: selectedIndex) { index in
            onSelect?(index)
        }
    }
    
    // MARK: - Modifiers
    private var variant: Variant = .solid
    private var size: Size = .large
    
    /// 세그먼트 컨트롤의 시각적 스타일을 설정합니다.
    ///
    /// - Parameter variant: 적용할 스타일 (.solid 또는 .outlined)
    /// - Returns: 수정된 세그먼트 컨트롤 인스턴스
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 세그먼트 컨트롤의 크기를 설정합니다.
    ///
    /// - Parameter size: 적용할 크기 (.large, .medium, 또는 .small)
    /// - Returns: 수정된 세그먼트 컨트롤 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
}

// MARK: - Private
extension SegmentedControl {
    private var backgroundColor: SwiftUI.Color {
        switch variant {
        case .solid: .semantic(.fillNormal)
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
        (frameSize.width - (insets.leading + insets.trailing)) / CGFloat(items.count)
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
    
    private func buttonForegroundColor(isSelected: Bool) -> SwiftUI.Color {
        switch variant {
        case .solid: .semantic(isSelected ? .labelNormal : .labelAlternative)
        case .outlined: .semantic(isSelected ? .primaryNormal : .labelAlternative)
        }
    }
    
    private func buttonBackgroundColor(isSelected: Bool) -> SwiftUI.Color {
        switch variant {
        case .solid: .clear
        case .outlined: isSelected ? .semantic(.primaryNormal).opacity(0.05) : .clear
        }
    }
    
    private func buttonBorderColor(isSelected: Bool) -> SwiftUI.Color {
        switch variant {
        case .solid: .clear
        case .outlined: isSelected ? .semantic(.primaryNormal).opacity(0.43) : .semantic(.lineNormal)
        }
    }
}

import Pretendard
struct SegmentControl_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    static var previews: some View {
        _ = try? Pretendard.registerFonts()
        return VStack {
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            .size(.medium)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            .size(.small)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            .variant(.outlined)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            .variant(.outlined)
            .size(.medium)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(title: "Web"),
                    .init(title: "ETC")
                ],
                onSelect: { _ in }
            )
            .variant(.outlined)
            .size(.small)
        }
        .padding()
    }
}
