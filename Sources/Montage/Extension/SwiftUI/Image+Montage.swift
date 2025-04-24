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

    /// 사용하는 쪽에서 색상 변경이 자유롭게 가능합니다.
    /// 이를 위해서는 templete 모드로 전환합니다.
    /// 사용하는 쪽에서 사이즈 변경이 자유롭게 가능합니다.
    public static func montage(_ type: Icon) -> Image {
        load(name: type.name)
    }

    /// 원티드 로고 이미지 입니다.
    /// [Figma](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=16215-13483) 에서 모양을 미리 확인할 수 있습니다.
    public static func montage(_ type: Logo) -> Image {
        load(name: type.name)
    }
}
