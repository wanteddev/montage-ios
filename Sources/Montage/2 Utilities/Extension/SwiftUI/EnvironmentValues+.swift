//
//  EnvironmentValues+.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/12/24.
//

import SwiftUI

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.keyWindow?.safeAreaInsets ?? .zero).insets
    }
}
