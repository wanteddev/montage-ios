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
    var windowScene: UIWindowScene? { get }
}

public struct WindowSceneKey: EnvironmentKey {
    public static var defaultValue: UIWindowScene? {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegateProtocol)?.windowScene
    }
}
