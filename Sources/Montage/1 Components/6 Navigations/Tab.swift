//
//  Tab.swift
//  Montage
//
//  Created by 김삼열 on 11/14/24.
//

import SwiftUI

/// 선택 가능한 탭 메뉴를 표시하는 컴포넌트입니다.
///
/// `Tab`은 여러 항목 중 하나를 선택할 수 있는 수평 탭 메뉴를 제공합니다.
/// 선택된 탭은 하단에 강조 표시되며, 탭 너비와 크기를 다양하게 커스터마이징할 수 있습니다.
///
/// ```swift
/// @State private var selectedTab = 0
/// let tabItems = ["전체", "인기", "최신", "추천"]
///
/// Tab(selectedIndex: $selectedTab, items: tabItems) { index in
///     print("탭 \(index) 선택됨")
/// }
/// .size(.medium)
/// .resize(.fill)
/// .horizontalPadding(true)
/// ```
///
/// - Note: 탭 컴포넌트는 스크롤 가능한 형태로 제공되며, 다수의 탭 항목을 지원합니다.
///   `.resize(.hug)` 설정 시 항목 너비가 콘텐츠에 맞게 조정되고, `.resize(.fill)` 설정 시
///   전체 너비를 균등하게 분할합니다.
public struct Tab: View {
    // MARK: - Types
    /// 탭 아이템 너비를 결정하는 열거형입니다.
    ///
    /// 탭 아이템의 너비가 콘텐츠에 맞게 조정될지, 전체 너비를 균등하게 분할할지 결정합니다.
    ///
    /// ```swift
    /// Tab(selectedIndex: $selectedTab, items: tabItems)
    ///     .resize(.fill) // 균등하게 분할
    /// ```
    ///
    /// - Note: `hug`는 콘텐츠 너비에 맞게 조정되며, `fill`은 사용 가능한 전체 너비를 균등하게 분할합니다.
    public enum Resize {
        /// 콘텐츠 크기에 맞게 탭 아이템의 너비 조정
        case hug
        /// 전체 너비를 균등하게 분할하여 탭 아이템 배치
        case fill
    }
    
    /// 탭 아이템의 크기를 결정하는 열거형입니다.
    ///
    /// 탭 컴포넌트의 높이와 폰트 크기를 결정합니다.
    ///
    /// ```swift
    /// Tab(selectedIndex: $selectedTab, items: tabItems)
    ///     .size(.large) // 큰 크기의 탭
    /// ```
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
    }

    // MARK: - Initializer
    @Binding private var selectedIndex: Int
    private let items: [String]
    private let actions: (Int) -> Void

    /// 탭 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - selectedIndex: 현재 선택된 탭의 인덱스를 바인딩하는 변수
    ///   - items: 탭 항목 텍스트 배열
    ///   - actions: 탭 선택 시 호출되는 클로저, 선택된 인덱스를 파라미터로 받음 (기본값: 빈 클로저)
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
                                HStack(spacing: resize == .hug ? 24 : 0) {
                                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                        ZStack {
                                            Text(item)
                                                .montage(
                                                    variant: itemFontVariant,
                                                    weight: .bold,
                                                    semantic: index == selectedIndex ? .labelStrong :
                                                        .labelAssistive
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
                                            if index >= itemWidths.count {
                                                itemWidths = itemWidths + .init(
                                                    repeating: 0,
                                                    count: items.count - itemWidths.count
                                                )
                                            }
                                            itemWidths[index] = $0.width
                                        })
                                    }
                                }
                                SwiftUI.Divider()
                                    .frame(width: itemWidths[safe: selectedIndex] ?? 0, height: 2)
                                    .background(SwiftUI.Color.semantic(.labelStrong))
                                    .offset(
                                        x: itemWidths.enumerated()
                                            .filter { $0.offset < selectedIndex }
                                            .reduce(0) { $0 + $1.element + (resize == .hug ? 24 : 0) }
                                    )
                            }
                            Spacer(minLength: 0)
                                .if(resize == .hug)
                        }
                        .if(resize == .hug) {
                            $0.padding(.leading, horizontalPadding ? 20 : 0)
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
                        }
                        .onChange(of: selectedIndex) { index in
                            withAnimation(animation) {
                                reader.scrollTo(index, anchor: .center)
                            }
                        }
                    
                        if resize == .hug, let icon, let iconButtonAction {
                            IconButton(variant: .normal(size: iconSize), icon: icon) {
                                iconButtonAction()
                            }
                            .padding(.trailing, horizontalPadding ? 16 : 0)
                        }
                    }
                }
            }
            
            Rectangle()
                .fill(SwiftUI.Color.semantic(.lineAlternative))
                .frame(height: 1)
        }
    }
    
    // MARK: - Modifiers
    private var resize: Resize = .hug
    private var size: Size = .medium
    private var horizontalPadding = false
    private var icon: Icon? = nil
    private var iconButtonAction: (() -> Void)?
    
    /// 탭 아이템의 너비 조정 방식을 설정합니다.
    ///
    /// - Parameters:
    ///   - resize: 탭 아이템 너비 조정 방식
    /// - Returns: 수정된 Tab 인스턴스
    ///
    /// - Note: 기본값은 `.hug`입니다.
    public func resize(_ resize: Resize) -> Self {
        var zelf = self
        zelf.resize = resize
        return zelf
    }
    
    /// 탭 컴포넌트의 크기를 설정합니다.
    ///
    /// - Parameters:
    ///   - size: 적용할 탭 크기
    /// - Returns: 수정된 Tab 인스턴스
    ///
    /// - Note: 기본값은 `.medium`입니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    /// 탭 컴포넌트의 좌우 여백 사용 여부를 설정합니다.
    ///
    /// - Parameters:
    ///   - horizontalPadding: 좌우 여백 사용 여부 (기본값: true)
    /// - Returns: 수정된 Tab 인스턴스
    ///
    /// - Note: 기본값은 `false`입니다. `true`로 설정 시 좌우에 20pt 여백이 적용됩니다.
    public func horizontalPadding(_ horizontalPadding: Bool = true) -> Self {
        var zelf = self
        zelf.horizontalPadding = horizontalPadding
        return zelf
    }
    
    /// 탭 컴포넌트의 오른쪽에 아이콘 버튼을 추가합니다.
    ///
    /// `.resize(.hug)` 모드에서만 표시됩니다.
    ///
    /// - Parameters:
    ///   - icon: 표시할 아이콘
    ///   - action: 아이콘 버튼 탭 시 실행될 클로저
    /// - Returns: 수정된 Tab 인스턴스
    public func iconButton(_ icon: Icon, action: @escaping () -> Void) -> Self {
        var zelf = self
        zelf.icon = icon
        zelf.iconButtonAction = action
        return zelf
    }
}

// MARK: - Private
private extension Tab {
    var itemHeight: CGFloat {
        switch size {
        case .small: 40
        case .medium: 48
        case .large: 56
        }
    }
    
    var itemFontVariant: Typography.Variant {
        switch size {
        case .small: .body2
        case .medium: .headline2
        case .large: .heading2
        }
    }
    
    var iconSize: Int {
        switch size {
        case .small: 20
        case .medium: 22
        default: 24
        }
    }
}
