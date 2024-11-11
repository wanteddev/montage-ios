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

// MARK: - SizePreferenceKey

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                SwiftUI.Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value _: inout CGRect, nextValue _: () -> CGRect) {}
}

extension View {
    func readFrame(_ frame: Binding<CGRect>) -> some View {
        background(
            GeometryReader { geometry in
                SwiftUI.Color.clear
                    .preference(key: FramePreferenceKey.self, value: geometry.frame(in: .global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self, perform: {
            frame.wrappedValue = $0
        })
    }
}


