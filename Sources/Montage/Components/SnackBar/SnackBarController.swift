//
//  SnackBarController.swift
//  
//
//  Created by Ahn Sang Hoon on 6/26/24.
//

import SwiftUI

public final class SnackBarController: UIHostingController<SnackBar> {
    public convenience init(_ model: SnackBar.Model) {
        self.init(rootView: SnackBar(
            heading: model.heading,
            description: model.description,
            extraContents: model.extraContents,
            action: model.action,
            handler: model.handler
        ))
        self.view.isHidden = true
        self.view.backgroundColor = .clear
    }
    
    public func update(_ model: SnackBar.Model) {
        self.rootView = SnackBar(
            heading: model.heading,
            description: model.description,
            extraContents: model.extraContents,
            action: model.action,
            handler: model.handler
        )
    }
    
    public func show() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.isHidden = false
            self?.view.alpha = 1
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.view.alpha = 0
        }) { [weak self] _ in
            self?.view.isHidden = true
        }
    }
}
