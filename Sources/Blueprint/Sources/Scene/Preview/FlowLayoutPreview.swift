//
//  FlowLayoutPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 4/9/25.
//

import SwiftUI
import Montage

struct FlowLayoutPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var itemCount: CGFloat = 96
    @State private var spacing: CGFloat = 8
    @State private var lineSpacing: CGFloat = 8
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                ScrollView {
                    ZStack {
                        SwiftUI.Color.clear
                            .frame(height: 1)
                        
                        FlowLayout(spacing: spacing, lineSpacing: lineSpacing) {
                            ForEach(0 ..< Int(itemCount), id: \.self) { i in
                                ActionChip(text: "\(i+1)")
                                    .backgroundColor(.accentColor)
                                    .fontColor(.white)
                            }
                        }
                    }
                }
                Text("Options").bold()
                HStack {
                    Text("Item Count:")
                    SwiftUI.Slider(value: $itemCount, in: 0...100, step: 1)
                }
                HStack {
                    Text("Spacing:")
                    SwiftUI.Slider(value: $spacing, in: 0...20, step: 1)
                }
                HStack {
                    Text("Line Spacing:")
                    SwiftUI.Slider(value: $lineSpacing, in: 0...20, step: 1)
                }
            }
            .padding(.horizontal)
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

#Preview(body: {
    FlowLayoutPreview()
})
