//
//  ContentBadgeController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import Pretendard
import SwiftUI

extension Badge {
    public struct ContentBadgeController: UIViewRepresentable {
        /// 뱃지의 외관입니다.
        public var variant: Badge.Content.Variant
        
        /// 뱃지의 사이즈입니다.
        public var size: Badge.Content.Size
        
        /// 뱃지에 사용될 색상 스타일입니다.
        public var color: Badge.Content.ColorStyle
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        public var leftIcon: Image?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var rightIcon: Image?
        
        /// 버튼에서 표현될 텍스트입니다.
        public var text: String
        
        public typealias UIViewType = Badge.Content
        
        public init(
            variant: Badge.Content.Variant = .solid,
            size: Badge.Content.Size = .medium,
            color: Badge.Content.ColorStyle = .neutral,
            leftIcon: Image? = nil,
            rightIcon: Image? = nil,
            text: String
        ) {
            self.variant = variant
            self.size = size
            self.color = color
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.colorStyle = color
            uiView.leftIcon = ImageRenderer(content: leftIcon).uiImage
            uiView.rightIcon = ImageRenderer(content: rightIcon).uiImage
            uiView.text = text
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
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
    }
}

fileprivate struct Preview: View {
    @State var text = "안녕하세요"

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Variant").montage(variant: .headline2)

            HStack {
                Badge.ContentBadgeController(
                    variant: .solid, text: text
                )

                Badge.ContentBadgeController(
                    variant: .outlined, text: text
                )
            }

            Text("Size").montage(variant: .headline2)

            HStack {
                Badge.ContentBadgeController(
                    variant: .solid, size: .normal, text: text
                )

                Badge.ContentBadgeController(
                    variant: .outlined, size: .normal, text: text
                )

                Badge.ContentBadgeController(
                    variant: .solid, size: .medium, text: text
                )

                Badge.ContentBadgeController(
                    variant: .outlined, size: .medium, text: text
                )
            }
    
            Text("Accents").montage(variant: .headline2)
    
            Text("Solid").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.primary),
                        leftIcon: .montage(.circleInfoFill),
                        text: "중요"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.positive),
                        leftIcon: .montage(.circleCheckFill),
                        text: "긍정"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.cautionary),
                        leftIcon: .montage(.circleExclamationFill),
                        text: "경고"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.negative),
                        leftIcon: .montage(.circleClose),
                        text: "에러"
                    )
                }
    
                HStack {
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.lime),
                        rightIcon: Image(systemName: "rectangle.fill"),
                        text: "라임"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.cyan),
                        rightIcon: Image(systemName: "rectangle.fill"),
                        text: "시안"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.lightBlue),
                        rightIcon: Image(systemName: "rectangle.fill"),
                        text: "라이트 블루"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.violet),
                        rightIcon: Image(systemName: "rectangle.fill"),
                        text: "바이올렛"
                    )
    
                    Badge.ContentBadgeController(
                        variant: .solid,
                        color: .accent(.pink),
                        rightIcon: Image(systemName: "rectangle.fill"),
                        text: "핑크"
                    )
                }
            }
    
            Text("Outlined").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.primary), text: "중요"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.positive), text: "긍정"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.cautionary), text: "경고"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.negative), text: "에러"
                    )
                }
                
                HStack {
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.lime), text: "라임"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.cyan), text: "시안"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.lightBlue), text: "라이트 블루"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.violet), text: "바이올렛"
                    )
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.pink), text: "핑크"
                    )
                }
            }
        }
    }
}

struct ContentBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .padding()
            .background(SwiftUI.Color(.alias(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
