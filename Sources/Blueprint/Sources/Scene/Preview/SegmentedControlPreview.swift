//
//  SegmentedControlPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/13/24.
//

import SwiftUI
import Montage

struct SegmentedControlPreview: View {
    @State var selectedIndex: Int = 0
    var body: some View {
        ScrollView {
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { print($0) }
            )
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { _ in }
            )
            .size(.medium)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { _ in }
            )
            .size(.small)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { _ in }
            )
            .variant(.outlined)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { _ in }
            )
            .variant(.outlined)
            .size(.medium)
            
            SegmentedControl(
                selectedIndex: $selectedIndex,
                items: [.init(image: .icon(.android), title: "Android"), .init(image: .icon(.logoApple), title: "iOS"), .init(title: "Web"), .init(title: "ETC")],
                onSelect: { _ in }
            )
            .variant(.outlined)
            .size(.small)
        }
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    SegmentedControlPreview()
}
