//
//  RadioController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import Foundation
import SwiftUI

public extension Montage {
    struct RadioController: UIViewRepresentable {
        @Binding public var state: MontageInputState
        
        public typealias UIViewType = Montage.Radio
        
        public func makeUIView(context: Context) -> Montage.Radio {
            .init()
        }
        
        public func updateUIView(_ uiView: Montage.Radio, context: Context) {
            uiView.state = state
        }
    }
}
