//
//  ModalNavigationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI
import Montage

struct ModalNavigationPreview: View {
    @State private var contentOffset: CGFloat = 0
    @State private var scrollViewTopPadding: CGFloat = 0
    @State private var variantIndex = 0
    @State private var leadingButtonTypeIndex = 0
    @State private var trailingButtonCount = 1
    @State private var noMaterialBackground = false
    @State private var useFixedOpacity = false
    @State private var fixedOpacity: CGFloat = 0.5
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // .navigation 모드: PreviewLayout이 NavigationView·push 버튼·체커 적용까지 담당한다.
        // preview 클로저는 push되는 미리보기 화면이다.
        PreviewLayout(mode: .navigation) {
            preview
        } options: {
            SegmentedIndexRow("variant", index: $variantIndex, labels: variants.map(\.description))
            SegmentedIndexRow("leadingButton", index: $leadingButtonTypeIndex, labels: leadingButtons.map { "\($0?.description ?? "none")" })
            SegmentedIndexRow("trailingButton", index: $trailingButtonCount, labels: Array(0...3).map { "\($0)" })
            ToggleOptionRow("noMaterialBackground", isOn: $noMaterialBackground)
            HStack {
                Text("fixedBackgroundOpacity")
                SwiftUI.Slider(value: $fixedOpacity, in: 0...1)
                    .disabled(!useFixedOpacity)
                Text(String(format: "%.2f", fixedOpacity))
                    .monospacedDigit()
                Switch(checked: useFixedOpacity) { useFixedOpacity = $0 }
            }
        }
    }

    var preview: some View {
        ZStack(alignment: .top) {
            ScrollView(
                onOffsetChanged: { offset in
                    contentOffset = offset.y
                },
                content: {
                    SwiftUI.Color.clear
                        .frame(height: scrollViewTopPadding)

                    LazyVStack(spacing: 0) {
                        ForEach(0..<Color.Semantic.allCases.count*2, id: \.self) { index in
                            ZStack {
                                SwiftUI.Color.semantic(.allCases[index % Color.Semantic.allCases.count]).opacity(0.3)
                                Text("Item \(index)")
                                    .padding()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            )

            VStack {
                ModalNavigation(scrollOffset: $contentOffset)
                    .variant(variants[variantIndex])
                    .title("제목")
                    .modifying {
                        if noMaterialBackground {
                            $0.noMaterialBackground()
                        } else {
                            $0
                        }
                    }
                    .modifying {
                        if useFixedOpacity {
                            $0.fixedBackgroundOpacity(fixedOpacity)
                        } else {
                            $0
                        }
                    }
                    .leadingContent {
                        Group {
                            TopNavigation.LeadingButton.init(
                                leadingButtons[leadingButtonTypeIndex]
                            )
                        }
                    }
                    .trailingContents(
                        Array(actions.prefix(trailingButtonCount)).map { kind -> (() -> AnyView) in
                            switch kind {
                            case let .icon(i, d, s, a):
                                {
                                    AnyView(TopNavigation.TrailingIconButton(
                                        icon: i,
                                        disable: d,
                                        showPushBadge: s,
                                        action: a
                                    ))
                                }
                            case let .text(t, d, a):
                                {
                                    AnyView(TopNavigation.TrailingTextButton(
                                        text: t,
                                        disable: d,
                                        action: a
                                    ))
                                }
                            }
                        }
                    )
            }
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { scrollViewTopPadding = $0 })
        }
    }

    private var variants: [ModalNavigation.Variant] {
        [.normal, .display, .emphasized, .floating]
    }

    private var leadingButtons: [TopNavigation.Resource.LeadingButtonInfo?] {
        [
            nil,
            .back(action: {
                presentationMode.wrappedValue.dismiss()
            }),
            .icon(.flipBackward, action: {
                presentationMode.wrappedValue.dismiss()
            }),
            .text("뒤로", action: {
                presentationMode.wrappedValue.dismiss()
            })
        ]
    }

    private let actions: [TopNavigation.Resource.TrailingButtonInfo] = {
        [
            .icon(.close, action: {}),
            .icon(.download, showPushBadge: true, action: {}),
            .text("알림", action: {})
        ]
    }()
}

extension ModalNavigation.Variant: CaseDescribable {}
extension TopNavigation.Resource.LeadingButtonInfo: CaseDescribable {}
extension TopNavigation.Resource.TrailingButtonInfo: CaseDescribable {}

#Preview {
    ModalNavigationPreview()
}
