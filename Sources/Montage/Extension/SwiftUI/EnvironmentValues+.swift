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

    public var floatingWindow: FloatingWindow? {
        self[FloatingWindowKey.self]
    }
}
