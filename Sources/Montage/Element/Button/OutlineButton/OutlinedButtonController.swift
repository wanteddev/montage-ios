//
//  OutlineButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/25.
//

import Foundation

import SwiftUI
import Pretendard

extension Button {
    public struct OutlinedButtonController: UIViewRepresentable {
        @State public var varient: OutlinedButton.Varient = .primary
        @State public var size: OutlinedButton.Size = .medium
        @State public var leftIcon: Icon?
        @State public var rightIcon: Icon?
        @State public var text: String
        @State public var state: Decorate.Interaction.State = .normal
        @State public var disable: Bool = false
        @State public var handler: (() -> Void)?
        
        public typealias UIViewType = OutlinedButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
            uiView.size = size
            uiView.leftIcon = leftIcon
            uiView.rightIcon = rightIcon
            uiView.text = text
            uiView.state = state
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

var outlinedButtonControllerPreview: some View {
    VStack(alignment: .leading, spacing: .spacing(.pt20)) {
        Text("Varient").montage()
        
        HStack {
            Button.OutlinedButtonController(
                varient: .primary,
                size: .small,
                rightIcon: .chevronRightThick,
                text: "안녕하세요"
            )
            .fixedSize()
            
            Button.OutlinedButtonController(
                varient: .secondary,
                size: .small,
                rightIcon: .chevronRightThick,
                text: "안녕하세요"
            )
            .fixedSize()
            
            Button.OutlinedButtonController(
                varient: .assistive,
                size: .small,
                rightIcon: .chevronRightThick,
                text: "안녕하세요"
            )
            .fixedSize()
        }
        
        Text("State").montage()
        
        VStack(alignment: .leading, spacing: .spacing(.pt16)) {
            HStack {
                Button.OutlinedButtonController(
                    varient: .primary,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요"
                )
                .fixedSize()
                
                Button.OutlinedButtonController(
                    varient: .secondary,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요"
                )
                .fixedSize()
                
                Button.OutlinedButtonController(
                    varient: .assistive,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요"
                )
                .fixedSize()
            }
            HStack {
                Button.OutlinedButtonController(
                    varient: .primary,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                )
                .fixedSize()
                
                Button.OutlinedButtonController(
                    varient: .secondary,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                )
                .fixedSize()
                
                Button.OutlinedButtonController(
                    varient: .assistive,
                    size: .small,
                    rightIcon: .chevronRightThick,
                    text: "안녕하세요",
                    disable: true
                )
                .fixedSize()
            }
        }
        
        Text("Size").montage()
        
        HStack {
            Button.OutlinedButtonController(
                size: .small,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.OutlinedButtonController(
                size: .medium,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.OutlinedButtonController(
                size: .large,
                text: "안녕하세요"
            ).fixedSize()
        }
        
        Text("Icon").montage()
        
        HStack {
            Button.OutlinedButtonController(
                size: .small,
                leftIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.OutlinedButtonController(
                size: .small,
                rightIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
            
            Button.OutlinedButtonController(
                size: .small,
                leftIcon: .apps,
                rightIcon: .apps,
                text: "안녕하세요"
            ).fixedSize()
        }
    }
}

struct OutlinedButtonController_Previews: PreviewProvider {
    static var previews: some View {
        outlinedButtonControllerPreview
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
