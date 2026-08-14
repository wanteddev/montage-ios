//
//  MaterialBackground.swift
//  Views
//
//  Created by 김삼열 on 8/14/26.
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI

/// 반투명 틴트 컬러 아래에 시스템 머티리얼을 깔아 흐림 배경을 만드는 뷰입니다.
///
/// 디자인 시스템의 흐림 배경은 **머티리얼이 아래, 틴트 컬러가 위** 순서로 쌓입니다.
/// 순서가 뒤집히면 머티리얼의 틴트 필름이 컬러를 덮어 다크 모드에서 배경이 밝게 뜹니다.
/// 이 타입은 그 순서와 머티리얼 종류(`.bar`)를 고정해 사용처마다 어긋나지 않게 한다.
///
/// 대부분의 경우 직접 쓰지 않고 `materialBackground(in:materialOpacity:tint:)` 모디파이어를 사용한다.
/// 배경 레이어에 마스크 같은 추가 효과를 걸어야 할 때만 이 타입을 직접 쓴다.
///
/// ```swift
/// // 스크롤에 따라 흐림이 서서히 드러나고, floating일 때 상단이 페이드되는 네비게이션 배경
/// content.background {
///     MaterialBackground(materialOpacity: backgroundOpacity, tint: color.opacity(backgroundOpacity * 0.7))
///         .if(variant.isFloating) {
///             $0.mask { LinearGradient(colors: maskColors, startPoint: .bottom, endPoint: .top) }
///         }
/// }
/// ```
///
/// - Note: 모든 레이어를 `shape`로 직접 그리므로 `clipShape`가 필요 없고, 오프스크린 렌더링 패스도
///   발생하지 않는다.
struct MaterialBackground<S: Shape>: View {
    private let shape: S
    private let materialOpacity: Double
    private let tint: [SwiftUI.Color]

    /// 여러 겹의 틴트 컬러를 쌓는 흐림 배경을 초기화한다.
    ///
    /// - Parameters:
    ///   - shape: 배경을 그릴 모양. 기본값은 `Rectangle()`
    ///   - materialOpacity: 머티리얼 레이어의 불투명도. 스크롤에 따라 흐림을 서서히 드러낼 때 사용하며,
    ///     기본값 `1`은 머티리얼을 그대로 노출한다.
    ///   - tint: 머티리얼 위에 쌓을 틴트 컬러. `ZStack`과 같은 순서로, **배열 앞쪽이 아래**다.
    init(
        in shape: S = Rectangle(),
        materialOpacity: Double = 1,
        tint: [SwiftUI.Color] = []
    ) {
        self.shape = shape
        self.materialOpacity = materialOpacity
        self.tint = tint
    }

    /// 단일 틴트 컬러를 얹는 흐림 배경을 초기화한다.
    ///
    /// - Parameters:
    ///   - shape: 배경을 그릴 모양. 기본값은 `Rectangle()`
    ///   - materialOpacity: 머티리얼 레이어의 불투명도. 기본값 `1`은 머티리얼을 그대로 노출한다.
    ///   - tint: 머티리얼 위에 얹을 틴트 컬러
    init(
        in shape: S = Rectangle(),
        materialOpacity: Double = 1,
        tint: SwiftUI.Color
    ) {
        self.init(in: shape, materialOpacity: materialOpacity, tint: [tint])
    }

    var body: some View {
        ZStack {
            shape
                .fill(SwiftUI.Material.bar)
                .opacity(materialOpacity)
            ForEach(tint.indices, id: \.self) { index in
                shape.fill(tint[index])
            }
        }
    }
}

extension View {
    /// 현재 뷰 뒤에 흐림 배경을 깐다.
    ///
    /// 틴트 컬러 아래에 시스템 머티리얼을 깔아, 뒤 콘텐츠가 비쳐 보이는 반투명 표면을 만든다.
    /// 머티리얼과 틴트의 순서는 `MaterialBackground`가 고정하므로 사용처에서 신경 쓰지 않아도 된다.
    ///
    /// - Parameters:
    ///   - shape: 배경을 그릴 모양. 기본값은 `Rectangle()`
    ///   - materialOpacity: 머티리얼 레이어의 불투명도. 기본값 `1`은 머티리얼을 그대로 노출한다.
    ///   - tint: 머티리얼 위에 쌓을 틴트 컬러. `ZStack`과 같은 순서로, **배열 앞쪽이 아래**다.
    /// - Returns: 흐림 배경이 적용된 뷰
    ///
    /// ```swift
    /// // 단일 틴트
    /// content.materialBackground(
    ///     in: RoundedRectangle(cornerRadius: 12),
    ///     tint: .semantic(.surfaceElevatedPrimary).opacity(0.88)
    /// )
    ///
    /// // 두 겹 틴트 (배열 앞쪽이 아래)
    /// content.materialBackground(tint: [
    ///     .semantic(.surfaceNeutralInverse).opacity(0.46),
    ///     .semantic(.surfaceBrandPrimary).opacity(0.05),
    /// ])
    /// ```
    func materialBackground<S: Shape>(
        in shape: S = Rectangle(),
        materialOpacity: Double = 1,
        tint: [SwiftUI.Color] = []
    ) -> some View {
        background {
            MaterialBackground(in: shape, materialOpacity: materialOpacity, tint: tint)
        }
    }

    /// 현재 뷰 뒤에 단일 틴트 컬러의 흐림 배경을 깐다.
    ///
    /// - Parameters:
    ///   - shape: 배경을 그릴 모양. 기본값은 `Rectangle()`
    ///   - materialOpacity: 머티리얼 레이어의 불투명도. 기본값 `1`은 머티리얼을 그대로 노출한다.
    ///   - tint: 머티리얼 위에 얹을 틴트 컬러
    /// - Returns: 흐림 배경이 적용된 뷰
    func materialBackground<S: Shape>(
        in shape: S = Rectangle(),
        materialOpacity: Double = 1,
        tint: SwiftUI.Color
    ) -> some View {
        materialBackground(in: shape, materialOpacity: materialOpacity, tint: [tint])
    }
}
