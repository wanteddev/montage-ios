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
        @State public var varient: Badge.Push.Varient
        
        public typealias UIViewType = Badge.Push
        
        public init(varient: Badge.Push.Varient) {
            self.varient = varient
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
        }
    }
}

var pushBadgeControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        Badge.PushBadgeController(varient: .dot).fixedSize()
        
        Badge.PushBadgeController(varient: .new).fixedSize()
        
        Badge.PushBadgeController(varient: .number(1)).fixedSize()
        
        Badge.PushBadgeController(varient: .number(999)).fixedSize()
    }
}

struct PushBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        pushBadgeControllerPreview
            .padding()
            .background(SwiftUI.Color(.alias(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
