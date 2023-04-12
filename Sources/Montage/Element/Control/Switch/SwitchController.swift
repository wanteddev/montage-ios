//
//  MontageSwitchController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

extension Control {
    /// ``Montage/Switch``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    public struct SwitchController: UIViewRepresentable {
        @Binding public var isOn: Bool
        
        public typealias UIViewType = Switch
        
        public func makeUIView(context: Context) -> UIViewType {
            .init(frame: .zero)
        }
        
        public func updateUIView(_ uiView: UIViewType, context: Context) {
            uiView.isOn = isOn
        }
    }
}
