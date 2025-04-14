//
//  DotPaginationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct DotPaginationPreview: View {
    @State var selectedPage: Int = 1
    
    var body: some View {
        ZStack {
            SwiftUI.Color.clear
            Grid(horizontalSpacing: 30, verticalSpacing: 10) {
                ForEach(1...9, id: \.self) { totalPages in
                    GridRow {
                        Pagination.Dot(selectedPage: $selectedPage, totalPages: totalPages)
                        Pagination.Dot(selectedPage: $selectedPage, totalPages: totalPages)
                            .size(.small)
                    }
                    GridRow {
                        Group {
                            Pagination.Dot(selectedPage: $selectedPage, totalPages: totalPages)
                                .variant(.white)
                            Pagination.Dot(selectedPage: $selectedPage, totalPages: totalPages)
                                .variant(.white).size(.small)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(SwiftUI.Color.blue.opacity(0.5))
                                .frame(height: 20)
                                .padding(-10)
                        }
                    }
                    Text("\(selectedPage)/\(totalPages)")
                        .montage(variant: .caption1)
                }
                
                HStack {
                    SwiftUI.Button("Previous") {
                        if selectedPage > 1 {
                            selectedPage -= 1
                        }
                    }
                    SwiftUI.Button("Next") {
                        if selectedPage < 9 {
                            selectedPage += 1
                        }
                    }
                }
            }
            
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    DotPaginationPreview()
}
