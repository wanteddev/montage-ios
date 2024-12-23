//
//  CompanyAvatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

extension Avatar {
    /// 기업용 Avatar 컴포넌트 입니다.
    ///
    /// > OnTap을 전달해야 interaction이 활성화 됩니다.
    public struct Company: View {
        private let variant: Avatar.Variant
        private let size: Avatar.Size
        private let onTap: (() -> Void)?
        
        @State private var isPressed = false
        
        public init(
            variant: Avatar.Variant,
            size: Avatar.Size,
            onTap: (() -> Void)? = nil
        ) {
            self.variant = variant
            self.size = size
            self.onTap = onTap
        }
        
        public var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(
                        SwiftUI.Color(red: 140 / 255, green: 145 / 255, blue: 150 / 255)
                            .opacity(0.205)
                    )
                
                processedImage()
            }
            .frame(width: size.componentSize.width, height: size.componentSize.height)
            .overlay {
                Decorate.InteractionController(
                    state: isPressed ? .pressed : .normal,
                    variant: .normal,
                    color: .labelNormal
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
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
        
        private func basicImage() -> some View {
            Image.montage(.company)
                .resizable()
                .frame(width: size.imageSize.width, height: size.imageSize.height)
                .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
        }
        
        private func borderedImage(_ image: Image) -> some View {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.componentSize.width, height: size.componentSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(SwiftUI.Color.alias(.lineAlternative), lineWidth: 1)
                }
        }
        
        @ViewBuilder
        private func processedImage() -> some View {
            switch variant {
            case .icon:
                basicImage()
            case .image(let image):
                borderedImage(image)
            case .url(let url):
                AsyncImage(url: url) {
                    if let image = $0.image {
                        borderedImage(image)
                    } else {
                        basicImage()
                    }
                }
            }
        }
    }
}

#Preview {
    Avatar.Company(variant: .icon, size: .small)
}
