//
//  ModalPopup.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    /// Modal/Popup Component입니다.
    ///
    /// .fullScreenCover(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
    /// ```
    /// .fullScreenCover(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Popup(
    ///           topNavigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// 코드를 통해 transaction animation을 제거해야 animation이 정상적으로 작동합니다.
    /// ```
    /// .fullScreenCover(...)
    /// .transaction { transaction in
    ///   transaction.disablesAnimations = true
    /// }
    /// ```
    ///
    public struct Popup: View {
        @State private var opacity: CGFloat = .zero
        
        private let topNavigation: (() -> Montage.Bar.TopNavigation)
        private let content: (() -> any View)
        private let actionArea: (() -> Montage.ActionArea.Bottom.Component)?
        
        public init(
            topNavigation: @escaping () -> Montage.Bar.TopNavigation,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Bottom.Component)?
        ) {
            self.topNavigation = topNavigation
            self.content = content
            self.actionArea = actionArea
        }
        
        public var body: some View {
            if #available(iOS 16.4, *) {
                ZStack {
                    VStack(spacing: .zero) {
                        AnyView(
                            topNavigation()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        )
                        AnyView(content())
                        if let actionArea {
                            AnyView(actionArea())
                        } else {
                            Spacer()
                                .frame(maxHeight: 20)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(SwiftUI.Color.alias(.backgroundNormal))
                    )
                }
                .padding(.horizontal, 20)
                .presentationBackground(
                    SwiftUI.Color.component(.materialDimmer)
                )
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        opacity = 1
                    }
                }
            } else {
                ZStack {
                    VStack(spacing: .zero) {
                        AnyView(
                            topNavigation()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        )
                        AnyView(content())
                        if let actionArea {
                            AnyView(actionArea())
                        } else {
                            Spacer()
                                .frame(maxHeight: 20)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(SwiftUI.Color.alias(.backgroundNormal))
                    )
                }
                .padding(.horizontal, 20)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        opacity = 1
                    }
                }
                .dimmerBackground()
            }
        }
    }
}

private struct DimmerBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .component(.materialDimmer)
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

private struct DimmerBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(DimmerBackgroundView())
    }
}

private extension View {
    func dimmerBackground() -> some View {
        self.modifier(DimmerBackgroundViewModifier())
    }
}

private struct ModalPopupPreivew: View {
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
                Modal.Popup(
                    topNavigation: {
                        Bar.TopNavigation(
                            variant: .normal,
                            title: "제목",
                            scrollOffset: scrollOffset,
                            left: nil,
                            actions: [
                                .icon(.close, action: { show = false })
                            ]
                        )
                    },
                    content: {
                        /*
                        VStack {
                            Text("스크롤뷰")
                            Text("스크롤뷰")
                            Text("스크롤뷰")
                            Text("스크롤뷰")
                            Text("스크롤뷰")
                        }
                         */
                        
                        ScrollView {
                            GeometryReader { proxy in
                                SwiftUI.Color.clear.preference(
                                    key: OffsetPreferenceKey.self,
                                    value: proxy.frame(
                                        in: .named("ScrollViewOrigin")
                                    ).origin
                                )
                                .frame(width: 0, height: 0)
                            }
                            VStack {
                                SwiftUI.Color.red.frame(height: 500)
                            }
                        }
                        .coordinateSpace(name: "ScrollViewOrigin")
                        .onPreferenceChange(
                            OffsetPreferenceKey.self,
                            perform: { scrollOffset = $0.y }
                        )
                        .frame(height: 300)
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
                    // actionArea: nil
                )
            })
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

struct ModalPopup_Previews: PreviewProvider {
    static var previews: some View {
        ModalPopupPreivew()
    }
}
