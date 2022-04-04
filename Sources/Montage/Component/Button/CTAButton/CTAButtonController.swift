//
//  CTAButtonController.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/22.
//

import SwiftUI
#if !os(macOS)
import UIKit
#endif

/// CTAButton을 UIKit에서 사용하기 위한 UIHostingController 입니다.
/// 기본 BackgroundColor는 elevatedBg 입니다.
public final class CTAButtonController: UIHostingController<CTAButton> {
    public convenience init(
        buttons: [PrimaryButton],
        currentDisabledStatus: CTAButton.DisabledStatus = .none,
        backgroundColor: DesignSystem.Color = .elevatedBg
    ) {
        let button = CTAButton(
            buttons: buttons,
            currentDisabledStatus: CTAButtonDisabledStatus(value: currentDisabledStatus),
            backgroundColor: backgroundColor
        )

        self.init(rootView: button)

        view.backgroundColor = .clear
    }

    public func disabled(at index: CTAButton.DisabledStatus) {
        rootView.currentDisabledStatus.value = index
    }
}
