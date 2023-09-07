//
//  RoundCheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/09/07.
//

import SwiftUI

extension Control {
    /// ``Montage/RoundCheckbox``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct RoundCheckboxController: UIViewRepresentable {
        public var state: MontageControlState
        public var size: RoundCheckbox.Size
        
        public typealias UIViewType = RoundCheckbox
        
        public init(
            state: MontageControlState,
            size: RoundCheckbox.Size
        ) {
            self.state = state
            self.size = size
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
            uiView.size = size
        }
    }
}

struct RoundCheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.RoundCheckboxController(state: .checked, size: .normal).fixedSize()
        }
    }
}
