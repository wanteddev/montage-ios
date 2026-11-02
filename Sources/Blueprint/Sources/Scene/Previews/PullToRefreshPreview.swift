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
    // [비교용 임시] 갱신 중 높이 방식. 바꾸면 스크롤 뷰를 다시 만들어 새 컨트롤이 값을 읽게 한다.
    @State private var holdIndex = 0
    @FocusState private var inputFieldFocused: Bool

    private static let holdVariants = ["72", "60c", "60up"]

    var body: some View {
        PreviewLayout(mode: .floating) {
            Group {
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
            }
            .id(holdIndex)
        } options: {
            // 값을 먼저 저장해야 다시 만들어지는 컨트롤이 새 값을 읽는다.
            SegmentedIndexRow("갱신 중 높이", index: Binding {
                holdIndex
            } set: { index in
                UserDefaults.standard.set(Self.holdVariants[index], forKey: "PTR_VARIANT")
                holdIndex = index
            }, labels: ["① 72pt", "② 60pt 가운데", "③ 60pt 위로"])
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
        .onAppear {
            holdIndex = Self.holdVariants.firstIndex(of: UserDefaults.standard.string(forKey: "PTR_VARIANT") ?? "72") ?? 0
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
