//
//  CheckboxController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

extension Control {
    /// ``Montage/Checkbox``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct CheckboxController: UIViewRepresentable {
        @Binding private var state: MontageControlState
        private let size: MontageControlSize
        private let onTap: (UIViewType) -> Void
        private var isDisable: Bool = false
        
        public typealias UIViewType = Checkbox
        
        public init(_ state: Binding<MontageControlState>, size: MontageControlSize = .normal, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = state
            self.size = size
            self.onTap = onTap
        }
        
        public init(_ state: Binding<Bool>, size: MontageControlSize = .normal, onTap: @escaping (UIViewType) -> Void = { _ in }) {
            _state = Binding(get: {
                state.wrappedValue ? .checked : .unchecked
            }, set: { value in
                state.wrappedValue = value == .checked ? true : false
            })
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
        
        public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIViewType, context: Context) -> CGSize? {
            CGSize(
                width: fillWidth ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillHeight ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        public func makeCoordinator() -> Coordinator {
            Coordinator(state: $state, onTap: onTap)
        }
        
        public class Coordinator: CheckboxControlDelegate {
            @Binding private var state: MontageControlState
            private let onTap: (UIViewType) -> Void

            init(state: Binding<MontageControlState>, onTap: @escaping (UIViewType) -> Void) {
                self._state = state
                self.onTap = onTap
            }
            
            public func didTappedCheckbox(_ checkbox: UIViewType) {
                state = checkbox.state
                onTap(checkbox)
            }
        }
        
        private var fillWidth: Bool = false
        private var fillHeight: Bool = false
        public func fill(width fillWidth: Bool, height fillHeight: Bool) -> Self {
            var zelf = self
            zelf.fillWidth = fillWidth
            zelf.fillHeight = fillHeight
            return zelf
        }
        
        public func disable(_ isDisable: Bool = true) -> Self {
            var view = self
            view.isDisable = isDisable
            return view
        }
    }
}

struct CheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.CheckboxController(state: .checked, size: .small)
        }
    }
}
