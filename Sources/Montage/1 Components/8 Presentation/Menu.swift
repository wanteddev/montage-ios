//
//  Menu.swift
//  Montage
//
//  Created by 김삼열 on 2/5/25.
//

import SwiftUI

/// 드롭다운이나 컨텍스트 메뉴로 사용할 수 있는 메뉴 컴포넌트입니다.
///
/// 일반, 라디오 버튼, 체크박스 형태로 메뉴 항목을 표시할 수 있으며,
/// 메뉴 하단에 추가 액션 영역을 포함할 수 있습니다.
///
/// ```swift
/// // 기본 메뉴
/// @State private var items: [Menu.Item] = [
///     .init(title: "항목 1"),
///     .init(title: "항목 2"),
///     .init(title: "항목 3")
/// ]
///
/// Menu(
///     variant: .normal,
///     items: $items,
///     onSelectCell: { item in
///         print("선택된 항목: \(item.title)")
///     }
/// )
///
/// // 라디오 메뉴 (단일 선택)
/// @State private var radioItems: [Menu.Item] = [
///     .init(title: "옵션 1", isSelected: true),
///     .init(title: "옵션 2"),
///     .init(title: "옵션 3")
/// ]
///
/// Menu(
///     variant: .radio,
///     items: $radioItems
/// )
/// ```
public struct Menu: View {
    /// 메뉴의 표시 형태를 정의하는 열거형입니다.
    public enum Variant {
        /// 기본 메뉴 형태, 선택 표시 없이 항목만 표시
        case normal
        /// 라디오 버튼 형태, 단일 항목만 선택 가능
        case radio
        /// 체크박스 형태, 다중 항목 선택 가능
        case checkbox
    }
    
    /// 메뉴 항목의 데이터를 정의하는 구조체입니다.
    ///
    /// 제목과 선택 상태를 포함합니다.
    ///
    /// ```swift
    /// Menu.Item(title: "메뉴 항목", isSelected: false)
    /// ```
    public struct Item: Equatable {
        public let title: String
        public var isSelected: Bool
        
        /// 메뉴 항목을 초기화합니다.
        ///
        /// - Parameters:
        ///   - title: 메뉴 항목에 표시될 텍스트
        ///   - isSelected: 초기 선택 상태 (기본값: false)
        public init(title: String, isSelected: Bool = false) {
            self.title = title
            self.isSelected = isSelected
        }
    }
    
    private let variant: Variant
    @Binding private var items: [Item]
    private let onSelectCell: ((Item) -> Void)?
    private let cellModifier: (_ index: Int, _ cell: Cell) -> Cell
    
    /// 메뉴 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - variant: 메뉴의 표시 형태 (normal, radio, checkbox)
    ///   - items: 메뉴 항목 배열에 대한 바인딩
    ///   - onSelectCell: 항목 선택 시 호출될 클로저 (선택 사항)
    ///   - cellModifier: 각 셀을 커스터마이징하기 위한 클로저 (기본값: 수정 없음)
    public init(
        variant: Variant,
        items: Binding<[Item]>,
        onSelectCell: ((Item) -> Void)? = nil,
        cellModifier: @escaping (_ index: Int, _ cell: Cell) -> Cell = { _, cell in cell }
    ) {
        self.variant = variant
        _items = items
        self.onSelectCell = onSelectCell
        self.cellModifier = cellModifier
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            SwiftUI.ScrollView {
                VStack(spacing: 4) {
                    ForEach(items.indices, id: \.self) { index in
                        cellModifier(index, Cell(title: items[index].title, onTap: {
                            switch variant {
                            case .radio:
                                items = items.map {
                                    var mutated = $0
                                    mutated.isSelected = false
                                    return mutated
                                }
                                fallthrough
                            case .checkbox:
                                items[index].isSelected.toggle()
                            default: break
                            }
                            onSelectCell?(items[index])
                        }))
                        .leadingContent {
                            Group {
                                switch variant {
                                case .radio:
                                    Control.radio(checked: items[index].isSelected)
                                case .checkbox:
                                    Control.checkbox(checked: items[index].isSelected)
                                default:
                                    EmptyView()
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
            
            if menuActionArea {
                HStack(spacing: 0) {
                    AnyView(menuActionAreaLeadingContent())
                        .frame(alignment: .leading)
                    Spacer(minLength: 24)
                    AnyView(menuActionAreaTrailingContent())
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .frame(height: 56)
                .background(SwiftUI.Color.semantic(.backgroundElevated))
                .overlay {
                    Rectangle()
                        .strokeBorder(SwiftUI.Color.semantic(.lineSolidAlternative), lineWidth: 1)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(SwiftUI.Color.semantic(.lineSolidNeutral), lineWidth: 1)
                .shadow(color: .semantic(.staticBlack).opacity(0.04), radius: 1, x: 0, y: 1)
        }
        .padding(.vertical, 8)
    }
    
    private var menuActionArea = false
    private var menuActionAreaLeadingContent: () -> any View = { EmptyView() }
    private var menuActionAreaTrailingContent: () -> any View = { EmptyView() }
    
    /// 메뉴 하단에 액션 버튼 영역을 추가합니다.
    ///
    /// 왼쪽과 오른쪽에 버튼이나 다른 뷰를 배치할 수 있습니다.
    ///
    /// ```swift
    /// Menu(variant: .normal, items: $items)
    ///     .menuActionArea(
    ///         leadingContent: {
    ///             Button.transparent(text: "취소")
    ///         },
    ///         trailingContent: {
    ///             Button.filled(text: "확인")
    ///         }
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - leadingContent: 왼쪽에 표시할 콘텐츠를 반환하는 클로저
    ///   - trailingContent: 오른쪽에 표시할 콘텐츠를 반환하는 클로저
    /// - Returns: 액션 영역이 추가된 Menu
    public func menuActionArea(
        leadingContent: @escaping () -> any View,
        trailingContent: @escaping () -> any View
    ) -> Self {
        var zelf = self
        zelf.menuActionArea = true
        zelf.menuActionAreaLeadingContent = leadingContent
        zelf.menuActionAreaTrailingContent = trailingContent
        return zelf
    }
}
