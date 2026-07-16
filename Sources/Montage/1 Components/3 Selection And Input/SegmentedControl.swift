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
/// .size(.medium)
///
/// // 아이콘만 표시하는 세그먼트 컨트롤 (세그먼트 너비/높이 고정)
/// SegmentedControl(
///     selectedIndex: $selectedIndex,
///     items: [
///         .init(image: .icon(.home), title: "홈"),
///         .init(image: .icon(.person), title: "프로필")
///     ]
/// )
/// .iconOnly()
/// ```
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
        ///   - image: 표시할 이미지, 생략하면 기본값으로 `nil` 적용
        ///   - title: 표시할 텍스트
        public init(image: Image? = nil, title: String) {
            self.image = image
            self.title = title
        }
    }

    /// 세그먼트 컨트롤의 크기를 정의하는 열거형입니다.
    ///
    /// 크기에 따라 높이, 모서리 반경, 패딩, 타이포그래피, 아이콘 크기가 함께 결정됩니다.
    public enum Size {
        /// 큰 크기 (높이 48)
        case large
        /// 중간 크기 (높이 40)
        case medium
        /// 작은 크기 (높이 32)
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
    ///   - onSelect: 항목 선택 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
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
    ///   - onSelect: 항목 선택 시 호출될 클로저, 생략하면 기본값으로 `nil` 적용
    public init(selectedIndex: Binding<Int>, labels: [String], onSelect: ((Int) -> Void)? = nil) {
        _selectedIndex = selectedIndex
        items = labels.map { Item(title: $0) }
        self.onSelect = onSelect
    }

    // MARK: - Body
    @State private var frameSize: CGSize = .zero

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                SwiftUI.Button {
                    guard selectedIndex != index else { return }
                    withAnimation(.timingCurve(0.25, 1.25, 0.4, 0.99, duration: 0.5)) {
                        selectedIndex = index
                    }
                } label: {
                    HStack(spacing: contentSpacing) {
                        items[index].image?
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(buttonForegroundColor(isSelected: selectedIndex == index))
                            .frame(width: buttonIconSize.width, height: buttonIconSize.height)

                        if !iconOnly {
                            Text(items[index].title)
                                .paragraph(
                                    variant: buttonTitleFont,
                                    weight: .medium,
                                    color: buttonForegroundColor(isSelected: selectedIndex == index)
                                )
                        }
                    }
                    .padding(buttonInsets)
                    .frame(width: max(0, buttonWidth))
                    .frame(maxHeight: .infinity)
                    .accessibilityRemoveTraits(selectedIndex == index ? [] : .isSelected)
                    .accessibilityAddTraits(selectedIndex == index ? .isSelected : [])
                    // iconOnly는 텍스트를 숨겨 VoiceOver가 읽을 라벨이 없으므로 Item 제목을 라벨로 노출한다.
                    .if(iconOnly) {
                        $0.accessibilityLabel(items[index].title)
                    }
                    .background {
                        // 선택 인디케이터(knob)는 단일 뷰가 offset으로 슬라이드한다(index 0에서만 그린다).
                        // 그림자는 pure shape(`.fill`)에 적용해 analytic으로 캐스팅한다(오프스크린 패스 없음).
                        RoundedRectangle(cornerRadius: buttonCornerRadius)
                            .fill(SwiftUI.Color.semantic(.surfaceElevatedPrimary))
                            .shadow(
                                color: SwiftUI.Color(red: 0.09, green: 0.09, blue: 0.09, opacity: 0.1),
                                radius: 2,
                                x: 0,
                                y: 1
                            )
                            .offset(x: buttonWidth * CGFloat(selectedIndex), y: 0)
                            .if(index == 0)
                    }
                }
            }
        }
        .padding(insets)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(backgroundColor)
        }
        .frame(height: frameHeight)
        // iconOnly일 때 세그먼트 너비가 고정되므로 컨텐츠에 맞춰 hug하고,
        // 그 외에는 가용 폭을 균등 분할하도록 maxWidth를 채운다.
        .if(!iconOnly) {
            $0.frame(maxWidth: .infinity)
        }
        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { frameSize = $0 })
        .onChange(of: selectedIndex) { index in
            onSelect?(index)
        }
    }

    // MARK: - Modifiers
    private var size: Size = .large
    private var iconOnly: Bool = false

    /// 세그먼트 컨트롤의 크기를 설정합니다.
    ///
    /// - Parameter size: 적용할 크기
    /// - Returns: 수정된 세그먼트 컨트롤 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// 각 세그먼트를 아이콘만 표시하도록 설정합니다.
    ///
    /// `true`이면 텍스트를 숨기고 아이콘만 표시하며, 각 세그먼트의 너비와 높이가 크기별로 고정됩니다.
    /// 이 경우 각 ``Item``에 이미지를 지정해야 합니다.
    ///
    /// - Parameter iconOnly: 아이콘만 표시할지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 세그먼트 컨트롤 인스턴스
    public func iconOnly(_ iconOnly: Bool = true) -> Self {
        var zelf = self
        zelf.iconOnly = iconOnly
        return zelf
    }
}

