//
//  Push.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/26.
//

import Pretendard
import SwiftUI

extension Badge {
    public struct Push: View {
        
        // MARK: - Types
        
        public enum Variant: Equatable {
            case dot, new, number(Int)
        }
        
        // MARK: - Initializer
        
        private let variant: Variant
        public init(variant: Variant) {
            self.variant = variant
        }
        
        // MARK: - Body
        
        public var body: some View {
            switch variant {
            case .dot:
                Circle()
                    .frame(minHeight: 4, maxHeight: 8)
                    .foregroundColor(backgroundColor)
                    .padding(8)
            case .new:
                Text("N")
                    .montage(variant: .caption2, weight: .bold, color: fontColor)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .background {
                        Circle()
                            .foregroundColor(backgroundColor)
                    }
                    .frame(width: 20, height: 20)
            case .number(let number):
                Text("\(number)")
                    .montage(variant: .caption2, weight: .bold, color: fontColor)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 6)
                    .background {
                        RoundedRectangle(cornerRadius: 1000)
                            .foregroundColor(backgroundColor)
                    }
                    .frame(height: 20)
            }
        }
        
        // MARK: - Modifiers
        
        private var fontColor: SwiftUI.Color = .alias(.staticWhite)
        private var backgroundColor: SwiftUI.Color = .alias(.primaryNormal)
        
        public func fontColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.fontColor = color
            return zelf
        }
        
        public func backgroundColor(_ color: SwiftUI.Color) -> Self {
            var zelf = self
            zelf.backgroundColor = color
            return zelf
        }
    }
}

fileprivate struct Preview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing(.pt20)) {
            Badge.Push(variant: .dot)
            
            Badge.Push(variant: .new)
            
            Badge.Push(variant: .number(1))
            
            Badge.Push(variant: .number(999))
        }
    }
}

struct PushBadgeController_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
            .padding()
            .background(SwiftUI.Color(.alias(.backgroundNormal)))
            .previewLayout(.sizeThatFits)
    }
}
