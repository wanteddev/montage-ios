//
//  PullToRefreshPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI
import Montage

struct PullToRefreshPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var data: [Int] = Array(0...100)
    @State private var seconds: String = "3"
    @State private var scrollYOffset: CGFloat = 0
    @FocusState private var inputFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
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
            .padding()
            
            ScrollView(onOffsetChanged: { offset in
                scrollYOffset = offset.y
            }) {
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ForEach(data, id: \.self) { index in
                        HStack {
                            Spacer()
                            Text("row \(index)")
                            Spacer()
                        }
                        .padding()
                        .background(.blue)
                    }
                }
            }
            .onRefresh {
                do {
                    print("refreshing...")
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 * (Double(seconds) ?? 0)))
                    try Task.checkCancellation()
                    data = Array(0...100)
                } catch {
                    print(error)
                }
            }
            
            VStack(alignment: .leading) {
                Text("Options").bold()
                HStack {
                    Text("리프레시 시간")
                    TextField(text: $seconds)
                        .focused($inputFieldFocused)
                    Text("초")
                }
            }
            .font(.caption)
            .padding()
        }
        .onTapGesture {
            inputFieldFocused = false
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    PullToRefreshPreview()
}
