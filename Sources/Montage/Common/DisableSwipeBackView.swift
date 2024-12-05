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
