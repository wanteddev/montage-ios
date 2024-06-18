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
        public var contentColorResolver: ColorResolvable? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = IconButton
        
        public init(
            varient: IconButton.Varient,
            icon: Icon,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            contentColorResolver: ColorResolvable? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.varient = varient
            self.icon = icon
            self.state = state
            self.disable = disable
            self.contentColorResolver = contentColorResolver
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
            uiView.contentColorResolver = contentColorResolver
            uiView.handler = handler
        }
    }
}

struct IconButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("varient").montage()
            
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
            
            Text("custom").montage()
            
            HStack {
                Button.IconButtonController(
                    varient: .normal,
                    icon: .apps,
                    contentColorResolver: Color.Alias.accentLightBlue
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButtonController(
                    varient: .background,
                    icon: .apps,
                    contentColorResolver: Color.Alias.accentPink
                )
                .fixedSize()
                
                Button.IconButtonController(
                    varient: .outlined(size: .normal),
                    icon: .apps,
                    contentColorResolver: Color.Alias.accentRedOrange
                )
                .fixedSize()
            }
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
