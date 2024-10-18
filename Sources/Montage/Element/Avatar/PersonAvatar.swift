//
//  PersonAvatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

extension Avatar {
    /// 사람용 Avatar 컴포넌트 입니다.
    ///
    /// > OnTap을 전달해야 interaction이 활성화 됩니다.
    public struct Person: View {
        public enum Variant {
            case icon
            case image(Image)
        }
        
        public enum Size {
            case xsmall
            case small
            case medium
            case large
            case xlarge
            
            var imageSize: CGSize {
                switch self {
                case .xsmall: .init(width: 16, height: 16)
                case .small: .init(width: 21.3, height: 21.3)
                case .medium: .init(width: 26.67, height: 26.67)
                case .large: .init(width: 32, height: 32)
                case .xlarge: .init(width: 37.3, height: 37.3)
                }
            }
            
            var padding: CGFloat {
                switch self {
                case .xsmall: 4
                case .small: 5.3
                case .medium: 6.67
                case .large: 8
                case .xlarge: 9.3
                }
            }
            
            var componentSize: CGSize {
                switch self {
                case .xsmall: .init(width: 24, height: 24)
                case .small: .init(width: 32, height: 32)
                case .medium: .init(width: 40, height: 40)
                case .large: .init(width: 48, height: 48)
                case .xlarge: .init(width: 56, height: 56)
                }
            }
        }

        private let variant: Variant
        private let size: Size
        private let showPushBadge: Bool
        private let onTap: (() -> Void)?
        
        @State private var isPressed: Bool = false
        
        public init(
            variant: Variant,
            size: Size,
            showPushBadge: Bool = false,
            onTap: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.showPushBadge = showPushBadge
            self.onTap = onTap
        }
        
        public var body: some View {
            ZStack {
                Circle()
                    .foregroundStyle(SwiftUI.Color(red: 140/255, green: 145/255, blue: 150/255).opacity(0.205))
                
                processedImage()
                
                if showPushBadge {
                    Badge.PushBadgeController(variant: .dot)
                        .fixedSize()
                        .offset(
                            x: size.componentSize.width / 2,
                            y: -size.componentSize.height / 2
                        )
                }
            }
            .frame(width: size.componentSize.width, height: size.componentSize.height)
            .overlay {
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: .normal,
                    color: .labelNormal
                )
                .clipShape(Circle())
            }
            .onLongPressGesture(
                minimumDuration: 2.0,
                perform: {
                    isPressed = true
                },
                onPressingChanged: { state in
                    guard let onTap else { return }
                    isPressed = state
                    if state == false {
                        onTap()
                    }
                }
            )
        }
        
        @ViewBuilder
        private func processedImage() -> some View {
            switch variant {
            case .icon:
                Image.montage(.personFill)
                    .resizable()
                    .frame(width: size.imageSize.width, height: size.imageSize.height)
                    .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
            case .image(let image):
                image
                    .resizable()
                    .frame(width: size.componentSize.width, height: size.componentSize.height)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .inset(by: 0.5)
                            .stroke(SwiftUI.Color.alias(.lineAlternative).opacity(0.08), lineWidth: 1)
                    }
            }
        }
    }
}

#Preview {
    Avatar.Person(variant: .icon, size: .small)
}
