//
//  SwiftUI+Debug.swift
//  Montage
//
//  Created by 김삼열 on 11/22/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func debugForPreview(_ color: SwiftUI.Color = .blue, fill: Bool = false) -> some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            if fill {
                background(color)
            } else {
                border(color)
            }
        } else {
            self
        }
    }

    @ViewBuilder
    func carveLog(_ message: String, font: Font? = nil, alignment: Alignment = .center) -> some View {
        #if DEBUG
        if CommandLine.arguments.contains("logCarving") {
            ZStack(alignment: alignment) {
                self
                SwiftUI.Button {
                    let pasteBoard = UIPasteboard.general
                    pasteBoard.string = message
                } label: {
                    StrokeText(text: message, font: font ?? .system(size: 12), color: .gray.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .padding(3)
                }
                .buttonStyle(.plain)
            }
        } else {
            self
        }
        #else
        self
        #endif
    }
}

private struct StrokeText: View {
    let text: String
    let font: Font
    let color: SwiftUI.Color

    var body: some View {
        Text(text)
            .font(font)
            .padding(.horizontal, 2)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .foregroundColor(color)
            )
    }
}
