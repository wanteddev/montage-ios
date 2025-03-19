//
//  Content.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import SwiftUI

extension Badge {
    public struct Content: UIViewRepresentable {
        /// 뱃지의 외관입니다.
        public var variant: Badge.ContentUIView.Variant
        
        /// 뱃지의 사이즈입니다.
        public var size: Badge.ContentUIView.Size
        
        /// 뱃지에 사용될 색상 스타일입니다.
        public var color: Badge.ContentUIView.ColorStyle
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        public var leadingIcon: Image?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var trailingIcon: Image?
        
        /// 버튼에서 표현될 텍스트입니다.
        public var text: String
        
        public typealias UIViewType = Badge.ContentUIView
        
        public init(
            variant: Badge.ContentUIView.Variant = .solid,
            size: Badge.ContentUIView.Size = .medium,
            color: Badge.ContentUIView.ColorStyle = .neutral,
            leadingIcon: Image? = nil,
            trailingIcon: Image? = nil,
            text: String
        ) {
            self.variant = variant
            self.size = size
            self.color = color
            self.leadingIcon = leadingIcon
            self.trailingIcon = trailingIcon
            self.text = text
        }
        
        public func makeUIView(context _: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.colorStyle = color
            uiView.leadingIcon = ImageRenderer(content: leadingIcon).uiImage
            uiView.trailingIcon = ImageRenderer(content: trailingIcon).uiImage
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
                Badge.Content(
                    variant: .solid, text: text
                )

                Badge.Content(
                    variant: .outlined, text: text
                )
            }

            Text("Size").montage(variant: .headline2)

            HStack {
                Badge.Content(
                    variant: .solid, size: .normal, text: text
                )

                Badge.Content(
                    variant: .outlined, size: .normal, text: text
                )

                Badge.Content(
                    variant: .solid, size: .medium, text: text
                )

                Badge.Content(
                    variant: .outlined, size: .medium, text: text
                )
            }
    
            Text("Accents").montage(variant: .headline2)
    
            Text("Solid").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.primaryNormal)),
                        leadingIcon: .montage(.circleInfoFill),
                        text: "중요"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.statusPositive)),
                        leadingIcon: .montage(.circleCheckFill),
                        text: "긍정"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.statusCautionary)),
                        leadingIcon: .montage(.circleExclamationFill),
                        text: "경고"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.statusNegative)),
                        leadingIcon: .montage(.circleCloseFill),
                        text: "에러"
                    )
                }
    
                HStack {
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.accentBackgroundLime)),
                        trailingIcon: Image(systemName: "rectangle.fill"),
                        text: "라임"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.accentBackgroundCyan)),
                        trailingIcon: Image(systemName: "rectangle.fill"),
                        text: "시안"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.accentBackgroundLightBlue)),
                        trailingIcon: Image(systemName: "rectangle.fill"),
                        text: "라이트 블루"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.accentBackgroundViolet)),
                        trailingIcon: Image(systemName: "rectangle.fill"),
                        text: "바이올렛"
                    )
    
                    Badge.Content(
                        variant: .solid,
                        color: .accent(.semantic(.accentBackgroundPink)),
                        trailingIcon: Image(systemName: "rectangle.fill"),
                        text: "핑크"
                    )
                }
            }
    
            Text("Outlined").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.primaryNormal)), text: "중요"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.statusPositive)), text: "긍정"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.statusCautionary)), text: "경고"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.statusNegative)), text: "에러"
                    )
                }
                
                HStack {
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.accentBackgroundLime)), text: "라임"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.accentBackgroundCyan)), text: "시안"
                    )
                    
                    Badge.Content(
                        variant: .outlined,
                        color: .accent(.semantic(.accentBackgroundLightBlue)),
                        text: "라이트 블루"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.accentBackgroundViolet)), text: "바이올렛"
                    )
                    
                    Badge.Content(
                        variant: .outlined, color: .accent(.semantic(.accentBackgroundPink)), text: "핑크"
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
            .background(SwiftUI.Color(.semantic(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
