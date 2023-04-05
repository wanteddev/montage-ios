//
//  MontageSampleView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/16.
//

import SwiftUI
import Pretendard

public struct MontageSampleView: View {
    @State var inputView: MontageInput
    @State var inputState: MontageInputState
    @State var inputLabelText: String
    @State var isOn: Bool
    
    public var dismiss: (() -> Void)?
    
    public var body: some View {
        NavigationView {
            List {
                Group {
                    Text("Typography")
                        .montage(varient: .body1, weight: .bold)
                    Text("Color")
                        .montage(varient: .body1, weight: .bold)
                        .foregroundColor(.alias(.primaryNormal))
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Montage")
        }
    }
    
    public init() {
        self.inputView = Checkbox()
        self.inputState = .checked
        self.inputLabelText = "체크해주세용"
        self.isOn = true
        
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
