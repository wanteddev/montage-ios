//
//  CheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

extension Control {
    /// ``Montage/Checkbox``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct CheckboxController: UIViewRepresentable {
        @State public var state: MontageControlState
        
        public typealias UIViewType = Checkbox
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
        }
    }
}

struct CheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.CheckboxController(state: .checked)
        }
    }
}
