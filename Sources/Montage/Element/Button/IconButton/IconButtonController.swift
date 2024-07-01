//
//  IconButtonController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

extension Button {
    public struct IconButtonController: UIViewRepresentable {
        public var variant: IconButton.Variant
        public var icon: Icon
        public var state: Decorate.Interaction.State = .normal
        public var disable: Bool = false
        public var showPushBadge: Bool = false
        public var padding: CGFloat = .zero
        public var iconColorResolver: ColorResolvable? = nil
        public var backgroundColorResolver: ColorResolvable? = nil
        public var borderColorResolver: ColorResolvable? = nil
        public var handler: (() -> Void)?
        
        public typealias UIViewType = IconButton
        
        public init(
            variant: IconButton.Variant = .default,
            icon: Icon,
            state: Decorate.Interaction.State = .normal,
            disable: Bool = false,
            showPushBadge: Bool = false,
            padding: CGFloat = .zero,
            iconColorResolver: ColorResolvable? = nil,
            backgroundColorResolver: ColorResolvable? = nil,
            borderColorResolver: ColorResolvable? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.icon = icon
            self.state = state
            self.disable = disable
            self.showPushBadge = showPushBadge
            self.padding = padding
            self.iconColorResolver = iconColorResolver
            self.backgroundColorResolver = backgroundColorResolver
            self.borderColorResolver = borderColorResolver
            self.handler = handler
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            .init()
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.variant = variant
            uiView.icon = icon
            uiView.state = state
            uiView.disable = disable
            uiView.showPushBadge = showPushBadge
            uiView.padding = padding
            uiView.iconColorResolver = iconColorResolver
            uiView.backgroundColorResolver = backgroundColorResolver
            uiView.borderColorResolver = borderColorResolver
            uiView.handler = handler
        }
    }
}

struct IconButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("variant").montage()
            
            HStack {
                Button.IconButtonController(
                    icon: .apps
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButtonController(
                    icon: .bell,
                    showPushBadge: true
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()

                Button.IconButtonController(
                    variant: .background(size: 20),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .background(size: 20, isAlternative: true),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .solid(size: .normal),
                    icon: .apps
                )
                .fixedSize()
            }
            
            Text("size").montage()
            
            HStack {
                Button.IconButtonController(
                    variant: .normal(size: 28),
                    icon: .apps
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .background(size: 36),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .small),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps
                )
                .fixedSize()
            }
            
            
            Text("disable").montage()
            
            HStack {
                Button.IconButtonController(
                    variant: .normal(size: 28),
                    icon: .apps,
                    disable: true
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .background(size: 36),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
            }
            
            Text("custom").montage()
            
            HStack {
                Button.IconButtonController(
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentLightBlue
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .background(size: 20),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentPink
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentRedOrange
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3,
                    borderColorResolver: Color.Alias.primaryHeavy
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .solid(size: .small),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentRedOrange,
                    backgroundColorResolver: Color.Alias.accentLime
                )
                .fixedSize()
                
                Button.IconButtonController(
                    variant: .solid(size: .small),
                    icon: .apps,
                    backgroundColorResolver: Color.Alias.accentLime
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
