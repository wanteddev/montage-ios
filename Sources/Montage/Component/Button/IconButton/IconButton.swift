//
//  IconButton.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI

public struct IconButton: View {
    let style: Style
    let icon: DesignSystem.Icon
    let action: () -> Void

    public init(
        style: Style = .primary,
        icon: DesignSystem.Icon,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.icon = icon
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(icon.name, bundle: DesignSystem.bundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Size.icon.width, height: Size.icon.height, alignment: .center)
                .foregroundColor(style.foregroundColor)
        }
        .frame(
            idealWidth: Size.button.width,
            maxWidth: Size.button.width,
            idealHeight: Size.button.height,
            maxHeight: Size.button.height
        )
        .background(style.backgroundColor)
        .cornerRadius(Size.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Size.cornerRadius)
                .stroke(style.borderColor, lineWidth: 1.0)
        )
    }
}

struct IconButtonSampleView: View {
    var body: some View {
        HStack(spacing: 30.0) {
            IconButton(style: .primary, icon: .lineShareLink24) {}
            IconButton(style: .blue, icon: .lineShareLink24) {}
            IconButton(style: .black, icon: .lineShareLink24) {}
        }
    }
}

struct IconButton_Preview: PreviewProvider {
    static var previews: some View {
        IconButtonSampleView()
    }
}
