//
//  MontageSampleView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/16.
//

import Pretendard
import SwiftUI

public struct MontageSampleView: View {
    @State var inputState: MontageControlState
    @State var inputView: MontageControl
    @State var inputLabelText: String
    @State var isOn: Bool

    public var dismiss: (() -> Void)?

    public var body: some View {
        NavigationView {
            SwiftUI.List {
                Group {
                    Text("Typography")
                        .montage(variant: .body1, weight: .bold)
                    Text("Color")
                        .montage(variant: .body1, weight: .bold)
                        .foregroundColor(.alias(.primaryNormal))
                    Image.montage(.apps)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Montage")
        }
    }

    public init() {
        inputView = Control.CheckboxUIView()
        inputState = .checked
        inputLabelText = "체크해주세용"
        isOn = true

        do {
            try Pretendard.registerFonts()
        } catch {
            debugPrint(error)
        }
    }
}

struct MontageSampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MontageSampleView()
        }
    }
}
