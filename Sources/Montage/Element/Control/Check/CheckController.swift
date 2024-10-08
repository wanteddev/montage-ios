//
//  CheckController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import SwiftUI

extension Control {
    /// ``Montage/Check``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct CheckController: UIViewRepresentable {
        @Binding private var state: MontageControlState
        private let size: MontageControlSize
        private let onTap: (UIViewType) -> Void
        private var isDisable: Bool = false
        
        public typealias UIViewType = Check
        
        public init(_ state: Binding<MontageControlState>, size: MontageControlSize = .normal, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = state
            self.size = size
            self.onTap = onTap
        }
        
        public init(state: MontageControlState, size: MontageControlSize = .normal, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = .constant(state)
            self.size = size
            self.onTap = onTap
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            let uiView = UIViewType(size: size)
            uiView.delegate = context.coordinator
            return uiView
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
            uiView.disable = isDisable
        }
        
        public func disable(_ isDisable: Bool = true) -> Self {
            var view = self
            view.isDisable = isDisable
            return view
        }
        
        public func makeCoordinator() -> Coordinator {
            Coordinator(state: $state, onTap: onTap)
        }
        
        public class Coordinator: CheckControlDelegate {
            @Binding private var state: MontageControlState
            private let onTap: (UIViewType) -> Void

            init(state: Binding<MontageControlState>, onTap: @escaping (UIViewType) -> Void) {
                self._state = state
                self.onTap = onTap
            }
            
            public func didTappedCheck(_ check: UIViewType) {
                state = check.state
                onTap(check)
            }
        }
    }
}

struct MontageCheckController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.CheckController(state: .checked, size: .small)
                .fixedSize()
        }
    }
}
