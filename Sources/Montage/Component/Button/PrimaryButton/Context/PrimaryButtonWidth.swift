//
//  PrimaryButtonWidth.swift
//  Montage
//
//  Created by 정국희 on 2021/11/12.
//

import SwiftUI

public final class PrimaryButtonWidth: ObservableObject {
    @Published public var value: Value?

    public init(value: Value?) {
        self.value = value
    }
}

// MARK: - Value

public extension PrimaryButtonWidth {
    struct Value {
        public let fixedSize: Bool
        public let minWidth: CGFloat?
        public let maxWidth: CGFloat?

        public init(
            fixedSize: Bool,
            minWidth: CGFloat?,
            maxWidth: CGFloat?
        ) {
            self.fixedSize = fixedSize
            self.minWidth = minWidth
            self.maxWidth = maxWidth
        }
    }
}
