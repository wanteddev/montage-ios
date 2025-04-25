//
//  UIView+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import UIKit

extension UIView {
    var isSwiftUIView: Bool {
        ["CGDrawingView", "_UIGraphicsView", "PlatformGroupContainer"]
            .contains(String(describing: classForCoder))
    }

    var isUIHostingView: Bool {
        String(describing: classForCoder).starts(with: "_UIHostingView")
    }

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    func getPixelColor(at point: CGPoint) -> UIColor? {
        asImage().cgImage?.getPixelColor(at: point)
    }

    func isTransparent(at point: CGPoint) -> Bool {
        getPixelColor(at: point) == UIColor.rgb(0, 0, 0, 0)
    }

    func isBranched(from view: UIView) -> Bool {
        var ancestor: UIView? = self
        while ancestor != nil {
            if ancestor == view { return true }
            ancestor = ancestor?.superview
        }
        return false
    }

    func findViewInAncestors<T>(typeOf _: T.Type) -> UIView? {
        var ancestor: UIView? = self
        while ancestor != nil {
            if ancestor is T { return ancestor }
            ancestor = ancestor?.superview
        }
        return nil
    }
}
