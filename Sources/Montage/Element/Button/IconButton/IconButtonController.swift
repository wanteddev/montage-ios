//
//  IconButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

extension Button {
    public struct IconButtonController: UIViewRepresentable {
        public var varient: IconButton.Varient
        public var icon: Icon
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var handler: (() -> Void)?
        
        public typealias UIViewType = IconButton
        
        public init(
            varient: IconButton.Varient,
            icon: Icon,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            handler: (() -> Void)? = nil
        ) {
            self.varient = varient
            self.icon = icon
            self.state = state
            self.disable = disable
            self.handler = handler
        }
        
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

struct IconButtonControllerPreview: View {
    var body: some View {
        HStack {
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

struct IconButtonController_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonControllerPreview()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
