//
//  AccordionPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 1/3/25.
//

import SwiftUI
import Montage

struct AccordionPreview: View {
    /// 리스트 예시에 담는 아코디언 수.
    private static let listSampleCount = 2

    /// 리스트 예시가 `inset` 아코디언에 주는 좌우 여백. 4.0.0 스펙의 리스트 여백과 같은 값이다.
    private static let listHorizontalPadding: CGFloat = 20

    @State private var multilineTitle = false
    @State private var description = true
    @State private var content = true
    @State private var trailingContent = false
    @State private var verticalPaddingIndex = 0
    @State private var hideDivider = false
    @State private var variantIndex = 0
    @State private var recursive = false
    @State private var leadingContent = false

    let verticalPaddings: [Accordion.VerticalPadding] = [.small, .medium, .large]
    let variants: [Accordion.Variant] = [.inset, .full]

    var body: some View {
        PreviewLayout {
            VStack(alignment: .leading, spacing: 8) {
                caption("Single")
                accordion(hideDivider: hideDivider)
                    .previewDimensioned()

                caption("In List")
                listSample
            }
        } options: {
            ToggleOptionRow("multilineTitle", isOn: $multilineTitle)
            HStack {
                ToggleOption("description", isOn: $description)
                ToggleOption("content", isOn: $content)
            }
            HStack {
                ToggleOption("leadingContent", isOn: $leadingContent)
                ToggleOption("trailingContent", isOn: $trailingContent)
            }
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("verticalPadding", index: $verticalPaddingIndex, labels: verticalPaddings.map(\.description))
            HStack {
                ToggleOption("hideDivider", isOn: $hideDivider)
                ToggleOption("recursive", isOn: $recursive)
            }
        }
    }

    /// 옵션을 그대로 반영한 아코디언 하나.
    ///
    /// 낱개 미리보기와 리스트 예시가 같은 설정을 쓰도록 한곳에서 만든다.
    private func accordion(hideDivider: Bool) -> some View {
        Accordion(
            title: multilineTitle ? "제목이 두 줄이\n될 수도 있다고 합니다" : "제목",
            description: description ? "제목에 대한 상세 내용을 입력해주세요.\n긴 컨텐츠라면 접은 상태를 기본 값으로 사용하세요." : nil,
            content: {
                if content {
                    if recursive {
                        Accordion(title: "1.제목", description: "컨텐츠에 아코디언이 또 들어갈 수도 있지요.")
                        Accordion(title: "2.제목", content: { dummyContent })
                        Accordion(title: "3.제목(variant = .full)", content: { dummyContent })
                            .variant(.full)
                    } else {
                        dummyContent
                    }
                }
            }
        )
        .verticalPadding(verticalPaddings[verticalPaddingIndex])
        .hideDivider(hideDivider)
        .variant(variants[variantIndex])
        .leadingContent({
            if leadingContent {
                Thumbnail(urlString: "https://images.icon-icons.com/4128/PNG/512/hero_main_heading_title_icon_260510.png", ratio: .r1x1)
                    .frame(width: 24, height: 24)
            }
        })
        .trailingContent { isExpanded in
            if trailingContent {
                HStack(spacing: 4) {
                    TextButton(
                        color: .assistive,
                        size: .small,
                        text: isExpanded ? "접기" : "펼치기"
                    )
                    Image.icon(isExpanded ? .chevronUp : .chevronDown)
                        .resizable()
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralTertiary))
                        .frame(width: 16, height: 16)
                }
                .frame(height: 24)
                .allowsHitTesting(false)
            }
        }
    }

    /// 아코디언을 리스트에 담았을 때의 모습.
    ///
    /// `variant`는 아코디언이 아니라 아코디언이 놓이는 리스트의 가장자리를 기준으로 정의되므로,
    /// 좌우 여백을 리스트가 주는 `inset`과 아코디언이 직접 갖는 `full`의 차이는 컨테이너에 담아야 드러난다.
    /// 여기서는 리스트 가장자리를 눈으로 확인할 수 있게 테두리를 둘렀다.
    private var listSample: some View {
        VStack(spacing: 0) {
            ForEach(0..<Self.listSampleCount, id: \.self) { index in
                // 마지막 아코디언 아래 구분선은 리스트 테두리와 겹치므로 그리지 않는다.
                accordion(hideDivider: hideDivider || index == Self.listSampleCount - 1)
                    // variant에 따라 아코디언 경계가 리스트 여백을 포함하는지가 달라지므로 리스트에서도 치수를 건다.
                    // 아코디언마다 걸면 상자와 라벨이 겹치므로 첫 아코디언에만 건다.
                    .if(index == 0) { $0.previewDimensioned() }
            }
        }
        // inset은 리스트가 좌우 여백을 주고, full은 아코디언이 직접 갖는다.
        .padding(.horizontal, variants[variantIndex] == .inset ? Self.listHorizontalPadding : 0)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(SwiftUI.Color.semantic(.lineNeutralPrimaryOpaque), lineWidth: 1)
        )
    }

    private func caption(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    var dummyContent: some View {
        Rectangle()
            .fill(SwiftUI.Color.semantic(.surfaceAccentVioletOpaque).opacity(0.2))
            .frame(height: 100)
    }
}

extension Accordion.VerticalPadding: CaseDescribable {}
extension Accordion.Variant: CaseDescribable {}

#Preview {
    AccordionPreview()
}
