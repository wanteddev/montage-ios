//
//  TextButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//


import SwiftUI

extension Button {
    public struct TextButtonController: UIViewRepresentable {
        @State public var size: RoundButton.Size
        @State public var leftIcon: Icon
        @State public var rightIcon: Icon
        @State public var text: String
        @State public var disable: Bool
        
        public typealias UIViewType = RoundButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.size = size
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.disable = disable
        }
    }
}
