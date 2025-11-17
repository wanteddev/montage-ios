//
//  CounterPaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct CounterPaginationPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State var selectedPage: Int = 1
    @State var sizeIndex: Int = 0
    @State var isAlternative: Bool = false
    
    private let sizes: [CounterPagination.Size] = [
        .small,
        .medium
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
                    CounterPagination(selectedPage: $selectedPage, totalPages: 10)
                        .size(sizes[sizeIndex])
                        .alternative(isAlternative)
                    Spacer()
                }
                Text("Options").bold()
                HStack {
                    Text("page")
                    SwiftUI.Button("Previous") {
                        if selectedPage > 1 {
                            selectedPage -= 1
                        }
                    }
                    SwiftUI.Button("Next") {
                        if selectedPage < 10 {
                            selectedPage += 1
                        }
                    }
                }
                HStack {
                    Text("alternative")
                    Control.switch(checked: isAlternative) { isAlternative = $0 }
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
            }
        }
        .padding()
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension CounterPagination.Size: CaseDescribable {}

#Preview {
    CounterPaginationPreview()
}
