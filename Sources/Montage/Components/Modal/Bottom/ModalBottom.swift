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
    /// > iOS 15 이하에서는 BottomSheet 형태가 아닌 FullScreen 형태로 표시됩니다.
    /// >
    /// > iOS 16.4 이하에서는 handle이 표시되지 않습니다.
    ///
    /// .sheet(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
    /// ```
    /// .sheet(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Bottom(
    ///           handle: Bool,
    ///           resize: Modal.Bottom.Resize,
    ///           withScrollView: Bool,
    ///           navigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// - Parameters:
    ///     - handle: Content 표시 영역을 변경시킬 수 있는 handle의 여부 입니다. 기본값은 false입니다.
    ///     - resize: Content가 표시될 영역의 사이즈 입니다. 기본값은 .hug입니다.
    ///     - withScrollView: Content에 ScrollView 가 삽입된 경우 전달합니다. 기본값은 false입니다.
    public struct Bottom: View {
        /// Modal/Bottom의 사이즈를 나타내는 열거형입니다.
        public enum Resize {
            case hug
            case fill
        }
        
        @Environment(\.safeAreaInsets) private var safeAreaInsets
        @State private var contentSize: CGSize = .zero

        private let handle: Bool
        private let resize: Modal.Bottom.Resize
        private let withScollView: Bool
        private let navigation: (() -> Montage.Modal.Navigation)
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
        /// ContentView에 ScrollView가 있는 경우, [.fractoin(0.35), .medium, .max]로 제한됩니다.
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
            navigation: @escaping () -> Montage.Modal.Navigation,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Bottom.Component)? = nil
        ) {
            self.handle = handle
            self.resize = resize
            self.withScollView = withScrollView
            self.navigation = navigation
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
                    AnyView(navigation())
                    AnyView(content())
                    if let actionArea {
                        AnyView(actionArea())
                    }
                }
                .background(contentSizeMeasurer)
                .presentationDetents(detents)
                .presentationDragIndicator(handle ? .visible : .hidden)
                .presentationContentInteraction(withScollView ? .resizes : .automatic)
                .padding(.bottom, -safeAreaInsets.bottom)
            } else {
                VStack(spacing: .zero) {
                    if handle {
                        Spacer()
                            .frame(height: 10)
                    }
                    AnyView(navigation())
                    AnyView(content())
                    if let actionArea {
                        AnyView(actionArea())
                    }
                }
                .background(contentSizeMeasurer)
                .padding(.bottom, -safeAreaInsets.bottom)
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
                    handle: false,
                    resize: .hug,
                    withScrollView: false, // 스크롤뷰와 함께 쓰일때 사용
                    navigation: {
                        Modal.Navigation(
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
                        VStack {
                            Text("텍스트입니다")
                            Text("텍스트입니다")
                            Text("텍스트입니다")
                            Text("텍스트입니다")
                            Text("텍스트입니다")
                        }
                    },
                    actionArea: {
                        ActionArea.Bottom.Component(
                            model: .init(
                                variant: .normal,
                                priority: .cancel(main: .init(text: "눌러봐요", action: {
                                    show = false
                                })),
                                sticky: false,
                                caption: nil
                            )
                        )
                    }
                )
        })
    }
}

struct ModalBottom_Previews: PreviewProvider {
    static var previews: some View {
        ModalBottomPreivew()
    }
}
