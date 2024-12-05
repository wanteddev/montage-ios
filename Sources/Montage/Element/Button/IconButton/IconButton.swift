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
            .clear
        case .background(_, let isAlternative):
            if isAlternative {
                .atomic(.globalCoolNeutral30).withAlphaComponent(0.61)
            } else {
                // material이 적용되어 있기 때문에 값에 무관
                .clear
            }
        case .solid:
            .alias(.primaryNormal)
        }
    }
    
    var inactiveBackgroundColor: UIColor {
        switch self {
        case .normal, .outlined:
            .clear
        case .background:
            .component(.fillAlternative).withAlphaComponent(0.05)
        case .solid:
            .component(.fillNormal).withAlphaComponent(0.08)
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
            .alias(.labelDisable).withAlphaComponent(0.16)
        case .background:
            .atomic(.globalCoolNeutral50).withAlphaComponent(0.22)
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
        case .background(_, _), .outlined(_), .solid(_): backgroundOffset
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
        @State private var isLongPressSessionActive = false
        @State private var frame: CGRect = .zero
        @State private var startingFrame: CGRect = .zero
        @State private var isDragging = false
        
        /// 버튼의 외관입니다.
        private let variant: IconButton.Variant
        
        /// 버튼에 표시될 아이콘입니다.
        private let icon: Icon

        /// 버튼의 활성화 여부입니다.
        private let disable: Bool
        
        /// 버튼 우측 상단의 푸시 뱃지 노출 여부입니다.
        /// > normal variant에서만 사용 가능합니다.
        private let showPushBadge: Bool
        
        /// 커스텀 가능한 패딩 입니다.
        /// > 설정 시 constraint가 업데이트 됩니다.
        /// > outlined, soild variant에서만 사용 가능합니다.
        private let padding: CGFloat
        
        /// 커스텀 가능한 아이콘 컬러 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        private let iconColor: SwiftUI.Color?
        
        /// 커스텀 가능한 배경색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        /// > outlined, soild variant에서만 사용 가능합니다.
        private let backgroundColor: SwiftUI.Color?
        
        /// 커스텀 가능한 테두리색 입니다.
        /// montage의 모든 컬러를 사용할 수 있습니다.
        /// > outlined 에서만 사용 가능합니다.
        private let borderColor: SwiftUI.Color?
        
        /// 버튼의 클릭 이벤트를 받을 수 있는 핸들러입니다.
        private let handler: (() -> Void)?
        
        public init(
            variant: IconButton.Variant = .default,
            icon: Icon,
            disable: Bool = false,
            showPushBadge: Bool = false,
            padding: CGFloat = .zero,
            iconColor: SwiftUI.Color? = nil,
            backgroundColor: SwiftUI.Color? = nil,
            borderColor: SwiftUI.Color? = nil,
            handler: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.icon = icon
            self.disable = disable
            self.showPushBadge = {
                guard case .normal(_) = variant else { return false }
                return showPushBadge
            }()
            self.padding = {
                switch variant {
                case .normal, .background: .zero
                case .outlined, .solid: padding
                }
            }()
            if let iconColor {
                self.iconColor = iconColor
            } else {
                self.iconColor = nil
            }
            self.backgroundColor = {
                switch variant {
                case .normal, .background: nil
                case .outlined, .solid: 
                    if let backgroundColor {
                        backgroundColor
                    } else {
                        nil
                    }
                }
            }()
            self.borderColor = {
                guard case .outlined(_) = variant, let borderColor else { return nil }
                return borderColor
            }()
            self.handler = handler
        }
        
        // MARK: Private Computed Property
        
        private var _iconColor: SwiftUI.Color {
            if disable {
                SwiftUI.Color(uiColor: variant.inactiveColor)
            } else {
                if let iconColor {
                    iconColor
                } else {
                    SwiftUI.Color(uiColor: variant.activeColor)
                }
            }
        }
        
        private var _strokeColor: SwiftUI.Color {
            if case .outlined(_) = variant, let borderColor {
                borderColor
            } else {
                SwiftUI.Color(uiColor: variant.borderColor)
            }
        }
        
        private var _backgroundColor: SwiftUI.Color {
            if disable {
                SwiftUI.Color(uiColor: variant.inactiveBackgroundColor)
            } else {
                if let backgroundColor {
                    backgroundColor
                } else {
                    SwiftUI.Color(uiColor: variant.activeBackgroundColor)
                }
            }
        }
        
        private var interactionOffset: CGFloat {
            variant.interactionOffset + padding
        }

        public var body: some View {
            SwiftUI.Button {} label: {
                ZStack {
                    Image.montage(icon)
                        .resizable()
                        .frame(
                            width: variant.iconSize.width,
                            height: variant.iconSize.height
                        )
                        .foregroundStyle(_iconColor)
                    if showPushBadge {
                        Badge.PushBadgeController(variant: .dot)
                            .offset(
                                x: Badge.Push.Variant.dot.dotOffset,
                                y: -Badge.Push.Variant.dot.dotOffset
                            )
                    }
                }
            }
            .overlay {
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: variant.interactionVariant,
                    color: variant.interactionColor
                )
                .clipShape(Circle())
                .padding(.vertical, -interactionOffset)
                .padding(.horizontal, -interactionOffset)
            }
            .padding(.all, variant.backgroundOffset + padding)
            .background(
                ZStack {
                    Circle()
                        .fill(_backgroundColor)
                    if case let .background(_, alternative) = variant, alternative == false {
                        Circle()
                            .fill(.regularMaterial)
                    }
                    Circle()
                        .stroke(_strokeColor, lineWidth: variant.borderWidth)
                }
            )
            .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .global) }, action: { frame = $0 })
            .onLongPressGesture(perform: {}, onPressingChanged: {
                isLongPressSessionActive = $0 // 스크롤로 인해 버튼 frame이 변경되면 longPress 세션이 종료됨
                guard isPressed != $0, !isDragging else { return }
                if isPressed {
                    handler?()
                    startingFrame = .zero
                } else {
                    startingFrame = frame
                }
                isPressed = $0
            })
            .simultaneousGesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                    .onChanged { value in
                        isDragging = true
                        // 스크롤되면 press상태가 해제되고 다시 버튼을 누르기 전까지는 press상태가 다시 켜지는 일이 없음
                        isPressed = isLongPressSessionActive && startingFrame.contains(value.location)
                    }
                    .onEnded { value in
                        if isLongPressSessionActive && startingFrame.contains(value.location) {
                            handler?()
                        }
                        isPressed = false
                        isDragging = false
                    }
            )
            .frame(
                width: variant.iconSize.width + variant.backgroundOffset + padding,
                height: variant.iconSize.height + variant.backgroundOffset + padding
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
                
                Button.IconButton(
                    icon: .bookmark,
                    showPushBadge: true
                ) {
                    debugPrint(">>> hello world!")
                }

                Button.IconButton(
                    variant: .background(size: 20),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .background(size: 20, isAlternative: true),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .solid(size: .normal),
                    icon: .apps
                )
            }
            
            Text("size").montage()
            
            HStack {
                Button.IconButton(
                    variant: .normal(size: 28),
                    icon: .apps
                ) {
                    debugPrint(">>> hello world!")
                }
                
                Button.IconButton(
                    variant: .background(size: 36),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .outlined(size: .small),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps
                )
                
                Button.IconButton(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps
                )
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
                
                Button.IconButton(
                    variant: .background(size: 36),
                    icon: .apps,
                    disable: true
                )
                
                Button.IconButton(
                    variant: .outlined(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
                
                Button.IconButton(
                    variant: .solid(size: .custom(size: 12)),
                    icon: .apps,
                    disable: true
                )
            }
            
            Text("custom").montage()
            
            HStack {
                Button.IconButton(
                    variant: .background(size: 10, isAlternative: false),
                    icon: .chat,
                    iconColor: .atomic(.globalBlue50)
                )
                
                Button.IconButton(
                    icon: .apps,
                    iconColor: .alias(.accentLightBlue)
                ) {
                    debugPrint(">>> hello world!")
                }
                
                Button.IconButton(
                    variant: .background(size: 20),
                    icon: .apps,
                    iconColor: .alias(.accentPink)
                )
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    iconColor: .alias(.accentRedOrange)
                )
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3
                )
                
                Button.IconButton(
                    variant: .outlined(size: .normal),
                    icon: .apps,
                    padding: 3,
                    borderColor: .alias(.primaryHeavy)
                )
                
                Button.IconButton(
                    variant: .solid(size: .small),
                    icon: .apps,
                    iconColor: .alias(.accentRedOrange),
                    borderColor: .alias(.accentLime)
                )
                
                Button.IconButton(
                    variant: .solid(size: .small),
                    icon: .apps,
                    borderColor: .alias(.accentLime)
                )
            }
        }
    }
}
