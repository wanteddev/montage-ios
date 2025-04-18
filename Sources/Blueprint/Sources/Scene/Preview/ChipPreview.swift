//
//  ChipPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 7/24/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct ChipPreview: View {
    enum ChipStyle: String, CaseIterable, Identifiable {
        case action
        case filter
        
        var id: String { self.rawValue }
    }
    var body: some View {
        List(ChipStyle.allCases) { style in
            NavigationLink(
                destination: {
                    switch style {
                    case .action:
                        ActionChipPreview()
                    case .filter:
                        FilterChipPreview()
                    }
                }, label: {
                    Text(style.rawValue.capitalized)
                }
            )
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

struct ActionChipPreview: View {
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                VStack(alignment: .leading) {
                    Text("Variant").montage(variant: .headline2)
                    HStack {
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Disable").montage(variant: .headline2)
                    HStack {
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요",
                            disable: false
                        )
                        
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요",
                            disable: true
                        )
                    }
                    HStack {
                        Chip.Action(
                            variant: .outlined,
                            text: "안녕하세요",
                            disable: false
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            text: "안녕하세요",
                            disable: true
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Active").montage(variant: .headline2)
                    HStack {
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요",
                            active: true
                        )
                    }
                    HStack {
                        Chip.Action(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            text: "안녕하세요",
                            active: true
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Size").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .solid,
                            size: .xsmall,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .solid,
                            size: .small,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .solid,
                            size: .medium,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .solid,
                            size: .large,
                            text: "안녕하세요"
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .outlined,
                            size: .xsmall,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            size: .small,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            size: .medium,
                            text: "안녕하세요"
                        )
                        
                        Chip.Action(
                            variant: .outlined,
                            size: .large,
                            text: "안녕하세요"
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Icon").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .solid,
                            size: .xsmall,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        
                        Chip.Action(
                            variant: .solid,
                            size: .small,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                    }
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .outlined,
                            size: .medium,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        
                        Chip.Action(
                            variant: .outlined,
                            size: .large,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Customize").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .solid,
                            size: .xsmall,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        .imageColor(.semantic(.accentBackgroundViolet))
                        
                        Chip.Action(
                            variant: .solid,
                            size: .small,
                            text: "안녕하세요",
                            backgroundColor: .semantic(.accentBackgroundRedOrange)
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        .imageColor(.semantic(.labelAlternative))
                    }
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .outlined,
                            size: .medium,
                            text: "안녕하세요",
                            fontColor: .semantic(.accentBackgroundLightBlue)
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        .imageColor(.semantic(.labelAlternative))
                        
                        Chip.Action(
                            variant: .outlined,
                            size: .large,
                            text: "안녕하세요",
                            backgroundColor: .semantic(.accentBackgroundLime),
                            fontColor: .semantic(.accentBackgroundLightBlue)
                        )
                        .leadingImage(Image.montage(.bell))
                        .trailingImage(Image.montage(.apps))
                        .imageColor(.semantic(.staticWhite))
                    }
                    HStack(alignment: .center) {
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        .leadingImage(Image("wantedCircleSymbol"))
                        Chip.Action(
                            variant: .solid,
                            text: "안녕하세요",
                            active: true,
                            activeColor: .semantic(.accentBackgroundCyan)
                        )
                        .leadingImage(Image("wantedCircleSymbol"))
                        .imageColor(.semantic(.accentBackgroundPink))
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

struct FilterChipPreview: View {
    var body: some View {
        SwiftUI.ScrollView {
            VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                HStack {
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Variant").montage(variant: .headline2)
                    HStack {
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Size").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .solid,
                            size: .xsmall,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            size: .small,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            size: .large,
                            text: "텍스트"
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .outlined,
                            size: .xsmall,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            size: .small,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            text: "텍스트"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            size: .large,
                            text: "텍스트"
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("State").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요",
                            state: .expand
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요",
                            state: .expand
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Active").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요",
                            active: true
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요",
                            active: true
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Disable").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요",
                            disable: true
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요"
                        )
                        
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요",
                            disable: true
                        )
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Customize").montage(variant: .headline2)
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요",
                            iconColor: .semantic(.accentBackgroundLime)
                        )
                        Chip.Filter(
                            variant: .solid,
                            text: "안녕하세요",
                            fontColor: .semantic(.accentBackgroundPink)
                        )
                    }
                    HStack(alignment: .center) {
                        Chip.Filter(
                            variant: .outlined,
                            text: "안녕하세요",
                            iconColor: .semantic(.accentBackgroundViolet),
                            fontColor: .semantic(.accentBackgroundRedOrange)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    ActionChipPreview()
}

#Preview {
    FilterChipPreview()
}
