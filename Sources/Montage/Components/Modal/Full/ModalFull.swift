//
//  ModalFull.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    /// Modal/Full Component 입니다.
    ///
    /// .fullScreenCover(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
    /// ```
    /// .sheet(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Full(
    ///           topNavigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// Modal/Popup과 다르게 transaction을 통해 animation을 제거할 필요가 없습니다.
    ///
    public struct Full: View {
        private let topNavigation: (() -> Montage.Bar.TopNavigation)
        private let content: (() -> any View)
        private let actionArea: (() -> Montage.ActionArea.Bottom.Component)?
        
        public init(
            topNavigation: @escaping () -> Montage.Bar.TopNavigation,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Bottom.Component)? = nil
        ) {
            self.topNavigation = topNavigation
            self.content = content
            self.actionArea = actionArea
        }

        public var body: some View {
            VStack(spacing: .zero) {
                AnyView(topNavigation())
                AnyView(content())
                Spacer()
                if let actionArea {
                    AnyView(actionArea())
                } else {
                    Spacer()
                        .frame(height: 34)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

private struct ModalFullPreivew: View {
    @State private var show: Bool = false
    @State private var scrollOffset: CGFloat = .zero

    var body: some View {
        VStack {
            SwiftUI.Button {
                show = true
            } label: {
                Text("PUSH")
            }
        }
        .fullScreenCover(
            isPresented: $show,
            content: {
                Modal.Full(
                    topNavigation: {
                        Bar.TopNavigation(
                            variant: .normal,
                            title: "제목",
                            left: nil,
                            actions: [
                                .icon(.close, action: { show = false })
                            ]
                        )
                    },
                    content: {
                        VStack {
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                        }
                        
//                        ScrollView {
//                            GeometryReader { proxy in
//                                SwiftUI.Color.clear.preference(
//                                    key: OffsetPreferenceKey.self,
//                                    value: proxy.frame(
//                                        in: .named("ScrollViewOrigin")
//                                    ).origin
//                                )
//                                .frame(width: 0, height: 0)
//                            }
//                            VStack {
//                                SwiftUI.Color.red.frame(height: 1050)
//                            }
//                        }
//                        .coordinateSpace(name: "ScrollViewOrigin")
//                        .onPreferenceChange(
//                            OffsetPreferenceKey.self,
//                            perform: { scrollOffset = $0.y }
//                        )
                    },
                    actionArea: {
                        ActionArea.Bottom.Component(
                            model: .init(
                                variant: .normal,
                                priority: .single(main: .init(text: "눌러봐요", action: {
                                    show = false
                                })),
                                sticky: false,
                                caption: nil
                            )
                        )
                    }
                    //actionArea: nil
                )
            }
        )
    }
}

struct ModalFull_Previews: PreviewProvider {
    static var previews: some View {
        ModalFullPreivew()
    }
}
