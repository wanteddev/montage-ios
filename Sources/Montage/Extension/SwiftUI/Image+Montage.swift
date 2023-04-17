//
//  Image+Montage.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import SwiftUI

extension Image {
    private static func load(name: String) -> Image {
        Image(name, bundle: Bundle.module)
    }

    public static func montage(_ type: Icon) -> Image {
        load(name: type.name)
    }
}
