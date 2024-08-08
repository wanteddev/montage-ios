//
//  IconButton.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/11.
//

import SwiftUI

extension Button.IconButton {
    /// 버튼의 외관을 결정하는 열거형입니다.
    public enum Variant {
        /// 버튼 사이즈를 결정하는 열거형입니다.
        public enum Size {
            case normal
            case small
            case custom(size: Int)
        }
        
        case normal(size: Int)
        case background(size: Int, isAlternative: Bool = false)
        case outlined(size: Size)
        case solid(size: Size)
        
        /// normal(size: 24)의 기본 variant입니다.
        public static let `default` = Self.normal(size: 24)
    }
}

extension Button.IconButton.Variant {
    var activeBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background(_, let isAlternative):
            if isAlternative {
                return .atomic(.globalCoolNeutral30).withAlphaComponent(0.61)
            } else {
                // material이 적용되어 있기 때문에 값에 무관
                return .clear
            }
        case .solid:
            return .alias(.primaryNormal)
        }
    }
    
    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            return .clear
        case .background:
            return .component(.fillAlternative).withAlphaComponent(0.05)
        case .solid:
            return .component(.fillNormal).withAlphaComponent(0.08)
        }
    }
    
    var activeColor: UIColor {
        switch self {
        case .normal, .outlined: .alias(.labelNormal)
        case .background(_, let isAlternative):
            if isAlternative {
                .alias(.staticWhite).withAlphaComponent(0.88)
            } else {
                .atomic(.globalCoolNeutral50).withAlphaComponent(0.74)
            }
        case .solid: .alias(.staticWhite)
        }
    }
    
    var inactiveColor: UIColor {
        switch self {
        case .normal, .outlined, .solid:
            return .alias(.labelDisable).withAlphaComponent(0.16)
        case .background:
            return .atomic(.globalCoolNeutral50).withAlphaComponent(0.22)
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outlined: 1
        default: .zero
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .outlined: .alias(.lineNeutral)
        default: .clear
        }
    }
    
    var interactionColor: Color.Alias {
        .labelNormal
    }
    
    var interactionVariant: Decorate.Interaction.Variant {
        switch self {
        case .normal, .outlined: .light
        case .background(_, let isAlternative):
            isAlternative ? .normal : .light
        case .solid: .strong
        }
    }
    
    var backgroundOffset: CGFloat {
        switch self {
        case .normal: .zero
        case .background(_, _): 6
        case let .outlined(size), let .solid(size):
            switch size {
            case .normal: 10
            case .small: 7
            case .custom(_): 6
            }
        }
    }
    
    var interactionOffset: CGFloat {
        switch self {
        case .normal: 8
        case .background(_, _): 6
        case .outlined(_), .solid(_): 10
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .normal(let size): .init(width: size, height: size)
        case .background(let size, _): .init(width: size, height: size)
        case .outlined(let variant), .solid(let variant):
            switch variant {
            case .normal:
                .init(width: 20, height: 20)
            case .small:
                .init(width: 18, height: 18)
            case .custom(let size):
                .init(width: size, height: size)
            }
        }
    }
}

extension Button {
    public struct IconButton: View {
        @State private var isPressed = false
        
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
        
        public typealias UIViewType = UIIconButton
        
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
        
        public var body: some View {
            SwiftUI.Button {} label: {
                Image.montage(icon)
                    .resizable()
                    .frame(
                        width: variant.iconSize.width + padding,
                        height: variant.iconSize.height + padding
                    )
                    .foregroundStyle(
                        {
                            if disable {
                                return SwiftUI.Color(uiColor: variant.inactiveColor)
                            } else {
                                if let iconColorResolver {
                                    return SwiftUI.Color(uiColor: iconColorResolver.resolve(.current))
                                } else {
                                    return SwiftUI.Color(uiColor: variant.activeColor)
                                }
                            }
                        }()
                    )
            }
            .overlay {
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(Circle())
                .padding(.vertical, -variant.interactionOffset)
                .padding(.horizontal, -variant.interactionOffset)
            }
            .padding(.all, variant.backgroundOffset)
            .background(
                ZStack {
                    Circle()
                        .fill(
                            disable ? SwiftUI.Color(uiColor: variant.inactiveBackgroundColor)  : SwiftUI.Color(uiColor: variant.activeBackgroundColor)
                        )
                    Circle()
                        .stroke(
                            {
                                if case .outlined(_) = variant, let borderColorResolver {
                                    return SwiftUI.Color(uiColor: borderColorResolver.resolve(.current))
                                } else {
                                    return SwiftUI.Color(uiColor: variant.borderColor)
                                }
                            }(),
                            lineWidth: variant.borderWidth
                        )
                }
                    
            )
            .onLongPressGesture(
                minimumDuration: 2.0,
                perform: {
                    isPressed = true
                },
                onPressingChanged: { state in
                    isPressed = state
                    if state == false {
                        handler?()
                    }
                }
            )
            .frame(
                width: variant.iconSize.width + variant.backgroundOffset,
                height: variant.iconSize.height + variant.backgroundOffset
            )
            .allowsHitTesting(disable == false)
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

struct IconButtonControllerPreview: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("variant").montage()
            
            HStack {
                Button.IconButton(
                    icon: .apps
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButton(
                    icon: .bell,
                    showPushBadge: true
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()

                Button.IconButton(
                    variant: .background(size: 20),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .background(size: 20, isAlternative: true),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .solid(size: .normal),
                    icon: .apps
                )
                .fixedSize()
            }
            
            Text("size").montage()
            
            HStack {
                Button.IconButton(
                    variant: .normal(size: 28),
                    icon: .apps
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButton(
                    variant: .background(size: 36),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .small),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps
                )
                .fixedSize()
            }
            
            
            Text("disable").montage()
            
            HStack {
                Button.IconButton(
                    variant: .normal(size: 28),
                    icon: .apps,
                    disable: true
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButton(
                    variant: .background(size: 36),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
                .fixedSize()
            }
            
            Text("custom").montage()
            
            HStack {
                Button.IconButton(
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentLightBlue
                ) {
                    debugPrint(">>> hello world!")
                }
                .fixedSize()
                
                Button.IconButton(
                    variant: .background(size: 20),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentPink
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentRedOrange
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3,
                    borderColorResolver: Color.Alias.primaryHeavy
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .solid(size: .small),
                    icon: .apps,
                    iconColorResolver: Color.Alias.accentRedOrange,
                    backgroundColorResolver: Color.Alias.accentLime
                )
                .fixedSize()
                
                Button.IconButton(
                    variant: .solid(size: .small),
                    icon: .apps,
                    backgroundColorResolver: Color.Alias.accentLime
                )
                .fixedSize()
            }
        }
    }
}
