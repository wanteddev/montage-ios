//
//  Chips.swift
//  Montage
//
//  Created by 김삼열 on 1/6/25.
//

import SwiftUI

public struct Category: View {
    // MARK: - Types
    
    /// 카테고리 아이템의 종류를 결정하는 열거형입니다.
    public enum Variant {
        case normal, alternative
    }
    
    /// 카테고리 사이즈를 결정하는 열거형입니다.
    public enum Size: String, CaseIterable {
        case small, medium, large, xlarge
    }
    
    @Binding private var selectedIndex: Int
    private let items: [String]
    private let actions: (Int) -> Void
    
    public init(
        selectedIndex: Binding<Int>,
        items: [String],
        actions: @escaping (Int) -> Void = { _ in }
    ) {
        _selectedIndex = selectedIndex
        self.items = items
        self.actions = actions
    }
    
    // MARK: - Body
    
    private let animation: Animation = .timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)
    
    public var body: some View {
        ScrollViewReader { reader in
            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    HStack(spacing: itemSpacing) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            ItemView(
                                variant: variant,
                                size: size,
                                isSelected: index == selectedIndex,
                                title: item
                            ) {
                                withAnimation(animation) {
                                    selectedIndex = index
                                }
                                actions(index)
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
    
    public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.horizontalPadding = horizontalPadding
        return zelf
    }
    
    public func verticalPadding(_ verticalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.verticalPadding = verticalPadding
        return zelf
    }
    
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
    
    // MARK: - Inner View
    
    struct ItemView: View {
        let variant: Variant
        let size: Size
        let isSelected: Bool
        let title: String
        let onTap: () -> Void

        var body: some View {
            Chip.Action(variant: chipVariant, size: chipSize, text: title, active: isSelected, handler: onTap)
        }
        
        var chipVariant: Chip.Action.Variant {
            if variant == .normal && isSelected {
                .solid
            } else {
                .outlined
            }
        }
        
        var chipSize: Chip.Action.Size {
            switch size {
            case .small: .xsmall
            case .medium: .small
            case .large: .medium
            case .xlarge: .large
            }
        }
    }
}
