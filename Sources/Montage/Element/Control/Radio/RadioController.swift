//
//  RadioController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import SwiftUI

extension Control {
    /// ``Montage/Radio``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct RadioController: UIViewRepresentable {
        @State public var state: MontageControlState
        
        public typealias UIViewType = Radio
        
        public init(state: MontageControlState) {
            self.state = state
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
        }
    }
}

struct RadioController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.RadioController(state: .checked).fixedSize()
        }
    }
}
