//
//  NestedCheckController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import Foundation
import SwiftUI

public extension Montage {
    struct NestedCheckController: UIViewRepresentable {
        @Binding public var state: MontageInputState
        
        public typealias UIViewType = Montage.NestedCheck
        
        public func makeUIView(context: Context) -> Montage.NestedCheck {
            .init()
        }
        
        public func updateUIView(_ uiView: Montage.NestedCheck, context: Context) {
            uiView.state = state
        }
    }
}
