//
//  DotPaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct DotPaginationPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var selectedPage: Int = 1
    @State private var totalPages: Int = 5
    @State private var variantIndex: Int = 0
    @State private var sizeIndex: Int = 0
    
    private let variants: [DotPagination.Variant] = [.normal, .white]
    private let sizes: [DotPagination.Size] = [.normal, .small]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
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
                
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        DotPagination(selectedPage: $selectedPage, totalPages: totalPages)
                            .variant(variants[variantIndex])
                            .size(sizes[sizeIndex])
                        Spacer()
                    }
                    
                    Text("\(selectedPage) / \(totalPages)")
                        .typography(variant: .body1, weight: .medium)
                }
                
                Text("Options").bold()
                
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: variants.map(\.description)
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("size")
                    SegmentedControl(
                        selectedIndex: $sizeIndex,
                        labels: sizes.map(\.description)
                    )
                    .size(.small)
                }
                
                HStack {
                    Text("totalPages")
                    SwiftUI.Slider(value: Binding(
                        get: { Double(totalPages) },
                        set: { totalPages = Int($0) }
                    ), in: 1...10, step: 1)
                    Text("\(totalPages)")
                        .frame(width: 30)
                }
                
                HStack {
                    Spacer()
                    Button(variant: .outlined, text: "Previous") {
                        if selectedPage > 1 {
                            selectedPage -= 1
                        }
                    }
                    .disable(selectedPage <= 1)
                    
                    Button(variant: .outlined, text: "Next") {
                        if selectedPage < totalPages {
                            selectedPage += 1
                        }
                    }
                    .disable(selectedPage >= totalPages)
                    Spacer()
                }
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension DotPagination.Variant: CaseDescribable {}
extension DotPagination.Size: CaseDescribable {}

#Preview {
    DotPaginationPreview()
}
