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
    @State private var alternative = false
    @State private var background = false
    @State private var leadingButton = true
    @State private var leadingButtonTypeIndex = 0
    @State private var trailingButtonCount = 1
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(
                onOffsetChanged: { offset in
                    contentOffset = offset.y
                },
                content: {
                    SwiftUI.Color.clear
                        .frame(height: scrollViewTopPadding)
                    
                    ForEach(0..<Color.Semantic.allCases.count*2, id: \.self) { index in
                        ZStack {
                            SwiftUI.Color.semantic(.allCases[index % Color.Semantic.allCases.count]).opacity(0.3)
                            Text("Item \(index)")
                                .padding()
                        }
                    }
                }
            )
            
            VStack(spacing: 0) {
                ModalNavigation(
                    title: "제목",
                    scrollOffset: $contentOffset
                )
                .variant(variants[variantIndex])
                .trailingButtons(Array(actions.prefix(trailingButtonCount).reversed()))
                .leadingButton(leadingButton ? leadingButtons[leadingButtonTypeIndex] : nil)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("variant")
                        SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                            .size(.small)
                    }
                    if case .floating = variants[variantIndex] {
                        HStack {
                            Text("alternative")
                            Control.Switch($alternative)
                        }
                        HStack {
                            Text("background")
                            Control.Switch($background)
                        }
                    }
                    HStack {
                        Text("leadingButton")
                        Control.Switch($leadingButton)
                        SegmentedControl(selectedIndex: $leadingButtonTypeIndex, labels: leadingButtons.map { "\($0.description)" })
                            .size(.small)
                    }
                    HStack {
                        Text("trailingButton")
                        SegmentedControl(selectedIndex: $trailingButtonCount, labels: Array(0...3).map { "\($0)" })
                            .size(.small)
                        
                    }
                }
                .padding(.horizontal)
                .background(SwiftUI.Color.semantic(.backgroundNormal))
            }
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { scrollViewTopPadding = $0 })
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
        .navigationBarHidden(true)
    }
    
    private var variants: [ModalNavigation.Variant] {
        [.normal, .extended, .emphasized, .floating(alternative: alternative, background: background)]
    }
    
    private var leadingButtons: [TopNavigation.Resource.LeadingButton] {
        [
            .back(action: {
                presentationMode.wrappedValue.dismiss()
            }), .icon(.flipBackward, action: {
                presentationMode.wrappedValue.dismiss()
            }), .text("뒤로", action: {
                presentationMode.wrappedValue.dismiss()
            })
        ]
    }
    
    private let actions: [TopNavigation.Resource.TrailingButton] = {
        [
            .icon(.close, action: {}),
            .icon(.download, showPushBadge: true, action: {}),
            .text("알림", action: {})
        ]
    }()
}

extension ModalNavigation.Variant: CaseDescribable {}
extension TopNavigation.Resource.LeadingButton: CaseDescribable {}
extension TopNavigation.Resource.TrailingButton: CaseDescribable {}

#Preview {
    ModalNavigationPreview()
}
