//
//  NestedCheckController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/03/02.
//

import SwiftUI

/// ``Montage/NestedCheck``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
struct NestedCheckController: UIViewRepresentable {
    @State public var state: MontageInputState
    
    public typealias UIViewType = NestedCheck
    
    public func makeUIView(context: Context) -> UIViewType {
        .init()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.state = state
    }
}

struct MontageNestedCheckController_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NestedCheckController(state: .checked)
                .frame(width: 24, height: 24)
        }
    }
}
