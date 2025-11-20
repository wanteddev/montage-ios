//
//  PageCounterPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import Montage
import SwiftUI

struct PageCounterPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State var selectedPage: Int = 1
    @State var sizeIndex: Int = 0
    @State var totalPages: Int = 5
    @State var isAlternative: Bool = false

    private let sizes: [PageCounter.Size] = [
        .small,
        .medium,
    ]

    var body: some View {
        SwiftUI.ScrollView {
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
                HStack {
                    Spacer()
                    PageCounter(selectedPage: $selectedPage, totalPages: totalPages)
                        .size(sizes[sizeIndex])
                        .alternative(isAlternative)
                    Spacer()
                }
                Text("Options").bold()
                HStack {
                    Spacer()
                    Button(variant: .outlined, size: .small, text: "Previous") {
                        if selectedPage > 1 {
                            selectedPage -= 1
                        }
                    }
                    .disable(selectedPage <= 1)

                    Button(variant: .outlined, size: .small, text: "Next") {
                        if selectedPage < totalPages {
                            selectedPage += 1
                        }
                    }
                    .disable(selectedPage >= totalPages)
                    Spacer()
                }

                HStack {
                    Text("totalPages")
                    SwiftUI.Slider(
                        value: Binding(
                            get: { Double(totalPages) },
                            set: { totalPages = Int($0) }
                        ), in: 1...10, step: 1)
                    Text("\(totalPages)")
                        .frame(width: 30)
                }

                HStack {
                    Text("alternative")
                    Switch(checked: isAlternative) { isAlternative = $0 }
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
            }
        }
        .padding()
        .transparentChecking(
            isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red
        )
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension PageCounter.Size: CaseDescribable {}

#Preview {
    PageCounterPreview()
}
