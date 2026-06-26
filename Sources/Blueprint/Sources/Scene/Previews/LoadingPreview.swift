//
//  LoadingPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/14/24.
//

import SwiftUI
import Montage

struct LoadingPreview: View {
    @State var isLoading: Bool = false
    @State var typeOption: TypeOption = .circular
    // .clear이면 기본 색(circular spinner 기본 색)을 쓴다.
    @State var color: SwiftUI.Color = .clear
    // .clear이면 dimmer를 적용하지 않는다.
    @State var dimmerColor: SwiftUI.Color = .semantic(.materialDimmer)
    @State var timeout: TimeInterval = 3

    enum TypeOption: String, CaseIterable, PreviewSegment {
        case circular, wanted
    }

    private var loadingType: Loading.Kind {
        switch typeOption {
        case .circular: return .circular(color: color == .clear ? nil : color)
        case .wanted: return .wanted
        }
    }

    var body: some View {
        PreviewLayout(mode: .floating) {
            VStack {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
                Button(text: "Load") {
                    isLoading.toggle()
                }
                .fillWidth()
                Spacer()
            }
            .padding(.horizontal)
            .loading($isLoading, type: loadingType, dimmedColor: dimmerColor)
        } options: {
            SegmentedOptionRow("type", selection: $typeOption)
            if typeOption == .circular {
                ColorPickerOptionRow("color", selection: $color)
            }
            ColorPickerOptionRow("dimmer", selection: $dimmerColor)
            SliderOptionRow("timer", value: $timeout, in: 0...10, step: 1) {
                "\(Int($0))초"
            }
        }
        .onChange(of: isLoading) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
                    isLoading.toggle()
                }
            }
        }
    }
}

#Preview {
    LoadingPreview()
}
