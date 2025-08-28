//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

// MARK: - Internal

extension View {
    /// 조건에 따라 View를 변환합니다.
    ///
    /// - Parameters:
    ///   - condition: 변환 조건
    ///   - transform: 조건이 true일 때 적용할 변환
    ///   - alternative: 조건이 false일 때 적용할 변환 (선택적)
    /// - Returns: 변환된 View
    @ViewBuilder
    public func `if`(
        _ condition: Bool,
        _ transform: (Self) -> any View,
        else alternative: ((Self) -> any View)? = nil
    ) -> some View {
        if condition {
            AnyView(transform(self))
        } else if let alternative {
            AnyView(alternative(self))
        } else {
            self
        }
    }

    /// 조건이 true일 때만 View를 표시합니다.
    ///
    /// - Parameter condition: 표시 조건
    /// - Returns: 조건에 따라 표시되는 View
    @ViewBuilder
    public func `if`(_ condition: Bool) -> some View {
        if condition {
            self
        }
    }

    /// View를 변환합니다.
    ///
    /// - Parameter transform: 적용할 변환
    /// - Returns: 변환된 View
    public func modifying(_ transform: (Self) -> any View) -> some View {
        AnyView(transform(self))
    }

    /// View를 변환합니다.
    ///
    /// - Parameter transform: 적용할 변환
    /// - Returns: 변환된 View
    public func modifying(_ transform: (Self) -> Self) -> Self {
        transform(self)
    }

    /// View를 UIImage로 변환합니다.
    ///
    /// - Returns: 변환된 UIImage
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.windows?.first?.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }

    /// View의 지오메트리 변경정보를 디바운스시켜서 받습니다.
    ///
    /// - Parameters:
    ///   - type: 변환 타입
    ///   - transform: 지오메트리 변환
    ///   - dueTime: 디바운스 시간
    ///   - action: 변경 시 실행할 액션
    /// - Returns: 디바운스된 View
    public func onGeometryChange<T>(
        for type: T.Type,
        of transform: @escaping (GeometryProxy) -> T,
        for dueTime: RunLoop.SchedulerTimeType.Stride,
        action: @escaping (_ newValue: T) -> Void
    ) -> some View where T: Equatable {
        modifier(DebouncedGeometryChangeModifier(for: type, of: transform, for: dueTime, action: action))
    }
    
    /// View의 크기가 .zero일 때 액션을 수행합니다.
    ///
    /// - Parameter action: 크기가 .zero일 때 실행할 액션
    /// - Returns: 수정된 View
    public func ifEmptyView(_ action: @escaping (Bool) -> Void) -> some View {
        onGeometryChange(
            for: Bool.self,
            of: { $0.size == .zero },
            action: { action($0) }
        )
    }
}
