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
    ///           navigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// Modal/Popup과 다르게 transaction을 통해 animation을 제거할 필요가 없습니다.
    ///
    public struct Full: View {
        @Environment(\.safeAreaInsets) private var safeAreaInsets

        private let navigation: () -> Montage.Modal.Navigation
        private let content: () -> any View
        private let actionArea: (() -> Montage.ActionArea.Component)?

        public init(
            navigation: @escaping () -> Montage.Modal.Navigation,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Component)? = nil
        ) {
            self.navigation = navigation
            self.content = content
            self.actionArea = actionArea
        }

        public var body: some View {
            VStack(spacing: .zero) {
                AnyView(navigation())
                AnyView(content())
                Spacer()
                if let actionArea {
                    AnyView(actionArea())
                } else {
                    Spacer()
                        .frame(height: safeAreaInsets.bottom)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}

private struct ModalFullPreivew: View {
    @State private var show = false
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
                    navigation: {
                        Modal.Navigation(title: "제목")
                            .actions([
                                .icon(.close, action: { show = false })
                            ])
                    },
                    content: {
                        VStack {
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                            Text("텍스트")
                        }
                    },
                    actionArea: nil
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
