//
//  PreferenceKey+.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/26/24.
//

import SwiftUI

// MARK: - OffsetPreferenceKey

struct OffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGPoint = .zero
    public static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {}
}
