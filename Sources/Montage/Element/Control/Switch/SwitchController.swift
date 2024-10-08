//
//  MontageSwitchController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

extension Control {
    public struct SwitchController: View {
        @Binding private var isOn: Bool
        private let size: Switch.Size
        private let onChange: (Bool) -> Void
        
        private let switchSize: CGSize = .init(width: 51, height: 31)
        
        public init(_ isOn: Binding<Bool>, size: Switch.Size = .normal, onChange: @escaping (Bool) -> Void = { _ in }) {
            self._isOn = isOn
            self.size = size
            self.onChange = onChange
        }

        public var body: some View {
            VStack {
                Toggle("", isOn: $isOn.didSet(execute: { newValue in
                    onChange(newValue)
                }))
                .tint(.alias(.primaryNormal))
                .frame(width: switchSize.width, height: switchSize.height)
                .offset(CGSize(width: -5, height: 0))
                .transformEffect(CGAffineTransform(scaleX: containerSize.width / switchSize.width, y: containerSize.height / switchSize.height))
                .frame(width: containerSize.width, height: containerSize.height)
                .offset(CGSize(width: (switchSize.width - containerSize.width) / 2, height: (switchSize.height - containerSize.height) / 2))
            }
        }
        
        private var containerSize: CGSize {
            switch size {
            case .normal:
                return .init(width: 52, height: 32)
            case .small:
                return .init(width: 39, height: 24)
            }
        }
    }
}

private extension Binding {
    func didSet(execute: @escaping (Value) -> Void) -> Binding {
        return Binding(
            get: { self.wrappedValue },
            set: {
                self.wrappedValue = $0
                execute($0)
            }
        )
    }
}
