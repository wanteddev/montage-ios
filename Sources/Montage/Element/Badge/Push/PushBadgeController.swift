//
//  PushBadgeController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/26.
//

import SwiftUI
import Pretendard

extension Badge {
    public struct PushBadgeController: UIViewRepresentable {
        /// 뱃지의 외관입니다.
        public var variant: Badge.Push.Variant
        
        public typealias UIViewType = Badge.Push
        
        public init(variant: Badge.Push.Variant) {
            self.variant = variant
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.variant = variant
        }
    }
}

fileprivate struct Preview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Badge.PushBadgeController(variant: .dot).fixedSize()
            
            Badge.PushBadgeController(variant: .new).fixedSize()
            
            Badge.PushBadgeController(variant: .number(1)).fixedSize()
            
            Badge.PushBadgeController(variant: .number(999)).fixedSize()
        }
    }
}

struct PushBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .padding()
            .background(SwiftUI.Color(.alias(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
