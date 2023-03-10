//
//  CheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import Foundation
import SwiftUI

public extension Montage {
    struct CheckboxController: UIViewRepresentable {
        @Binding public var state: MontageInputState
        
        public typealias UIViewType = Montage.Checkbox
        
        public func makeUIView(context: Context) -> Montage.Checkbox {
            .init()
        }
        
        public func updateUIView(_ uiView: Montage.Checkbox, context: Context) {
            uiView.state = state
        }
    }
}
