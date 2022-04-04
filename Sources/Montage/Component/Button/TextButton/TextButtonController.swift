//
//  TextButtonController.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI
import UIKit

/// TextButton을 UIKit에서 사용하기 위한 UIHostingController 입니다.
public final class TextButtonController: UIHostingController<TextButton> {
    public convenience init(
        title: String,
        style: TextButton.Style = .primary,
        rightIcon: DesignSystem.Icon? = nil,
        action: @escaping () -> Void
    ) {
        let button = TextButton(
            title: title,
            style: style,
            rightIcon: rightIcon,
            action: action
        )

        self.init(rootView: button)

        view.backgroundColor = .clear
    }
}
