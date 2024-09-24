//
//  RoundCheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/09/07.
//

import SwiftUI

extension Control {
    /// ``Montage/RoundCheckbox``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct RoundCheckboxController: UIViewRepresentable {
        @Binding private var state: MontageControlState
        private let size: RoundCheckbox.Size
        private let onTap: (UIViewType) -> Void
        private var isDisable: Bool = false
        
        public typealias UIViewType = RoundCheckbox
        
        public init(_ state: Binding<MontageControlState>, size: RoundCheckbox.Size, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = state
            self.size = size
            self.onTap = onTap
        }
        
        public init(state: MontageControlState, size: RoundCheckbox.Size, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = .constant(state)
            self.size = size
            self.onTap = onTap
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            let uiView = UIViewType()
            uiView.delegate = context.coordinator
            return uiView
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.state = state
            uiView.size = size
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
        
        public class Coordinator: RoundCheckboxControlDelegate {
            @Binding private var state: MontageControlState
            private let onTap: (UIViewType) -> Void
            
            init(state: Binding<MontageControlState>, onTap: @escaping (UIViewType) -> Void) {
                self._state = state
                self.onTap = onTap
            }
            
            public func didTappedCheckbox(_ checkbox: Control.RoundCheckbox) {
                onTap(checkbox)
            }
        }
    }
}

struct RoundCheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.RoundCheckboxController(state: .checked, size: .normal)
                .fixedSize()
        }
    }
}
