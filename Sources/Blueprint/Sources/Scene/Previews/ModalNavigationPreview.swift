//
//  ModalNavigationPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 2/21/25.
//

import SwiftUI
import Montage

struct ModalNavigationPreview: View {
    @State private var showTransparentChecker: Bool = false
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
        VStack(spacing: 0) {
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
                        .padding(.horizontal)
                    }
                )
                .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
                
                VStack {
                    ModalNavigation(scrollOffset: $contentOffset)
                        .variant(variants[variantIndex])
                        .title({
                            ModalNavigation.TitleView(
                                variant: variants[variantIndex],
                                title: "제목"
                            )
                        })
                        .leadingContent {
                            Group {
                                if leadingButton {
                                    TopNavigation.LeadingButton.init(
                                        leadingButtons[leadingButtonTypeIndex]
                                    )
                                }
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
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Options").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                HStack {
                    Text("variant")
                    SegmentedControl(selectedIndex: $variantIndex, labels: variants.map(\.description))
                        .size(.small)
                }
                if case .floating = variants[variantIndex] {
                    HStack {
                        Text("alternative")
                        Control.switch(checked: alternative) { alternative = $0 }
                    }
                    HStack {
                        Text("background")
                        Control.switch(checked: background) { background = $0 }
                    }
                }
                HStack {
                    Text("leadingButton")
                    Control.switch(checked: leadingButton) { leadingButton = $0 }
                    SegmentedControl(selectedIndex: $leadingButtonTypeIndex, labels: leadingButtons.map { "\($0.description)" })
                        .size(.small)
                }
                HStack {
                    Text("trailingButton")
                    SegmentedControl(selectedIndex: $trailingButtonCount, labels: Array(0...3).map { "\($0)" })
                        .size(.small)
                    
                }
            }
            .padding()
            .background(.regularMaterial)
        }
        .navigationBarHidden(true)
    }
    
    private var variants: [ModalNavigation.Variant] {
        [.normal, .extended, .emphasized, .floating(alternative: alternative, background: background)]
    }
    
    private var leadingButtons: [TopNavigation.Resource.LeadingButtonInfo] {
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
