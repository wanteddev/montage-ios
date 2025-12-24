//
//  PlayBadgePreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/14/25.
//

import SwiftUI
import Montage

struct PlayBadgePreview: View {
    @State private var showTransparentChecker: Bool = false
    @State var sizeIndex: Int = 0
    @State var isAlternative: Bool = false
    
    let sizes: [PlayBadge.Size] = [
        .small,
        .medium,
        .large
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
                    PlayBadge()
                        .size(sizes[sizeIndex])
                        .alternative(isAlternative)
                    Spacer()
                }
                Text("Options").bold()
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
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension PlayBadge.Size: CaseDescribable {}

#Preview {
    return PlayBadgePreview()
}
