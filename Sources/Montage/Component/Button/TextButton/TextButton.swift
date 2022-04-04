//
//  TextButton.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/15.
//

import SwiftUI

public struct TextButton: View {
    let title: String
    let style: Style
    let rightIcon: DesignSystem.Icon?
    let action: () -> Void

    public init(
        title: String,
        style: Style = .primary,
        rightIcon: DesignSystem.Icon? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.rightIcon = rightIcon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: Size.spacing) {
                Text(title)
                    .designSystem(ofSize: 14.0, weight: .bold)
                if let rightIcon = rightIcon {
                    Image(rightIcon.name, bundle: DesignSystem.bundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: Size.icon.width, height: Size.icon.height, alignment: .center)
                }
            }
        }
        .foregroundColor(style.color)
        .frame(
            idealHeight: Size.height,
            maxHeight: Size.height
        )
    }
}

struct TextButtonSampleView: View {
    var body: some View {
        VStack(spacing: 50.0) {
            TextButton(title: "더보기", style: .primary, rightIcon: .lineArrowRight12) {}
            TextButton(title: "더보기", style: .gray, rightIcon: .lineArrowRight12) {}
            TextButton(title: "자세히보기", style: .primary) {}
            TextButton(title: "자세히보기", style: .gray) {}
        }
    }
}

struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        TextButtonSampleView()
    }
}
