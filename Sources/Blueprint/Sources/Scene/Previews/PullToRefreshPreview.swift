//
//  PullToRefreshPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI
import Montage

struct PullToRefreshPreview: View {
    @State private var data: [Int] = Array(0...100)
    @State private var seconds: String = "3"
    @State private var containerIndex = 0
    @FocusState private var inputFieldFocused: Bool

    var body: some View {
        PreviewLayout(mode: .floating) {
            if containerIndex == 0 {
                ScrollView {
                    rows
                }
                .onRefresh {
                    await refresh()
                }
            } else {
                SwiftUI.ScrollView {
                    rows
                }
                .pullToRefresh {
                    await refresh()
                }
            }
        } options: {
            HStack {
                Text("리프레시 시간")
                TextField(text: $seconds)
                    .focused($inputFieldFocused)
                Text("초")
            }
            SegmentedIndexRow("container", index: $containerIndex, labels: ["ScrollView", "SwiftUI.ScrollView"])
        }
        .onTapGesture {
            inputFieldFocused = false
        }
    }

    private var rows: some View {
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
        .padding(.horizontal)
    }

    private func refresh() async {
        do {
            print("refreshing...")
            try await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 * (Double(seconds) ?? 0)))
            try Task.checkCancellation()
            data = Array(0...100)
        } catch {
            print(error)
        }
    }
}

#Preview {
    PullToRefreshPreview()
}
