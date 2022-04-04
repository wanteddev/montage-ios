//
//  PrimaryButtonController.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/15.
//

import SwiftUI
import UIKit

/// PrimaryButton을 UIKit에서 사용하기 위한 UIHostingController 입니다.
public final class PrimaryButtonController: UIHostingController<PrimaryButton> {
    public convenience init(
        type: PrimaryButton.`Type`,
        size: PrimaryButton.Size,
        title: String,
        iconAlignment: PrimaryButton.IconAlignment? = nil,
        isDisable: Bool = false,
        width: PrimaryButtonWidth.Value? = nil,
        action: @escaping () -> Void
    ) {
        let button = PrimaryButton(
            type: type,
            size: size,
            title: title,
            iconAlignment: iconAlignment,
            isDisable: PrimaryButtonDisabledStatus(value: isDisable),
            width: width,
            action: action
        )

        self.init(rootView: button)

        view.backgroundColor = .clear
    }

    public func disabled(_ isDisable: Bool) {
        rootView.isDisable.value = isDisable
    }

    public func setTitle(_ title: String) {
        rootView.title.text = title
    }

    public func setWidth(_ width: PrimaryButtonWidth.Value) {
        rootView.width.value = width
    }
}
