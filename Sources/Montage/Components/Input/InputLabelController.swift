//
//  InputLabelController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/10.
//

import SwiftUI

/// ``Montage/InputLabel``을 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
struct InputLabelController: UIViewRepresentable {
    @State public var inputView: MontageInput
    @State public var state: MontageInputState
    @State public var text: String

    public typealias UIViewType = InputLabel

    public func makeUIView(context: Context) -> UIViewType {
        .init(with: inputView)
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.state = state
        uiView.text = text
    }
}

struct MontageInputLabelController_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputLabelController(inputView: Radio(), state: .checked, text: "체크해주세요!").fixedSize()
            InputLabelController(inputView: Radio(), state: .unchecked, text: "체크해주세요!").fixedSize()
        }
    }
}

