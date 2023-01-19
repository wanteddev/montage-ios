//
//  MontageSampleView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/01/16.
//

import SwiftUI

public struct MontageSampleView: View {
    public var dismiss: (() -> Void)?
    
    public var body: some View {
        NavigationView {
            List {
                Group {
                    Text("Typography")
                    Text("Color")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Montage")
            .navigationBarItems(
                trailing: Button("닫기") { dismiss?() }
            )
        }
    }
    
    public init() {}
}

struct MontageSampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MontageSampleView()
        }
    }
}
