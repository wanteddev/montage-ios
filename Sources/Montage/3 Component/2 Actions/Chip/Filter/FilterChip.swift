//
//  Filter.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import Pretendard
import SwiftUI

extension Chip {
    /// 필터링 기능을 제공하는 칩 컴포넌트입니다.
    ///
    /// 이 컴포넌트는 사용자가 항목을 필터링하는 데 사용할 수 있는 탭 가능한 UI 요소입니다.
    /// 다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있습니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// // 기본 필터 칩
    /// Chip.Filter(
    ///     variant: .solid,
    ///     size: .medium,
    ///     text: "카테고리",
    ///     handler: { toggleFilter() }
    /// )
    ///
    /// // 활성화된 확장 가능한 필터 칩
    /// Chip.Filter(
    ///     variant: .outlined,
    ///     text: "정렬",
    ///     state: .expand,
    ///     active: true,
    ///     activeLabel: "최신순"
    /// )
    /// ```
    public struct Filter: UIViewRepresentable {
        /// 칩의 외관 스타일을 정의합니다.
        ///
        /// - `.solid`: 배경색이 채워진 스타일
        /// - `.outlined`: 테두리만 있는 스타일
        public enum Variant {
            case solid, outlined
        }
        
        /// 칩의 확장 상태를 정의합니다.
        ///
        /// - `.normal`: 기본 상태
        /// - `.expand`: 확장된 상태 (드롭다운 표시)
        public enum State {
            case normal
            case expand
        }
        
        /// 칩의 크기를 정의합니다.
        ///
        /// - `.xsmall`: 가장 작은 크기
        /// - `.small`: 작은 크기
        /// - `.medium`: 중간 크기
        /// - `.large`: 큰 크기
        public enum Size {
            case xsmall, small, medium, large
        }
        
        /// 칩의 외관 스타일입니다.
        public var variant: Variant = .solid
        
        /// 칩의 크기입니다.
        public var size: Size = .medium
        
        /// 칩에 표시할 텍스트입니다.
        public var text = ""
        
        /// 칩의 확장 상태입니다.
        public var state: State = .normal
        
        /// 칩의 상호작용 상태입니다.
        public var interactionState: Decorate.Interaction.State = .normal
        
        /// 칩의 활성화 상태입니다.
        public var active = false
        
        /// 활성화 상태일 때 표시할 레이블입니다.
        public var activeLabel: String? = nil
        
        /// 칩의 비활성화 상태입니다.
        public var disable = false
        
        /// 아이콘 색상입니다.
        public var iconColor: SwiftUI.Color? = nil
        
        /// 텍스트 색상입니다.
        public var fontColor: SwiftUI.Color? = nil
        
        /// 칩 클릭 시 실행할 핸들러입니다.
        public var handler: (() -> Void)?
        
        public typealias UIViewType = FilterUIView
        
        /// 필터 칩 컴포넌트를 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 칩의 외관 스타일, 기본값은 `.solid`
        ///   - size: 칩의 크기, 기본값은 `.medium`
        ///   - text: 칩에 표시할 텍스트
        ///   - state: 칩의 확장 상태, 기본값은 `.normal`
        ///   - interactionState: 칩의 상호작용 상태, 기본값은 `.normal`
        ///   - active: 칩의 활성화 상태, 기본값은 `false`
        ///   - activeLabel: 활성화 상태일 때 표시할 레이블, 기본값은 `nil`
        ///   - disable: 칩의 비활성화 상태, 기본값은 `false`
        ///   - iconColor: 아이콘 색상, 기본값은 `nil`
        ///   - fontColor: 텍스트 색상, 기본값은 `nil`
        ///   - handler: 칩 클릭 시 실행할 핸들러, 기본값은 `nil`
        /// - Returns: 구성된 필터 칩 인스턴스
        public init(
            variant: Variant = .solid,
            size: Size = .medium,
            text: String,
            state: State = .normal,
            interactionState: Decorate.Interaction.State = .normal,
            active: Bool = false,
            activeLabel: String? = nil,
            disable: Bool = false,
            iconColor: SwiftUI.Color? = nil,
            fontColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.interactionState = interactionState
            self.active = active
            self.activeLabel = activeLabel
            self.disable = disable
            self.iconColor = iconColor
            self.fontColor = fontColor
            self.handler = handler
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.text = text
            uiView.state = state
            uiView.interactionState = interactionState
            uiView.active = active
            uiView.activeLabel = activeLabel
            uiView.disable = disable
            if let iconColor {
                uiView.iconUIColor = iconColor.uiColor
            } else {
                uiView.iconUIColor = nil
            }
            if let fontColor {
                uiView.fontUIColor = fontColor.uiColor
            } else {
                uiView.fontUIColor = nil
            }
            uiView.handler = handler
        }
        
        public func sizeThatFits(
            _ proposal: ProposedViewSize,
            uiView: UIViewType,
            context _: Context
        ) -> CGSize? {
            CGSize(
                width: fillHorizontal ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillVertical ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        private var fillHorizontal = false
        private var fillVertical = false
        
        /// 칩이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.
        ///
        /// - Parameters:
        ///   - fillHorizontal: 수평 방향 채우기 여부
        ///   - fillVertical: 수직 방향 채우기 여부
        /// - Returns: 수정된 필터 칩 인스턴스
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
    }
}

extension Chip.Filter.Variant {
    var backgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.fillAlternative)
        case .outlined:
            .clear
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .solid:
            .zero
        case .outlined:
            1
        }
    }
    
    var disableBackgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.interactionDisable)
        case .outlined:
            .clear
        }
    }
    
    var activeBackgroundColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseBackground)
        case .outlined:
            .semantic(.primaryNormal).withAlphaComponent(0.05)
        }
    }
    
    var activeTextUIColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseLabel)
        case .outlined:
            .semantic(.primaryNormal)
        }
    }
    
    var activeArrowColor: UIColor {
        switch self {
        case .solid:
            .semantic(.inverseLabel)
        case .outlined:
            .semantic(.labelNormal)
        }
    }
}

extension Chip.Filter.State {
    var icon: Icon {
        switch self {
        case .normal:
            .caretDown
        case .expand:
            .caretUp
        }
    }
}

extension Chip.Filter.Size {
    var iconSize: CGSize {
        switch self {
        case .large:
            .init(width: 16, height: 16)
        case .medium:
            .init(width: 16, height: 16)
        case .small:
            .init(width: 16, height: 16)
        case .xsmall:
            .init(width: 12, height: 12)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch self {
        case .large:
            .body2
        case .medium:
            .body2
        case .small:
            .label1
        case .xsmall:
            .caption1
        }
    }
    
    var contentsEdgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            .init(top: 9, left: 12, bottom: 9, right: 10)
        case .medium:
            .init(top: 7, left: 11, bottom: 7, right: 9)
        case .small:
            .init(top: 6, left: 8, bottom: 6, right: 6)
        case .xsmall:
            .init(top: 4, left: 7, bottom: 4, right: 5)
        }
    }
    
    var contentsGap: CGFloat {
        switch self {
        case .large:
            2.0
        case .medium:
            2.0
        case .small:
            1.0
        case .xsmall:
            1.0
        }
    }
    
    var contentsPadding: CGFloat {
        switch self {
        case .medium: 2.0
        case .small: 2.0
        case .large: 2.0
        case .xsmall: 1.0
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .large:
            10.0
        case .medium:
            10.0
        case .small:
            8.0
        case .xsmall:
            6.0
        }
    }
}
