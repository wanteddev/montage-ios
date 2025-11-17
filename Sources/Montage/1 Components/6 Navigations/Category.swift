//
//  Category.swift
//  Montage
//
//  Created by 김삼열 on 1/6/25.
//

import SwiftUI

/// 카테고리 선택 옵션을 가로로 나열하는 컴포넌트입니다.
///
/// 사용자가 카테고리 목록에서 하나의 항목을 선택할 수 있는 스크롤 가능한 컴포넌트입니다.
/// 다양한 크기와 스타일을 지원하며, 선택된 항목에 대한 시각적 피드백을 제공합니다.
///
/// ```swift
/// @State private var selectedIndex = 0
/// let categories = ["전체", "디자인", "개발", "마케팅", "경영"]
///
/// Category(
///     selectedIndex: $selectedIndex,
///     items: categories,
///     actions: { index in
///         print("선택된 카테고리: \(categories[index])")
///     }
/// )
/// .variant(.alternative)
/// .size(.medium)
/// .horizontalPadding()
/// ```
public struct Category: View {
    // MARK: - Types
    
    /// 카테고리 아이템의 종류를 결정하는 열거형입니다.
    public enum Variant {
        /// 기본 스타일
        case normal
        /// 대체 스타일
        case alternative
    }
    
    /// 카테고리 사이즈를 결정하는 열거형입니다.
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
        /// 큰 크기
        case xlarge
    }
    
    @Binding private var selectedIndex: Int
    private let items: [String]
    private let itemModifier: (_ index: Int, _ chip: Chip) -> Chip
    private let actions: (Int) -> Void
    
    /// 카테고리 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedIndex: 현재 선택된 항목의 인덱스 바인딩
    ///   - items: 표시할 카테고리 항목 배열
    ///   - itemModifier: 카테고리 항목 수정 클로저, 인덱스와 Chip을 파라미터로 받음, 생략하면 기본값으로 원본 Chip을 반환하는 클로저 적용
    ///   - actions: 항목 선택 시 호출될 클로저, 생략하면 기본값으로 빈 클로저 적용
    public init(
        selectedIndex: Binding<Int>,
        items: [String],
        itemModifier: @escaping (_ index: Int, _ chip: Chip) -> Chip = { $1 },
        actions: @escaping (Int) -> Void = { _ in }
    ) {
        _selectedIndex = selectedIndex
        self.items = items
        self.itemModifier = itemModifier
        self.actions = actions
    }
    
    // MARK: - Body
    
    private let animation: Animation = .timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        ScrollViewReader { reader in
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: itemSpacing) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            Chip(
                                variant: chipVariant(index == selectedIndex),
                                size: chipSize,
                                text: item
                            ) {
                                withAnimation(animation) {
                                    selectedIndex = index
                                }
                                actions(index)
                            }
                            .active(index == selectedIndex)
                            .modifying {
                                itemModifier(index, $0)
                            }
                            .contentShape(Rectangle())
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.leading, horizontalPadding ? 20 : 0)
                .padding(.trailing, horizontalPadding || icon != nil ? 20 : 0)
                .modifier(
                    GradientScrollEdgeModifier(
                        gradientWidth: 48,
                        gradientInsets: EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: icon != nil ? 20 : 0
                        ),
                        leadingGradientDisabled: horizontalPadding,
                        trailingGradientDisabled: horizontalPadding && icon == nil
                    )
                )
                
                if let icon, let iconButtonAction {
                    IconButton(variant: .normal(size: iconSize), icon: icon) {
                        iconButtonAction()
                    }
                    .padding(.trailing, horizontalPadding ? 16 : 0)
                }
            }
            .if(verticalPadding) {
                $0.padding(.vertical, verticalPaddingValue)
            }
            .onChange(of: selectedIndex) { index in
                withAnimation(animation) {
                    reader.scrollTo(index, anchor: .center)
                }
            }
        }
    }
    
    // MARK: - Modifiers
    
    private var variant: Variant = .normal
    private var size: Size = .medium
    private var horizontalPadding = false
    private var verticalPadding = false
    private var icon: Icon? = nil
    private var iconButtonAction: (() -> Void)?
    
    /// 카테고리 아이템 스타일을 설정합니다.
    ///
    /// - Parameter variant: 아이템 스타일 (.normal 또는 .alternative)
    /// - Returns: 수정된 카테고리 인스턴스
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }
    
    /// 카테고리 아이템 크기를 설정합니다.
    ///
    /// - Parameter size: 아이템 크기 (.small, .medium, .large, .xlarge)
    /// - Returns: 수정된 카테고리 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 카테고리 컴포넌트의 좌우 패딩을 설정합니다.
    ///
    /// - Parameter horizontalPadding: 패딩 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 카테고리 인스턴스
    public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.horizontalPadding = horizontalPadding
        return zelf
    }
    
    /// 카테고리 컴포넌트의 상하 패딩을 설정합니다.
    ///
    /// - Parameter verticalPadding: 패딩 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 카테고리 인스턴스
    public func verticalPadding(_ verticalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
    /// 카테고리 컴포넌트 오른쪽에 표시할 아이콘 버튼을 설정합니다.
    ///
    /// - Parameters:
    ///   - icon: 표시할 아이콘
    ///   - action: 버튼 클릭 시 실행할 액션
    /// - Returns: 수정된 카테고리 인스턴스
    public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self {
        var zelf = self
        zelf.icon = icon
        zelf.iconButtonAction = action
        return zelf
    }
}

// MARK: - private
private extension Category {
    var itemSpacing: CGFloat {
        switch size {
        case .small: 4
        case .medium: 6
        case .large: 8
        case .xlarge: 10
        }
    }
    
    var verticalPaddingValue: CGFloat {
        switch size {
        case .small, .medium: 8
        case .large, .xlarge: 10
        }
    }
    
    var iconSize: Int {
        switch size {
        case .small: 20
        case .medium: 22
        default: 24
        }
    }
      
    func chipVariant(_ isSelected: Bool) -> Chip.Variant {
        if variant == .normal && isSelected {
            .solid
        } else {
            .outlined
        }
    }
    
    var chipSize: Chip.Size {
        switch size {
        case .small: .xsmall
        case .medium: .small
        case .large: .medium
        case .xlarge: .large
        }
    }
}
