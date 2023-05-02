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
        @State public var varient: Badge.Content.Varient = .filled
        
        /// 뱃지의 사이즈입니다.
        @State public var size: Badge.Content.Size = .small
        
        /// 뱃지에 사용될 색상 스타일입니다.
        @State public var color: Badge.Content.ColorStyle = .neutral
        
        /// 텍스트의 좌측에 표현될 아이콘입니다.
        @State public var leftIcon: Icon?
        
        /// 텍스트의 우측에 표현될 아이콘입니다.
        @State public var rightIcon: Icon?
        
        /// 버튼에서 표현될 텍스트입니다.
        @State public var text: String = ""
        
        public typealias UIViewType = Badge.Content
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
            uiView.size = size
            uiView.colorStyle = color
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
        }
    }
}

var contentBadgeControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        Text("Varient").montage(varient: .heading2)
        
        HStack {
            Badge.ContentBadgeController(
                varient: .filled, text: "안녕하세요"
            ).fixedSize()
            
            Badge.ContentBadgeController(
                varient: .outlined, text: "안녕하세요"
            ).fixedSize()
        }
        
        Text("Size").montage(varient: .heading2)
        
        HStack {
            Badge.ContentBadgeController(
                varient: .filled, size: .xsmall, text: "안녕하세요"
            ).fixedSize()
            
            Badge.ContentBadgeController(
                varient: .outlined, size: .xsmall, text: "안녕하세요"
            ).fixedSize()
            
            Badge.ContentBadgeController(
                varient: .filled, size: .small, text: "안녕하세요"
            ).fixedSize()
            
            Badge.ContentBadgeController(
                varient: .outlined, size: .small, text: "안녕하세요"
            ).fixedSize()
        }
        
        Text("Accents").montage(varient: .heading2)
        
        Text("Filled").montage(varient: .body2)
        
        VStack(alignment: .leading) {
            HStack {
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.primary), text: "중요"
                ).fixedSize()
        
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.positive), text: "긍정"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.cautionary), text: "경고"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.negative), text: "에러"
                ).fixedSize()
            }
            
            HStack {
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.lime), text: "라임"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.cyan), text: "시안"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.lightBlue), text: "라이트 블루"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.violet), text: "바이올렛"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .filled, color: .accent(.pink), text: "핑크"
                ).fixedSize()
            }
        }
        
        Text("Outlined").montage(varient: .body2)
        
        VStack(alignment: .leading) {
            HStack {
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.primary), text: "중요"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.positive), text: "긍정"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.cautionary), text: "경고"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.negative), text: "에러"
                ).fixedSize()
            }
            
            HStack {
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.lime), text: "라임"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.cyan), text: "시안"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.lightBlue), text: "라이트 블루"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.violet), text: "바이올렛"
                ).fixedSize()
                
                Badge.ContentBadgeController(
                    varient: .outlined, color: .accent(.pink), text: "핑크"
                ).fixedSize()
            }
        }
    }
}

struct ContentBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        contentBadgeControllerPreview
            .padding()
            .background(SwiftUI.Color(.alias(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
