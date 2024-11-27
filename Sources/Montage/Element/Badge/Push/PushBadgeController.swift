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
        
        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
            CGSize(
                width: fillWidth ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillHeight ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        private var fillWidth: Bool = false
        private var fillHeight: Bool = false
        public func fill(width fillWidth: Bool, height fillHeight: Bool) -> Self {
            var zelf = self
            zelf.fillWidth = fillWidth
            zelf.fillHeight = fillHeight
            return zelf
        }
    }
}

fileprivate struct Preview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Badge.PushBadgeController(variant: .dot)
            
            Badge.PushBadgeController(variant: .new)
            
            Badge.PushBadgeController(variant: .number(1))
            
            Badge.PushBadgeController(variant: .number(999))
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
