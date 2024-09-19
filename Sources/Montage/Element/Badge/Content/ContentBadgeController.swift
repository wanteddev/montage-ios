//
//  ContentBadgeController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import SwiftUI
import Pretendard

extension Badge {
    public struct ContentBadgeController: UIViewRepresentable {
        /// 뱃지의 외관입니다.
        public var variant: Badge.Content.Variant
        
        /// 뱃지의 사이즈입니다.
        public var size: Badge.Content.Size
        
        /// 뱃지에 사용될 색상 스타일입니다.
        public var color: Badge.Content.ColorStyle
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        public var leftIcon: Icon?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        public var rightIcon: Icon?
        
        /// 버튼에서 표현될 텍스트입니다.
        public var text: String
        
        public typealias UIViewType = Badge.Content
        
        public init(
            variant: Badge.Content.Variant = .filled,
            size: Badge.Content.Size = .medium,
            color: Badge.Content.ColorStyle = .neutral,
            leftIcon: Icon? = nil,
            rightIcon: Icon? = nil,
            text: String
        ) {
            self.variant = variant
            self.size = size
            self.color = color
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.text = text
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.variant = variant
            uiView.size = size
            uiView.colorStyle = color
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
        }
    }
}

fileprivate struct Preview: View {
    @State var text: String = "안녕하세요"

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Text("Variant").montage(variant: .headline2)

            HStack {
                Badge.ContentBadgeController(
                    variant: .filled, text: text
                ).fixedSize()

                Badge.ContentBadgeController(
                    variant: .outlined, text: text
                ).fixedSize()
            }

            Text("Size").montage(variant: .headline2)

            HStack {
                Badge.ContentBadgeController(
                    variant: .filled, size: .normal, text: text
                ).fixedSize()

                Badge.ContentBadgeController(
                    variant: .outlined, size: .normal, text: text
                ).fixedSize()

                Badge.ContentBadgeController(
                    variant: .filled, size: .medium, text: text
                ).fixedSize()

                Badge.ContentBadgeController(
                    variant: .outlined, size: .medium, text: text
                ).fixedSize()
            }
    
            Text("Accents").montage(variant: .headline2)
    
            Text("Filled").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.primary), text: "중요"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.positive), text: "긍정"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.cautionary), text: "경고"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.negative), text: "에러"
                    ).fixedSize()
                }
    
                HStack {
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.lime), text: "라임"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.cyan), text: "시안"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.lightBlue), text: "라이트 블루"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.violet), text: "바이올렛"
                    ).fixedSize()
    
                    Badge.ContentBadgeController(
                        variant: .filled, color: .accent(.pink), text: "핑크"
                    ).fixedSize()
                }
            }
    
            Text("Outlined").montage(variant: .body2)
    
            VStack(alignment: .leading) {
                HStack {
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.primary), text: "중요"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.positive), text: "긍정"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.cautionary), text: "경고"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.negative), text: "에러"
                    ).fixedSize()
                }
                
                HStack {
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.lime), text: "라임"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.cyan), text: "시안"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.lightBlue), text: "라이트 블루"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.violet), text: "바이올렛"
                    ).fixedSize()
                    
                    Badge.ContentBadgeController(
                        variant: .outlined, color: .accent(.pink), text: "핑크"
                    ).fixedSize()
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
