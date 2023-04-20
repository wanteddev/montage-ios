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
        @State public var state: Decorate.Interaction.State = .normal
        @State public var disable: Bool = false
        @State public var handler: (() -> Void)?
        
        public typealias UIViewType = IconButton
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.varient = varient
            uiView.icon = icon
            uiView.state = state
            uiView.disable = disable
            uiView.handler = handler
        }
    }
}

struct IconButtonController_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button.IconButtonController(
                varient: .normal,
                icon: .apps
            ) {
                debugPrint(">>> hello world!")
            }
            .fixedSize()
            
            Button.IconButtonController(
                varient: .background,
                icon: .apps
            )
            .fixedSize()
            
            Button.IconButtonController(
                varient: .outlined(size: .normal),
                icon: .apps
            )
            .fixedSize()
        }
    }
}
