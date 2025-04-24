//
//  EnvrionmentKeys.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 7/12/24.
//

import SwiftUI

struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.keyWindow?.safeAreaInsets ?? .zero).insets
    }
}
