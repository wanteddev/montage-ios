//
//  InputLabelController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

/// ``Montage/InputLabel``을 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
public struct InputLabelController: UIViewRepresentable {
    private let inputView: MontageControl
    private let state: MontageControlState
    private let text: String
    private let onSelect: () -> Void

    public typealias UIViewType = InputLabel

    public init(
        inputView: MontageControl,
        state: MontageControlState,
        text: String,
        onSelect: @escaping () -> Void
    ) {
        self.inputView = inputView
        self.state = state
        self.text = text
        self.onSelect = onSelect
    }

    public func makeUIView(context: Context) -> UIViewType {
        let uiView = UIViewType(with: inputView)
        uiView.delegate = context.coordinator
        return uiView
    }

    public func updateUIView(_ uiView: UIViewType, context _: Context) {
        uiView.state = state
        uiView.text = text
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    public class Coordinator: NSObject, InputDelegate {
        let parent: InputLabelController

        init(parent: InputLabelController) {
            self.parent = parent
        }

        public func inputDidSelected(_: InputLabel) {
            parent.onSelect()
        }
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

    private var fillHorizontal = false
    private var fillVertical = false
    public func fill(horizontal fillHorizontal: Bool, vertical fillVertical: Bool) -> Self {
        var zelf = self
        zelf.fillHorizontal = fillHorizontal
        zelf.fillVertical = fillVertical
        return zelf
    }
}

struct MontageInputLabelController_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputLabelController(inputView: Control.Radio(), state: .checked, text: "체크해주세요!") {}
            InputLabelController(inputView: Control.Radio(), state: .unchecked, text: "체크해주세요!") {}
        }
    }
}
