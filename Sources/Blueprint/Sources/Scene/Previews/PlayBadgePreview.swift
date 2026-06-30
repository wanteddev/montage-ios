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

    let sizes: [PlayBadge.Size] = [
        .small,
        .medium,
        .large
    ]

    var body: some View {
        PreviewLayout {
            PlayBadge()
                .size(sizes[sizeIndex])
                .alternative(isAlternative)
        } options: {
            ToggleOptionRow("alternative", isOn: $isAlternative)
            SegmentedIndexRow("size", index: $sizeIndex, labels: sizes.map(\.description))
        }
    }
}

extension PlayBadge.Size: CaseDescribable {}

#Preview {
    return PlayBadgePreview()
}
