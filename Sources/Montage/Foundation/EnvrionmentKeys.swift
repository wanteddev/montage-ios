//
//  EnvrionmentKeys.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/12/24.
//

import SwiftUI

struct SafeAreaInsetsKey: EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        (UIApplication.keyWindow?.safeAreaInsets ?? .zero).insets
    }
}

public protocol SceneDelegateProtocol {
    var floatingWindow: FloatingWindow? { get }
}

public struct FloatingWindowKey: EnvironmentKey {
    public static var defaultValue: FloatingWindow? {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegateProtocol)?.floatingWindow
    }
}
