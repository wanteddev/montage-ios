//
//  ActionChipController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/18.
//

import Pretendard
import SwiftUI

extension Chip {
    public struct ActionChipController: UIViewRepresentable {
        public var variant: Action.Variant = .solid
        public var size: Action.Size = .normal
        public var text = ""
        public var state: Decorate.Interaction.State = .normal
        public var disable = false
        public var active = false
        public var backgroundColor: SwiftUI.Color? = nil
        public var fontColor: SwiftUI.Color? = nil
        public var activeColor: SwiftUI.Color? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = Action
        
        public init(
            variant: Action.Variant = .solid,
            size: Action.Size = .normal,
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
            if let leftImage {
                uiView.leftImage = ImageRenderer(content: leftImage).uiImage
            }
            if let rightImage {
                uiView.rightImage = ImageRenderer(content: rightImage).uiImage
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
        private var leftImage: Image?
        private var rightImage: Image?
        private var imageColor: SwiftUI.Color?
        
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
        
        /// 좌측 이미지를 지정합니다.
        public func leftImage(_ image: Image) -> Self {
            var zelf = self
            zelf.leftImage = image
            return zelf
        }
        
        /// 우측 이미지를 지정합니다.
        public func rightImage(_ image: Image) -> Self {
            var zelf = self
            zelf.rightImage = image
            return zelf
        }
        
        /// 이미지 색상을 지정합니다. 기본값은 .alias(.labelAlternative) 입니다.
        public func imageColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.imageColor = color
            return zelf
        }
    }
}
