//
//  WindowSafeAreaModifier.swift
//  Montage
//
//  Created by 김삼열 on 10/28/26.
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import SwiftUI
import UIKit

/// 뷰가 놓인 window의 safe area 인셋과 크기.
public struct WindowSafeAreaMetrics: Equatable {
    /// window의 safe area 인셋.
    public var insets: EdgeInsets
    /// window 크기에서 safe area 인셋을 뺀 크기.
    public var size: CGSize

    /// - Parameters:
    ///   - insets: window의 safe area 인셋
    ///   - size: window 크기에서 safe area 인셋을 뺀 크기
    public init(insets: EdgeInsets, size: CGSize) {
        self.insets = insets
        self.size = size
    }

    /// 가장 최근에 읽은 window 값. 값을 받기 전 첫 프레임에 쓴다.
    static var lastRead: WindowSafeAreaMetrics? {
        WindowSafeAreaReader.lastMetrics
    }
}

/// 뷰가 놓인 window의 safe area 인셋을 담는 상태.
///
/// body 평가 중에 `UIWindow`의 safe area를 읽으면 AttributeGraph 순환이 생겨 화면 갱신이 멈출 수 있습니다.
/// 이 상태는 ``SwiftUI/View/readsWindowSafeArea(_:)``가 window에 붙은 UIKit 뷰의 콜백에서 읽은 값으로 갱신되므로
/// 렌더 중에 UIKit을 읽지 않습니다. 회전·창 크기 변경에 다시 갱신되고, 여러 window(멀티씬)에서는 각자 자기 window 값을 받습니다.
///
/// 값을 받기 전 첫 프레임에는 가장 최근에 읽은 window 값을 씁니다. 앱이 처음 그리는 화면만 0에서 시작합니다.
///
/// ```swift
/// @WindowSafeArea private var safeAreaInsets
///
/// var body: some View {
///     content
///         .padding(.bottom, safeAreaInsets.bottom)
///         .readsWindowSafeArea($safeAreaInsets)
/// }
/// ```
@propertyWrapper
public struct WindowSafeArea: DynamicProperty {
    @State private var insets: EdgeInsets

    /// 가장 최근에 읽은 window 값으로 시작합니다. 읽은 적이 없으면 0입니다.
    public init() {
        _insets = State(initialValue: WindowSafeAreaMetrics.lastRead?.insets ?? EdgeInsets())
    }

    /// window의 safe area 인셋.
    public var wrappedValue: EdgeInsets {
        get { insets }
        nonmutating set { insets = newValue }
    }

    /// ``SwiftUI/View/readsWindowSafeArea(_:)``에 넘길 바인딩.
    public var projectedValue: Binding<EdgeInsets> {
        $insets
    }
}

extension View {
    /// 이 뷰가 놓인 window의 safe area 인셋을 ``WindowSafeArea`` 상태에 넣습니다.
    ///
    /// - Parameter insets: ``WindowSafeArea``의 projected value(`$`)
    public func readsWindowSafeArea(_ insets: Binding<EdgeInsets>) -> some View {
        onWindowSafeAreaChange { insets.wrappedValue = $0.insets }
    }

    /// 이 뷰가 놓인 window의 safe area를 처음 한 번, 그리고 바뀔 때마다 알려 줍니다.
    ///
    /// 인셋만 필요하면 ``WindowSafeArea``와 ``readsWindowSafeArea(_:)``를 씁니다. 이 modifier는 safe area 크기까지
    /// 필요할 때 씁니다. window에 붙기 전에는 호출되지 않으므로 받기 전에 쓸 값을 정해 둡니다.
    ///
    /// - Parameter action: 바뀐 safe area를 받는 클로저
    public func onWindowSafeAreaChange(perform action: @escaping (WindowSafeAreaMetrics) -> Void) -> some View {
        background(WindowSafeAreaReader(action: action))
    }
}

private struct WindowSafeAreaReader: UIViewRepresentable {
    nonisolated(unsafe) static var lastMetrics: WindowSafeAreaMetrics?

    let action: (WindowSafeAreaMetrics) -> Void

    func makeUIView(context: Context) -> ReaderView {
        let view = ReaderView()
        view.isUserInteractionEnabled = false
        view.action = action
        return view
    }

    func updateUIView(_ uiView: ReaderView, context: Context) {
        uiView.action = action
    }

    final class ReaderView: UIView {
        var action: ((WindowSafeAreaMetrics) -> Void)?
        private var reportedValue: WindowSafeAreaMetrics?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            reportIfChanged()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            reportIfChanged()
        }

        override func safeAreaInsetsDidChange() {
            super.safeAreaInsetsDidChange()
            reportIfChanged()
        }

        /// 레이아웃 콜백 안에서 SwiftUI 상태를 바로 바꾸지 않도록 다음 런루프에 넘긴다.
        private func reportIfChanged() {
            guard let window else { return }
            let value = WindowSafeAreaMetrics(insets: window.safeAreaInsets.insets, size: window.safeAreaSize)
            WindowSafeAreaReader.lastMetrics = value
            guard value != reportedValue else { return }
            reportedValue = value
            DispatchQueue.main.async { [weak self] in
                self?.action?(value)
            }
        }
    }
}
