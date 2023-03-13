//
//  CheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

public extension Montage {
    struct CheckboxController: UIViewRepresentable {
        @State public var state: MontageInputState
        
        public typealias UIViewType = Montage.Checkbox
        
        public func makeUIView(context: Context) -> Montage.Checkbox {
            .init()
        }
        
        public func updateUIView(_ uiView: Montage.Checkbox, context: Context) {
            uiView.state = state
        }
    }
}

struct MontageCheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Montage.CheckboxController(state: .checked)
        }
    }
}