// MARK: - Private
extension SegmentedControl {
    private var backgroundColor: SwiftUI.Color {
        .semantic(.surfaceNeutralSecondary)
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

    /// Container 내부 패딩 (모든 사이즈 공통 4)
    private var insets: EdgeInsets {
        .init(top: 4, leading: 4, bottom: 4, trailing: 4)
    }

    /// Container 모서리 반경
    private var cornerRadius: CGFloat {
        switch size {
        case .large:
            14
        case .medium:
            12
        case .small:
            10
        }
    }

    private var buttonWidth: CGFloat {
        if iconOnly {
            return iconOnlySegmentWidth
        }
        return (frameSize.width - (insets.leading + insets.trailing)) / CGFloat(max(1, items.count))
    }

    private var buttonTitleFont: Typography.Variant {
        switch size {
        case .large:
            .body2
        case .medium:
            .label1
        case .small:
            .caption1
        }
    }

    /// 세그먼트 내부(콘텐츠) 패딩 (텍스트 모드). iconOnly는 고정 너비로 간격을 확보하므로 0.
    private var buttonInsets: EdgeInsets {
        guard iconOnly == false else {
            return .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
        switch size {
        case .large:
            return .init(top: 9, leading: 9, bottom: 9, trailing: 9)
        case .medium:
            return .init(top: 7, leading: 8, bottom: 7, trailing: 8)
        case .small:
            return .init(top: 5, leading: 6, bottom: 5, trailing: 6)
        }
    }

    /// 선택 인디케이터(knob) 모서리 반경
    private var buttonCornerRadius: CGFloat {
        switch size {
        case .large:
            10
        case .medium:
            8
        case .small:
            8
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

    /// iconOnly일 때 세그먼트 고정 너비 (아이콘 크기 + 좌우 패딩)
    private var iconOnlySegmentWidth: CGFloat {
        switch size {
        case .large:
            42
        case .medium:
            34
        case .small:
            26
        }
    }

    /// 아이콘-텍스트 간격
    private var contentSpacing: CGFloat {
        switch size {
        case .large, .medium:
            6
        case .small:
            4
        }
    }

    private func buttonForegroundColor(isSelected: Bool) -> SwiftUI.Color {
        .semantic(isSelected ? .foregroundNeutralPrimary : .foregroundNeutralTertiary)
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
                    .init(image: .icon(.apps), title: "ETC")
                ],
                onSelect: { _ in }
            )
            .iconOnly()

            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(image: .icon(.apps), title: "ETC")
                ],
                onSelect: { _ in }
            )
            .iconOnly()
            .size(.medium)

            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [
                    .init(image: .icon(.android), title: "Android"),
                    .init(image: .icon(.logoApple), title: "iOS"),
                    .init(image: .icon(.apps), title: "ETC")
                ],
                onSelect: { _ in }
            )
            .iconOnly()
            .size(.small)
        }
        .padding()
    }
}
