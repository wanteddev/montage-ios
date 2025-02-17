//
//  ModalBottom.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

extension Modal {
    /// Modal/BottomSheet Component입니다.
    ///
    /// .sheet(isPresented:content:)와 함께 사용하며 content안쪽에 Component를 위치시킵니다.
    /// ```
    /// .sheet(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.BottomSheet(
    ///           navigation: {...},
    ///           content: {...},
    ///           actionArea: {...}
    ///       )
    /// })
    /// ```
    ///
    /// - Parameters:
    ///     - handle: Content 표시 영역을 변경시킬 수 있는 handle의 여부 입니다. 기본값은 true입니다.
    ///     - resize: Content가 표시될 영역의 사이즈 입니다. 기본값은 .hug입니다.
    ///     - containScrollView: Content에 ScrollView 가 삽입된 경우 전달합니다. 기본값은 false입니다.
    public struct BottomSheet: View {
        /// Modal/Bottom의 사이즈를 나타내는 열거형입니다.
        public enum Resize {
            case hug
            case fill
        }

        @Environment(\.safeAreaInsets) private var safeAreaInsets
        @State private var contentSize: CGSize = .zero

        private var handle = true
        private var resize: Modal.BottomSheet.Resize = .hug
        private var containScrollView = false

        private let navigation: (() -> Montage.Modal.Navigation)?
        private let content: () -> any View
        private let actionArea: (() -> Montage.ActionArea.Component)?

        /// Modal/Bottom의 dentents입니다
        ///
        /// ContentView에 ScrollView가 있는 경우, [.fractoin(0.35), .medium, .max]로 제한됩니다.
        ///
        /// handle을 사용하는 경우 최대높이(화면 최상단 - 10) 까지 확장 가능하며,
        /// handle이 없는 경우에는 resize에 따라 최대높이가 결정됩니다.
        private var detents: Set<PresentationDetent> {
            if containScrollView {
                [ .fraction(0.35), .medium, .max ]
            } else if handle {
                [ .height(max(.zero, contentSize.height - safeAreaInsets.bottom)) ]
            } else {
                resize == .fill ? [ .max ] : [ .height(max(
                    .zero,
                    contentSize.height - safeAreaInsets.bottom
                )) ]
            }
        }

        public init(
            navigation: (() -> Montage.Modal.Navigation)? = nil,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Component)? = nil
        ) {
            self.navigation = navigation
            self.content = content
            self.actionArea = actionArea
        }

        fileprivate init(
            handle: Bool = true,
            resize: Modal.BottomSheet.Resize = .hug,
            containScrollView: Bool = false,
            navigation: (() -> Montage.Modal.Navigation)? = nil,
            content: @escaping () -> any View,
            actionArea: (() -> Montage.ActionArea.Component)? = nil
        ) {
            self.handle = handle
            self.resize = resize
            self.containScrollView = containScrollView
            self.navigation = navigation
            self.content = content
            self.actionArea = actionArea
        }

        public var body: some View {
            VStack(spacing: .zero) {
                if handle {
                    Spacer()
                        .frame(height: 10)
                }
                if let navigation {
                    navigation()
                }
                AnyView(content())
                if let actionArea {
                    AnyView(actionArea())
                }
            }
            .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { contentSize = $0 })
            .presentationDetents(detents)
            .presentationDragIndicator(handle ? .visible : .hidden)
            .padding(.bottom, -safeAreaInsets.bottom)
            .if(true, transform: { originalView in
                Group {
                    if #available(iOS 16.4, *) {
                        originalView.presentationContentInteraction(containScrollView ? .resizes : .automatic)
                            .presentationCornerRadius(12)
                    } else {
                        originalView
                    }
                }
            })
        }
    }
}

extension Modal.BottomSheet {
    public func needHandle(_ need: Bool) -> Self {
        Modal.BottomSheet(
            handle: need,
            resize: resize,
            containScrollView: containScrollView,
            navigation: navigation,
            content: content,
            actionArea: actionArea
        )
    }

    public func resize(_ type: Modal.BottomSheet.Resize) -> Self {
        Modal.BottomSheet(
            handle: handle,
            resize: type,
            containScrollView: containScrollView,
            navigation: navigation,
            content: content,
            actionArea: actionArea
        )
    }

    public func containScrollView(_ isContain: Bool) -> Self {
        Modal.BottomSheet(
            handle: handle,
            resize: resize,
            containScrollView: isContain,
            navigation: navigation,
            content: content,
            actionArea: actionArea
        )
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
        .sheet(
            isPresented: $show,
            content: {
                Modal.BottomSheet(
                    navigation: {
                        Modal.Navigation(title: "제목")
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
                        ActionArea.Component(
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
                .needHandle(true)
                .resize(.hug)
                .containScrollView(false) // 스크롤뷰와 함께 쓰일때 사용
            }
        )
    }
}

struct ModalBottom_Previews: PreviewProvider {
    static var previews: some View {
        ModalBottomPreivew()
    }
}
