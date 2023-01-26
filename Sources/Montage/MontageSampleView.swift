//
//  MontageSampleView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/16.
//

import SwiftUI
import Pretendard

public struct MontageSampleView: View {
    public var dismiss: (() -> Void)?
    
    public var body: some View {
        NavigationView {
            List {
                Group {
                    Text("Typography")
                        .montage(varient: .body1, weight: .bold)
                    Text("Color")
                        .montage(varient: .body1, weight: .bold)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Montage")
        }
    }
    
    public init() {
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
