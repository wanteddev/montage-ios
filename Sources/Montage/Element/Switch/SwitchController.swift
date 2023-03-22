//
//  MontageSwitchController.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/28.
//

import SwiftUI

public extension Montage {
    /// ``Montage/Switch``를 SwiftUI에서 사용할 수 있도록 감싼 컨테이너 객체입니다.
    struct MontageSwitchController: UIViewRepresentable {
        @Binding public var isOn: Bool
        
        public typealias UIViewType = Montage.Switch
        
        public func makeUIView(context: Context) -> Montage.Switch {
            .init(frame: .zero)
        }
        
        public func updateUIView(_ uiView: Montage.Switch, context: Context) {
            uiView.isOn = isOn
        }
    }
}
