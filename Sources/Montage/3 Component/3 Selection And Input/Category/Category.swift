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
    @State private var contentOffset: CGPoint = .zero
    @State private var contentWidth: CGFloat = .zero
    @State private var scrollViewWidth: CGFloat = .zero
    @State private var needsLeftGradient = false
    @State private var needsRightGradient = false
    
    private let gradientColors = {
        [1.0, 0.86, 0.73, 0.62, 0.52, 0.43, 0.35, 0.29, 0.23, 0.18, 0.14, 0.1, 0.07, 0.04, 0.02, 0.0].map {
            SwiftUI.Color.black.opacity($0)
        }
    }()
    
    private let gradientWidth: CGFloat = 48
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
                .padding(.leading, padding ? 20 : 0)
                .padding(.trailing, padding || icon != nil ? 20 : 0)
                .onGeometryChange(
                    for: CGSize.self,
                    of: { $0.size },
                    action: { contentWidth = $0.width }
                )
                .scrollable(.horizontal, contentOffset: $contentOffset)
                .onGeometryChange(
                    for: CGSize.self,
                    of: { $0.size },
                    action: { scrollViewWidth = $0.width }
                )
                .mask {
                    gradientEdge()
                        .padding(.trailing, icon != nil ? 20 : 0)
                }
                
                if let icon, let iconButtonAction {
                    Button.IconButton(icon: icon) {
                        iconButtonAction()
                    }
                    .padding(.trailing, padding ? 16 : 0)
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
            .onChange(of: contentOffset) { _ in
                withAnimation(animation) {
                    setNeedsGradientIfNeeded()
                }
            }
            .onChange(of: contentWidth) { _ in
                setNeedsGradientIfNeeded()
            }
        }
    }
    
    private func gradientEdge() -> some View {
        HStack(spacing: 0) {
            Group {
                if needsLeftGradient {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .init(x: 1, y: 0),
                        endPoint: .init(x: 0, y: 0)
                    )
                } else {
                    Rectangle()
                }
            }
            .frame(width: gradientWidth)
            
            Rectangle()
                .frame(maxWidth: .infinity)
            
            Group {
                if needsRightGradient {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .init(x: 0, y: 0),
                        endPoint: .init(x: 1, y: 0)
                    )
                } else {
                    Rectangle()
                }
            }
            .frame(width: gradientWidth)
        }
        .allowsHitTesting(false)
    }

    private func setNeedsGradientIfNeeded() {
        if -contentOffset.x + scrollViewWidth < contentWidth {
            needsRightGradient = true
        } else {
            needsRightGradient = false
        }

        if contentOffset.x < 0 {
            needsLeftGradient = true
        } else {
            needsLeftGradient = false
        }
        
        if padding {
            needsLeftGradient = false
            needsRightGradient = needsRightGradient && (icon != nil)
        }
    }
    
    // MARK: - Modifiers
    
    private var variant: Variant = .normal
    private var size: Size = .medium
    private var padding = false
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
    
    public func padding(_ padding: Bool = true) -> Self {
        var zelf = self
        zelf.padding = padding
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
    
    // MARK: - private
    
    private var itemSpacing: CGFloat {
        switch size {
        case .small: 4
        case .medium: 6
        case .large: 8
        case .xlarge: 10
        }
    }
    
    private var verticalPaddingValue: CGFloat {
        switch size {
        case .small, .medium: 8
        case .large, .xlarge: 10
        }
    }
    
    // MARK: - Inner View
    
    fileprivate struct ItemView: View {
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
            case .large: .normal
            case .xlarge: .large
            }
        }
    }
}
