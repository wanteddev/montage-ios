//
//  Tab.swift
//  Montage
//
//  Created by 김삼열 on 11/14/24.
//

import SwiftUI

public struct Tab: View {
    // MARK: - Types
    /// 탭 아이템 너비를 결정하는 열거형입니다.
    public enum Resize {
        case normal, fill
    }
    
    /// 탭 아이템의 크기를 결정하는 열거형입니다.
    public enum Size {
        case small, meidum, large
    }

    // MARK: - Initializer
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
        self.itemWidths = .init(repeating: 0, count: items.count)
        self.actions = actions
    }
    
    // MARK: - Body
    @State private var contentOffset: CGPoint = .zero
    @State private var contentWidth: CGFloat = .zero
    @State private var scrollViewWidth: CGFloat = .zero
    @State private var needsLeftGradient = false
    @State private var needsRightGradient = false
    @State private var itemWidths: [CGFloat] = []
    
    private let gradientColors = {
        [1.0, 0.86, 0.73, 0.62 ,0.52, 0.43, 0.35, 0.29, 0.23, 0.18, 0.14, 0.1, 0.07, 0.04, 0.02, 0.0].map {
            SwiftUI.Color.black.opacity($0)
        }
    }()
    private let gradientWidth: CGFloat = 48
    private let animation: Animation = .timingCurve(0.25, 0.1, 0.25, 1, duration: 0.3)
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack(spacing: 0) {
                ScrollViewReader { reader in
                    HStack(spacing: 0) {
                        HStack(spacing: 0) {
                            ZStack(alignment: .bottomLeading) {
                                HStack(spacing: resize == .normal ? 24 : 0) {
                                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                        ItemView(
                                            resize: resize,
                                            size: size,
                                            isSelected: index == selectedIndex,
                                            title: item
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(animation) {
                                                selectedIndex = index
                                            }
                                            actions(index)
                                        }
                                        .readSize(onChange: {
                                            if itemWidths.count > index {
                                                itemWidths[index] = $0.width
                                            }
                                        })
                                    }
                                }
                                Divider()
                                    .frame(width: itemWidths[safe: selectedIndex] ?? 0, height: 2)
                                    .background(SwiftUI.Color.alias(.labelStrong))
                                    .offset(x: itemWidths.enumerated()
                                        .filter { $0.offset < selectedIndex }
                                        .reduce(0) { $0 + $1.element + (resize == .normal ? 24 : 0) }
                                    )
                            }
                            Spacer(minLength: 0)
                                .if(resize == .normal)
                        }
                        .if(resize == .normal) {
                            $0.padding(.leading, padding ? 20 : 0)
                                .padding(.trailing, padding || icon != nil ? 20 : 0)
                        }
                        .readSize(onChange: {
                            contentWidth = $0.width
                        })
                        .scrollable(.horizontal, contentOffset: $contentOffset)
                        .readSize(onChange: {
                            scrollViewWidth = $0.width
                        })
                        .mask {
                            gradientEdge()
                                .if(resize == .normal) {
                                    $0.padding(.trailing, icon != nil ? 20 : 0)
                                }
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
                    
                        if resize == .normal, let icon, let iconButtonAction {
                            Button.IconButton(icon: icon) {
                                iconButtonAction()
                            }
                            .padding(.trailing, padding ? 16 : 0)
                        }
                    }
                }
            }
            
            Rectangle()
                .fill(SwiftUI.Color.alias(.lineAlternative))
                .frame(height: 1)
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
    private var resize: Resize = .normal
    private var size: Size = .small
    private var padding = false
    private var icon: Icon? = nil
    private var iconButtonAction: (() -> Void)?
    
    public func resize(_ resize: Resize) -> Self {
        var zelf = self
        zelf.resize = resize
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
    
    public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self {
        var zelf = self
        zelf.icon = icon
        zelf.iconButtonAction = action
        return zelf
    }

    // MARK: - Inner View
    fileprivate struct ItemView: View {
        let resize: Resize
        let size: Size
        let isSelected: Bool
        let title: String

        @State private var itemWidth: CGFloat = 0

        var body: some View {
            ZStack(alignment: .bottom) {
                Text(title)
                    .montage(
                        variant: itemFontVariant,
                        weight: .bold,
                        alias: isSelected ? .labelStrong : .labelAssistive
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .readSize(onChange: {
                        itemWidth = $0.width
                    })
                    .frame(height: itemHeight)
                
                SwiftUI.Color.clear
                    .if(resize == .normal) {
                        $0.frame(width: itemWidth)
                    }
            }
        }
    }
}

// MARK: - Private
extension Tab.ItemView {
    var itemHeight: CGFloat {
        switch size {
        case .small: 40
        case .meidum: 48
        case .large: 56
        }
    }
    
    var itemFontVariant: Typography.Variant {
        switch size {
        case .small: .body2
        case .meidum: .headline2
        case .large: .heading2
        }
    }
}
