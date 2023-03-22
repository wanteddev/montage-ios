//
//  InputLabelController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

public extension Montage {
    /// ``Montage/InputLabel``을 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    struct InputLabelController: UIViewRepresentable {
        @State public var inputView: MontageInput
        @State public var state: MontageInputState
        @State public var text: String

        public typealias UIViewType = Montage.InputLabel

        public func makeUIView(context: Context) -> Montage.InputLabel {
            .init(with: inputView)
        }

        public func updateUIView(_ uiView: Montage.InputLabel, context: Context) {
            uiView.state = state
            uiView.text = text
        }
    }
}

struct MontageInputLabelController_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Montage.InputLabelController(
                inputView: Montage.Radio(),
                state: .checked,
                text: "체크해주세요!"
            ).fixedSize()
            Montage.InputLabelController(
                inputView: Montage.Radio(),
                state: .unchecked,
                text: "체크해주세요!"
            ).fixedSize()
        }
    }
}

