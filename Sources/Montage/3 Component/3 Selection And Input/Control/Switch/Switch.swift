//
//  Switch.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

extension Control {
    /// 켜기/끄기 상태 전환이 가능한 스위치 컴포넌트입니다.
    ///
    /// 사용자가 기능을 활성화하거나 비활성화할 수 있는 토글 스위치입니다.
    /// 작은 크기와 중간 크기 두 가지 옵션을 제공합니다.
    ///
    /// ```swift
    /// @State private var isOn = false
    ///
    /// // 기본 크기(small) 스위치
    /// Control.Switch($isOn) { newValue in
    ///     print("스위치 상태: \(newValue)")
    /// }
    ///
    /// // 중간 크기 스위치
    /// Control.Switch($isOn, size: .medium)
    /// ```
    ///
    /// - Note: 스위치가 켜진 상태에서는 기본 테마 색상(primaryNormal)을 사용합니다.
    public struct Switch: View {
        /// 스위치의 크기를 정의하는 열거형입니다.
        public enum Size {
            /// 작은 크기
            case small
            /// 중간 크기
            case medium
        }

        @Binding private var isOn: Bool
        private let size: Size
        private let onChange: (Bool) -> Void

        private let switchSize: CGSize = .init(width: 51, height: 31)

        /// 스위치 컴포넌트를 초기화합니다.
        ///
        /// - Parameters:
        ///   - isOn: 스위치의 켜짐/꺼짐 상태 바인딩
        ///   - size: 스위치 크기 (기본값: .small)
        ///   - onChange: 상태 변경 시 호출되는 클로저 (기본값: 빈 클로저)
        public init(
            _ isOn: Binding<Bool>,
            size: Size = .small,
            onChange: @escaping (Bool) -> Void = { _ in }
        ) {
            _isOn = isOn
            self.size = size
            self.onChange = onChange
        }

        public var body: some View {
            VStack {
                Toggle("", isOn: $isOn.didSet(execute: { newValue in
                    onChange(newValue)
                }))
                .tint(.semantic(.primaryNormal))
                .frame(width: switchSize.width, height: switchSize.height)
                .offset(CGSize(width: -5, height: 0))
                .transformEffect(CGAffineTransform(
                    scaleX: containerSize.width / switchSize.width,
                    y: containerSize.height / switchSize.height
                ))
                .frame(width: containerSize.width, height: containerSize.height)
                .offset(CGSize(
                    width: (switchSize.width - containerSize.width) / 2,
                    height: (switchSize.height - containerSize.height) / 2
                ))
            }
        }

        private var containerSize: CGSize {
            switch size {
            case .medium:
                .init(width: 52, height: 32)
            case .small:
                .init(width: 39, height: 24)
            }
        }
    }
}

private extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
