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
            _isOn = isOn
            self.size = size
            self.onChange = onChange
        }
        
        public init(isOn: Bool, size: Switch.Size = .normal, onChange: @escaping (Bool) -> Void = { _ in }) {
            _isOn = .constant(isOn)
            self.size = size
            self.onChange = onChange
        }
        
        @State private var isDisable: Bool = false

        public var body: some View {
            VStack {
                Toggle("", isOn: $isOn)
                    .tint(.alias(.primaryNormal))
                    .frame(width: switchSize.width, height: switchSize.height)
                    .offset(CGSize(width: -5, height: 0))
                    .transformEffect(CGAffineTransform(scaleX: containerSize.width / switchSize.width, y: containerSize.height / switchSize.height))
                    .frame(width: containerSize.width, height: containerSize.height)
                    .offset(CGSize(width: (switchSize.width - containerSize.width) / 2, height: (switchSize.height - containerSize.height) / 2))
                    .onChange(of: isOn) { newValue in
                        onChange(newValue)
                    }
                    .disabled(isDisable)
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
//    /// ``Montage/Switch``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
//    public struct SwitchController: UIViewRepresentable {
//        @Binding private var isOn: Bool
//        private let size: Switch.Size
//        private let onTap: (UIViewType) -> Void
//        private var isDisable: Bool = false
//        @State private var uiView: UIViewType
//
//        public typealias UIViewType = Switch
//        
//        public init(_ isOn: Binding<Bool>, size: Switch.Size, onTap: @escaping (UIViewType) -> Void = { _ in }) {
//            _isOn = isOn
//            self.size = size
//            self.onTap = onTap
//            uiView = UIViewType(size: size)
//        }
//        
//        public init(isOn: Bool, size: Switch.Size, onTap: @escaping (UIViewType) -> Void = { _ in }) {
//            _isOn = .constant(isOn)
//            self.size = size
//            self.onTap = onTap
//            uiView = UIViewType(size: size)
//        }
//        
//        public func makeUIView(context: Context) -> UIViewType {
//            print(#function)
////            let uiView = UIViewType(size: size)
//            uiView.delegate = context.coordinator
//            return uiView
//        }
//        
//        public func updateUIView(_ uiView: UIViewType, context: Context) {
//            print(#function)
//            self.uiView.isOn = isOn
//            self.uiView.disable = isDisable
//        }
//        
//        public func disable(_ isDisable: Bool = true) -> some View {
//            print(#function)
//            var view = self
//            view.isDisable = isDisable
//            return view
//        }
//        
//        public func makeCoordinator() -> Coordinator {
//            Coordinator(isOn: $isOn, onTap: onTap)
//        }
//        
//        public class Coordinator: SwitchControlDelegate {
//            @Binding private var isOn: Bool
//            private let onTap: (UIViewType) -> Void
//            
//            init(isOn: Binding<Bool>, onTap: @escaping (UIViewType) -> Void) {
//                _isOn = isOn
//                self.onTap = onTap
//            }
//            
//            public func didValueChangedSwitch(_ switch: Control.Switch) {
//                isOn = `switch`.isOn
//                onTap(`switch`)
//            }
//        }
    }
}
