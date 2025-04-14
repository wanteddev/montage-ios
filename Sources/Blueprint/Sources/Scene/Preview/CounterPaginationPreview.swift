//
//  CounterPaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct CounterPaginationPreview: View {
    @State var selectedPage: Int = 1
    @State var sizeIndex: Int = 0
    @State var isAlternative: Bool = false
    @State var backgroundImageIndex = 0
    
    let images = ["none", "wantedCircleSymbol", "Background", "placeholder"]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                ZStack {
                    Image(images[backgroundImageIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 400)
                    Pagination.Counter(selectedPage: $selectedPage, totalPages: 10)
                        .size(Pagination.Counter.Size.allCases[sizeIndex])
                        .alternative(isAlternative)
                }
                Text("Options").bold()
                HStack {
                    Text("bg Image")
                    SegmentedControl(selectedIndex: $backgroundImageIndex, labels: images)
                        .size(.small)
                }
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
                    Control.Switch($isAlternative)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: Pagination.Counter.Size.allCases.map(\.rawValue))
                        .size(.small)
                }
            }
        }
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    CounterPaginationPreview()
}
