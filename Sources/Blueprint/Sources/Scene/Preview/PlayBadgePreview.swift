//
//  PlayBadgePreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/14/25.
//

import SwiftUI
import Montage

struct PlayBadgePreview: View {
    @State var sizeIndex: Int = 0
    @State var isAlternative: Bool = false
    @State var backgroundImageIndex = 0
    
    let images = ["none", "wantedCircleSymbol", "Background", "placeholder"]
    let sizes: [PlayBadge.Size] = [
        .small,
        .medium,
        .large
    ]
    
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                ZStack {
                    Image(images[backgroundImageIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    PlayBadge()
                        .size(sizes[sizeIndex])
                        .alternative(isAlternative)
                }
                .frame(height: 400)
                Text("Options").bold()
                HStack {
                    Text("bg Image")
                    SegmentedControl(selectedIndex: $backgroundImageIndex, labels: images)
                        .size(.small)
                }
                HStack {
                    Text("alternative")
                    Control.Switch($isAlternative)
                }
                HStack {
                    Text("size")
                    SegmentedControl(selectedIndex: $sizeIndex, labels: sizes.map(\.description))
                        .size(.small)
                }
            }
        }
        .padding()
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

extension PlayBadge.Size: CaseDescribable {}

import Pretendard
#Preview {
    _ = try? Pretendard.registerFonts()
    return PlayBadgePreview()
}
