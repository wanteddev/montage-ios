//
//  ToastController.swift
//
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

public final class ToastController: UIHostingController<Toast> {
    private var animationWorkItem: DispatchWorkItem?
    
    public convenience init(_ model: Toast.Model) {
        self.init(rootView: Toast(model.variant, message: model.message))
        view.isHidden = true
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }
    
    public func update(_ model: Toast.Model) {
        rootView = Toast(model.variant, message: model.message)
    }

    public func show() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.isHidden = false
            self?.view.alpha = 1
        }

        animationWorkItem?.cancel()
        
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        let task = DispatchWorkItem { [weak self] in
            self?.hide()
        }
        
        animationWorkItem = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: task)
    }
    
    public func hide() {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.view.alpha = 0
            },
            completion: { [weak self] _ in
                self?.view.isHidden = true
            }
        )

        animationWorkItem = nil
    }
}
