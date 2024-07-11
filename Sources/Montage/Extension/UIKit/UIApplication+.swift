//
//  UIApplication+.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/12/24.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? { windows?.first(where: \.isKeyWindow)
    }
    
    static var windows: [UIWindow]? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows
    }
}
