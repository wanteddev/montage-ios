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
        self.actions = actions
    }
    
    // MARK: - Body
    @State private var itemWidths: [CGFloat] = []
    
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
                                        ZStack {
                                            Text(item)
                                                .montage(
                                                    variant: itemFontVariant,
                                                    weight: .bold,
                                                    alias: index == selectedIndex ? .labelStrong : .labelAssistive
                                                )
                                                .multilineTextAlignment(.center)
                                                .frame(height: itemHeight)
                                            
                                            if resize == .fill {
                                                SwiftUI.Color.clear
                                            }
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            withAnimation(animation) {
                                                selectedIndex = index
                                            }
                                            actions(index)
                                        }
                                        .onGeometryChange(for: CGSize.self, of: { $0.size }, action: {
                                            
                                            if itemWidths.count > index {
                                                itemWidths[index] = $0.width
                                            } else {
                                                itemWidths = .init(repeating: 0, count: items.count)
                                            }
                                        })
                                    }
                                }
                                Divider()
                                    .frame(width: itemWidths[safe: selectedIndex] ?? 0, height: 2)
                                    .background(SwiftUI.Color.alias(.labelStrong))
                                    .offset(
                                        x: itemWidths.enumerated()
                                            .filter { $0.offset < selectedIndex }
                                            .reduce(0) { $0 + $1.element + (resize == .normal ? 24 : 0) }
                                    )
                            }
                            Spacer(minLength: 0)
                                .if(resize == .normal)
                        }
                        .if(resize == .normal) {
                            $0.padding(.leading, horizontalPadding ? 20 : 0)
                                .padding(.trailing, horizontalPadding || icon != nil ? 20 : 0)
                                .modifier(
                                    GradientScrollEdgeModifier(
                                        gradientWidth: 48,
                                        gradientInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: icon != nil ? 20 : 0),
                                        leftGradientDisabled: horizontalPadding,
                                        rightGradientDisabled: horizontalPadding && icon == nil
                                    )
                                )
                        }
                        .onChange(of: selectedIndex) { index in
                            withAnimation(animation) {
                                reader.scrollTo(index, anchor: .center)
                            }
                        }
                    
                        if resize == .normal, let icon, let iconButtonAction {
                            Button.IconButton(icon: icon) {
                                iconButtonAction()
                            }
                            .padding(.trailing, horizontalPadding ? 16 : 0)
                        }
                    }
                }
            }
            
            Rectangle()
                .fill(SwiftUI.Color.alias(.lineAlternative))
                .frame(height: 1)
        }
    }
    
    // MARK: - Modifiers
    private var resize: Resize = .normal
    private var size: Size = .small
    private var horizontalPadding = false
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
    
    public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.horizontalPadding = horizontalPadding
        return zelf
    }
    
    public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self {
        var zelf = self
        zelf.icon = icon
        zelf.iconButtonAction = action
        return zelf
    }
}

// MARK: - Private
extension Tab {
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
