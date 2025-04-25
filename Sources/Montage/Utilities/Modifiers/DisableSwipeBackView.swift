//
//  DisableSwipeBackView.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import SwiftUI

struct DisableSwipeBackView: UIViewControllerRepresentable {
    private let disabled: Bool

    init(disabled: Bool) {
        self.disabled = disabled
    }

    func makeUIViewController(context _: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context _: Context) {
        uiViewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = !disabled
        uiViewController.navigationController?.navigationBar.isUserInteractionEnabled = !disabled
    }
}

// MARK: - View Extension

extension View {
    /// 뷰에서 스와이프 백 제스처를 비활성화하는 modifier를 적용합니다.
    ///
    /// 네비게이션 컨트롤러의 스와이프 뒤로가기 제스처 인식기를 제어합니다.
    ///
    /// - Parameters:
    ///   - disabled: 스와이프 백 제스처 비활성화 여부
    /// - Returns: 스와이프 백 제스처가 제어된 뷰
    public func disableSwipeBack(_ disabled: Bool) -> some View {
        background(
            DisableSwipeBackView(disabled: disabled)
        )
    }
}
