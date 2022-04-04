//
//  MontageSampleView.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/21.
//

import SwiftUI

public struct DesignSystemSampleView: View {
    public var dismiss: (() -> Void)?
    
    public var body: some View {
        NavigationView {
            List {
                Section(header: Text("Button")) {
                    NavigationLink(
                        "Button",
                        destination: PrimaryButtonSampleView()
                    )
                    NavigationLink(
                        "CTA Button",
                        destination: CTAButtonSample()
                    )
                    NavigationLink(
                        "Icon Button",
                        destination: IconButtonSampleView()
                    )
                    NavigationLink(
                        "Text Button",
                        destination: TextButtonSampleView()
                    )
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Design System")
            .navigationBarItems(
                trailing: Button("닫기") { dismiss?() }
            )
        }
    }
    
    public init() {}
}

struct DesignSystemSampleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DesignSystemSampleView()
        }
    }
}
