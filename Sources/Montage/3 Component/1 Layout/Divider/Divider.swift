//
//  Divider.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/09.
//

import SwiftUI

extension Basic {
    /// 구획을 나누기 위해 사용되는 Element입니다.
    public struct Divider: View {
        // MARK: - Types
        public enum Variant {
            case normal, thick

            var size: CGFloat {
                switch self {
                case .normal: 1
                case .thick: 12
                }
            }
        }

        // MARK: - Initializer
        private let axis: Axis
        private let variant: Variant
        public init(_ axis: Axis, variant: Variant = .normal) {
            self.axis = axis
            self.variant = variant
        }

        // MARK: - Body
        public var body: some View {
            Rectangle()
                .if(axis == .vertical) {
                    $0.frame(width: variant.size)
                }
                .if(axis == .horizontal) {
                    $0.frame(height: variant.size)
                }
                .foregroundStyle(SwiftUI.Color.semantic(.lineNormal))
        }
    }
}

#Preview {
    ZStack {
        Basic.Divider(.vertical)
        Basic.Divider(.horizontal)
    }
    ZStack {
        Basic.Divider(.vertical, variant: .thick)
        Basic.Divider(.horizontal, variant: .thick)
    }
}
