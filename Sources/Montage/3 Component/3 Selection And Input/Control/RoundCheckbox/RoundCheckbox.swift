//
//  RoundCheckbox.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/09/07.
//

import SwiftUI

extension Control {
    @available(*, deprecated, message: "Use Montage/Checkbox instead.")
    public struct RoundCheckbox: UIViewRepresentable {
        @Binding private var state: MontageControlState
        private let size: MontageControlSize
        private let onTap: (UIViewType) -> Void
        private var isDisable = false
        
        public typealias UIViewType = RoundCheckboxUIView
        
        public init(
            _ state: Binding<MontageControlState>,
            size: MontageControlSize = .normal,
            onTap: @escaping (UIViewType) -> Void = { _ in }
        ) {
            _state = state
            self.size = size
            self.onTap = onTap
        }
        
        public init(
            _ state: Binding<Bool>,
            size: MontageControlSize = .normal,
            onTap: @escaping (UIViewType) -> Void = { _ in }
        ) {
            _state = Binding(get: {
                state.wrappedValue ? .checked : .unchecked
            }, set: { value in
                state.wrappedValue = value == .checked ? true : false
            })
            self.size = size
            self.onTap = onTap
        }
        
        public init(
            state: MontageControlState,
            size: MontageControlSize = .normal,
            onTap: @escaping (UIViewType) -> Void = { _ in }
        ) {
            _state = .constant(state)
            self.size = size
            self.onTap = onTap
        }
        
        public func makeUIView(context: Context) -> UIViewType {
            let uiView = UIViewType(size: size)
            uiView.delegate = context.coordinator
            return uiView
        }
        
        public func updateUIView(_ uiView: UIViewType, context _: Context) {
            uiView.state = state
            uiView.disable = isDisable
        }
        
        public func sizeThatFits(
            _ proposal: ProposedViewSize,
            uiView: UIViewType,
            context _: Context
        ) -> CGSize? {
            CGSize(
                width: fillHorizontal ? proposal.width ?? 0 : uiView.intrinsicContentSize.width,
                height: fillVertical ? proposal.height ?? 0 : uiView.intrinsicContentSize.height
            )
        }
        
        public func makeCoordinator() -> Coordinator {
            Coordinator(state: $state, onTap: onTap)
        }
        
        public class Coordinator: RoundCheckboxControlDelegate {
            @Binding private var state: MontageControlState
            private let onTap: (UIViewType) -> Void
            
            init(state: Binding<MontageControlState>, onTap: @escaping (UIViewType) -> Void) {
                _state = state
                self.onTap = onTap
            }
            
            public func didTappedCheckbox(_ checkbox: Control.RoundCheckboxUIView) {
                state = checkbox.state
                onTap(checkbox)
            }
        }
        
        private var fillHorizontal = false
        private var fillVertical = false
        public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
            var zelf = self
            zelf.fillHorizontal = fillHorizontal
            zelf.fillVertical = fillVertical
            return zelf
        }
        
        public func disable(_ isDisable: Bool = true) -> Self {
            var view = self
            view.isDisable = isDisable
            return view
        }
    }
}

struct RoundCheckboxController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Control.RoundCheckbox(state: .checked)
        }
    }
}
