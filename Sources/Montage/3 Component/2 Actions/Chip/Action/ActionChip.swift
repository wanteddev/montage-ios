//
//  Action.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import Pretendard
import SwiftUI

extension Chip {
    /// 액션 실행을 위한 칩 컴포넌트입니다.
    ///
    /// 이 컴포넌트는 사용자가 간단한 액션을 수행할 수 있는 콤팩트한 UI 요소입니다.
    /// 다양한 크기와 스타일을 지원하며, 활성/비활성 상태를 표시할 수 있고 이미지를 추가할 수 있습니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// // 기본 액션 칩
    /// Chip.Action(
    ///     variant: .solid,
    ///     size: .medium,
    ///     text: "태그 추가",
    ///     handler: { addTag() }
    /// )
    ///
    /// // 이미지가 있는 액션 칩
    /// Chip.Action(
    ///     variant: .outlined,
    ///     text: "공유",
    ///     active: true
    /// )
    /// .leadingImage(Image(systemName: "share"))
    /// .imageColor(.blue)
    /// ```
    public struct Action: UIViewRepresentable {
        /// 칩의 외관 스타일을 정의합니다.
        ///
        /// - `.solid`: 배경색이 채워진 스타일
        /// - `.outlined`: 테두리만 있는 스타일
        public enum Variant {
            case solid, outlined
        }
        
        /// 칩의 크기를 정의합니다.
        ///
        /// - `.xsmall`: 가장 작은 크기
        /// - `.small`: 작은 크기
        /// - `.medium`: 중간 크기
        /// - `.large`: 큰 크기
        public enum Size: String {
            case xsmall, small, medium, large
        }
        
        /// 칩의 외관 스타일입니다.
        public var variant: Variant = .solid
        
        /// 칩의 크기입니다.
        public var size: Size = .medium
        
        /// 칩에 표시할 텍스트입니다.
        public var text = ""
        
        /// 칩의 상호작용 상태입니다.
        public var state: Decorate.Interaction.State = .normal
        
        /// 칩의 비활성화 상태입니다.
        public var disable = false
        
        /// 칩의 활성화 상태입니다.
        public var active = false
        
        /// 배경 색상입니다. nil인 경우 기본 색상이 사용됩니다.
        public var backgroundColor: SwiftUI.Color? = nil
        
        /// 텍스트 색상입니다. nil인 경우 기본 색상이 사용됩니다.
        public var fontColor: SwiftUI.Color? = nil
        
        /// 활성화 상태일 때의 색상입니다. nil인 경우 기본 색상이 사용됩니다.
        public var activeColor: SwiftUI.Color? = nil
        
        /// 칩 클릭 시 실행할 핸들러입니다.
        public var handler: (() -> Void)?
        
        public typealias UIViewType = ActionUIView
        
        /// 액션 칩 컴포넌트를 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 칩의 외관 스타일, 기본값은 `.solid`
        ///   - size: 칩의 크기, 기본값은 `.medium`
        ///   - text: 칩에 표시할 텍스트
        ///   - state: 칩의 상호작용 상태, 기본값은 `.normal`
        ///   - disable: 칩의 비활성화 상태, 기본값은 `false`
        ///   - active: 칩의 활성화 상태, 기본값은 `false`
        ///   - backgroundColor: 배경 색상, 기본값은 `nil`
        ///   - fontColor: 텍스트 색상, 기본값은 `nil`
        ///   - activeColor: 활성화 상태일 때의 색상, 기본값은 `nil`
        ///   - handler: 칩 클릭 시 실행할 핸들러, 기본값은 `nil`
        /// - Returns: 구성된 액션 칩 인스턴스
        public init(
            variant: Variant = .solid,
            size: Size = .medium,
            text: String,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            active: Bool = false,
            backgroundColor: SwiftUI.Color? = nil,
            fontColor: SwiftUI.Color? = nil,
            activeColor: SwiftUI.Color? = nil,
            handler: ( () -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.text = text
            self.state = state
            self.disable = disable
            self.active = active
            self.backgroundColor = backgroundColor
            self.fontColor = fontColor
            self.activeColor = activeColor
            self.handler = handler
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            if let leadingImage {
                uiView.leadingImage = ImageRenderer(content: leadingImage).uiImage
            }
            if let trailingImage {
                uiView.trailingImage = ImageRenderer(content: trailingImage).uiImage
            }
            uiView.imageColor = imageColor?.uiColor
            uiView.text = text
            uiView.state = state
            uiView.disable = disable
            uiView.active = active
            if let backgroundColor {
                uiView.backgroundUIColor = backgroundColor.uiColor
            } else {
                uiView.backgroundUIColor = nil
            }
            if let fontColor {
                uiView.fontUIColor = fontColor.uiColor
            } else {
                uiView.fontUIColor = nil
            }
            if let activeColor {
                uiView.activeUIColor = activeColor.uiColor
            } else {
                uiView.activeUIColor = nil
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
        private var leadingImage: Image?
        private var trailingImage: Image?
        private var imageColor: SwiftUI.Color?
        
        /// 칩이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.
        ///
        /// - Parameters:
        ///   - fillHorizontal: 수평 방향 채우기 여부
        ///   - fillVertical: 수직 방향 채우기 여부
        /// - Returns: 수정된 액션 칩 인스턴스
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
        
        /// 칩의 좌측에 이미지를 추가합니다.
        ///
        /// - Parameter image: 표시할 이미지
        /// - Returns: 수정된 액션 칩 인스턴스
        public func leadingImage(_ image: Image) -> Self {
            var zelf = self
            zelf.leadingImage = image
            return zelf
        }
        
        /// 칩의 우측에 이미지를 추가합니다.
        ///
        /// - Parameter image: 표시할 이미지
        /// - Returns: 수정된 액션 칩 인스턴스
        public func trailingImage(_ image: Image) -> Self {
            var zelf = self
            zelf.trailingImage = image
            return zelf
        }
        
        /// 이미지의 색상을 설정합니다.
        ///
        /// - Parameter color: 이미지에 적용할 색상
        /// - Returns: 수정된 액션 칩 인스턴스
        /// - Note: 기본값은 `.semantic(.labelAlternative)`입니다.
        public func imageColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.imageColor = color
            return zelf
        }
    }
}
