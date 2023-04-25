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
            uiView.color = color
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
            Badge.ContentBadgeController(varient: .filled, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .outlined, text: "안녕하세요").fixedSize()
        }
        
        Text("Size").montage(varient: .heading2)
        
        HStack {
            Badge.ContentBadgeController(varient: .filled, size: .xsmall, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .outlined, size: .xsmall, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .filled, size: .small, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .outlined, size: .small, text: "안녕하세요").fixedSize()
        }
        
        Text("Color Style").montage(varient: .heading2)
        
        HStack {
            Badge.ContentBadgeController(varient: .filled, color: .neutral, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .filled, color: .accent, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .outlined, color: .neutral, text: "안녕하세요").fixedSize()
            Badge.ContentBadgeController(varient: .outlined, color: .accent, text: "안녕하세요").fixedSize()
        }
    }
}

struct ContentBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        contentBadgeControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
