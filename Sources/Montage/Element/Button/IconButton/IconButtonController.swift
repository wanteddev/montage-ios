//
//  IconButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

extension Button {
    public struct IconButtonController: UIViewRepresentable {
        @State public var varient: IconButton.Varient
        @State public var icon: Icon
        @State public var state: Decorate.Interaction.State
        @State public var disable: Bool
        
        public typealias UIViewType = IconButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
            uiView.icon = icon
            uiView.state = state
            uiView.disable = disable
        }
    }
}
