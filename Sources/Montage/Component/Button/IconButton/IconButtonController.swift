//
//  IconButtonController.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI
import UIKit

/// IconButton을 UIKit에서 사용하기 위한 UIHostingController 입니다.
public final class IconButtonController: UIHostingController<IconButton> {
    public convenience init(
        style: IconButton.Style = .primary,
        icon: DesignSystem.Icon,
        action: @escaping () -> Void
    ) {
        let button = IconButton(
            style: style,
            icon: icon,
            action: action
        )

        self.init(rootView: button)

        view.backgroundColor = .clear
    }
}
