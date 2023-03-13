//
//  NestedCheckController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import SwiftUI

public extension Montage {
    struct NestedCheckController: UIViewRepresentable {
        @State public var state: MontageInputState
        
        public typealias UIViewType = Montage.NestedCheck
        
        public func makeUIView(context: Context) -> Montage.NestedCheck {
            .init()
        }
        
        public func updateUIView(_ uiView: Montage.NestedCheck, context: Context) {
            uiView.state = state
        }
    }
}

struct MontageNestedCheckController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Montage.NestedCheckController(state: .checked)
                .frame(width: 24, height: 24)
        }
    }
}
