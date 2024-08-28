//
//  ModalBottom.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    /// Modal/Bottom Component입니다.
    ///
    /// .sheet(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
    /// ```
    /// .sheet(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Bottom(
    ///           handle: Bool,
    ///           resize: Modal.Bottom.Resize,
    ///           topNavigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// handle을 사용하여 Component 확장시에 TopNavigation과 ActionArea/Bottom 사이가 늘어나길 원하신다면
    /// Content 전달 시 Spacer를 포함한 VStack을 전달하면 됩니다.
    /// ```
    /// .sheet(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Bottom(
    ///           handle: true,
    ///           topNavigation: {...},
    ///           content: {
    ///            VStack {
    ///              ...
    ///              Spacer()
    ///            },
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// - Parameters:
    ///     - withScrollView: Content에 ScrollView 가 삽입된 경우 전달합니다. 기본값은 false입니다.
    public struct Bottom: View {
        /// Modal/Bottom의 사이즈를 나타내는 열거형입니다.
        public enum Resize {
            case hug
            case fill
        }
        
        @State private var contentSize: CGSize = .zero

        private let handle: Bool
        private let resize: Modal.Bottom.Resize
        private let withScollView: Bool
        private let topNavigation: (() -> Montage.Bar.TopNavigation)
        private let content: (() -> any View)
        private let actionArea: (() -> Montage.ActionArea.Bottom.Component)?
        
        /// Modal의 내부에 표시될 내용의 대한 SizeMeasurer입니다.
        private var contentSizeMeasurer: some View {
            GeometryReader(content: { proxy in
                SwiftUI.Color.clear
                    .onAppear {
                        contentSize = proxy.size
                    }
            })
        }
        
        /// Modal/Bottom의 dentents입니다
        ///
        /// ContentView에 Scroll이 있는 경우, [.fractoin(0.35), .medium, .max]로 제한됩니다.
        ///
        /// handle을 사용하는 경우 최대높이(화면 최상단 - 10) 까지 확장 가능하며,
        /// handle이 없는 경우에는 resize에 따라 최대높이가 결정됩니다.
        @available(iOS 16.0, *)
        private var detents: Set<PresentationDetent> {
            if withScollView {
                 [ .fraction(0.35), .medium, .max ]
            } else if handle {
                [ .height(contentSize.height), .max ]
            } else {
                resize == .fill ? [ .max ] : [ .height(contentSize.height) ]
            }
        }
        
        public init(
            handle: Bool = false,
            resize: Modal.Bottom.Resize = .hug,
            withScrollView: Bool = false,
            topNavigation: @escaping () -> Montage.Bar.TopNavigation,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Bottom.Component)? = nil
        ) {
            self.handle = handle
            self.resize = resize
            self.withScollView = withScrollView
            self.topNavigation = topNavigation
            self.content = content
            self.actionArea = actionArea
        }

        public var body: some View {
            if #available(iOS 16.4, *) {
                VStack(spacing: .zero) {
                    if handle {
                        Spacer()
                            .frame(height: 10)
                    }
                    AnyView(topNavigation())
                    AnyView(content())
                    if let actionArea {
                        AnyView(actionArea())
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .background(contentSizeMeasurer)
                .presentationDetents(detents)
                .presentationDragIndicator(handle ? .visible : .hidden)
                .presentationContentInteraction(withScollView ? .resizes : .automatic)
            } else {
                VStack(spacing: .zero) {
                    if handle {
                        Spacer()
                            .frame(height: 10)
                    }
                    AnyView(topNavigation())
                    AnyView(content())
                    if let actionArea {
                        AnyView(actionArea())
                    }
                }
                .ignoresSafeArea(.container, edges: .bottom)
                .background(contentSizeMeasurer)
            }
        }
    }
}

@available(iOS 16.0, *)
private extension PresentationDetent {
    static let max = Self.custom(MontageModalMaxDentent.self)
}

@available(iOS 16.0, *)
private struct MontageModalMaxDentent: CustomPresentationDetent {
    static func height(in context: Context) -> CGFloat? {
        context.maxDetentValue - 10
    }
}

private struct ModalBottomPreivew: View {
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
        .sheet(
            isPresented: $show,
            content: {
                Modal.Bottom(
                    handle: true,
                    resize: .hug,
                    withScrollView: true, // 스크롤뷰와 함께 쓰일때 사용
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
                        //VStack {
                        //    Text("스크롤뷰")
                        //    Text("스크롤뷰")
                        //    Text("스크롤뷰")
                        //    Text("스크롤뷰")
                        //    Text("스크롤뷰")
                        //}

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
                            VStack { SwiftUI.Color.red.frame(height: 500) }
                        }
                        .coordinateSpace(name: "ScrollViewOrigin")
                        .onPreferenceChange(
                            OffsetPreferenceKey.self,
                            perform: { scrollOffset = $0.y }
                        )
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
        })
    }
}

struct ModalBottom_Previews: PreviewProvider {
    static var previews: some View {
        ModalBottomPreivew()
    }
}
