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
    ///       Modal.Popup {...}
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
        private let content: () -> any View

        public init(_ content: @escaping () -> any View) {
            self.content = content
        }

        @State private var navigationHeight: CGFloat = 0
        @State private var contentHeight: CGFloat = 0
        @State private var actionAreaHeight: CGFloat = 0
        @State private var contentOffset: CGFloat = 0

        private let popupMaxHeight: CGFloat = 400
        
        public var body: some View {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Group {
                        let contentView = AnyView(content())
                            .onGeometryChange(
                                for: CGFloat.self,
                                of: { $0.size.height },
                                action: { contentHeight = $0 }
                            )
                        
                        if popupContentHeight > popupMaxHeight {
                            ZStack(alignment: .top) {
                                OffsettableScrollView(onOffsetChanged: {
                                    contentOffset = $0.y
                                }, content: {
                                    VStack(spacing: 0) {
                                        SwiftUI.Color.clear
                                            .frame(height: navigationHeight)
                                        HStack(spacing: 0) {
                                            Spacer(minLength: 0)
                                            contentView
                                            Spacer(minLength: 0)
                                        }
                                    }
                                })
                                
                                navigationView
                            }
                        } else {
                            VStack(spacing: 0) {
                                navigationView
                                contentView
                            }
                        }
                    }
                    
                    if let actionAreaModel {
                        ActionArea(variant: actionAreaModel.variant)
                            .sticky(actionAreaModel.sticky)
                            .caption(actionAreaModel.caption)
                            .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                            .dividerVisibility(scrolledToBottom ? .hidden : .automatic)
                            .padding(.bottom, 20)
                            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                                actionAreaHeight = $0
                            })
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(SwiftUI.Color.alias(.backgroundNormal))
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .frame(maxHeight: min(popupMaxHeight, popupContentHeight))
            .padding(.horizontal, 20)
            .if(true) { originalView in
                Group {
                    if #available(iOS 16.4, *) {
                        originalView.presentationBackground(
                            SwiftUI.Color.component(.materialDimmer)
                        )
                    } else {
                        originalView.dimmerBackground()
                    }
                }
            }
        }
        
        // MARK: - Modifiers
        
        private var navigation: (() -> Montage.Modal.Navigation)?
        private var actionAreaModel: ActionAreaModifier.Model?
        
        public func modalNavigation(_ navigation: (() -> Montage.Modal.Navigation)?) -> Self {
            var zelf = self
            zelf.navigation = navigation
            return zelf
        }
        
        public func modalActionArea(_ actionAreaModel: ActionAreaModifier.Model?) -> Self {
            var zelf = self
            zelf.actionAreaModel = actionAreaModel
            return zelf
        }
        
        // MARK: - Private
        
        private var navigationView: some View {
            Group {
                if let navigation {
                    navigation()
                        .scrollOffset($contentOffset)
                }
            }
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { navigationHeight = $0 })
        }
        
        private var popupContentHeight: CGFloat {
            navigationHeight + contentHeight + actionAreaHeight
        }
        
        private var scrolledToBottom: Bool {
            Int(contentOffset) <= Int(popupMaxHeight) - Int(popupContentHeight)
        }
    }
    
    public struct PopupModifier: ViewModifier {
        @Binding private var isPresented: Bool
        private let popupContent: () -> any View
        private let navigation: (() -> Modal.Navigation)?
        private let actionAreaModel: ActionAreaModifier.Model?
        
        public init(
            isPresented: Binding<Bool>,
            _ content: @escaping () -> any View,
            navigation: (() -> Modal.Navigation)? = nil,
            actionAreaModel: ActionAreaModifier.Model? = nil
        ) {
            _isPresented = isPresented
            popupContent = content
            self.navigation = navigation
            self.actionAreaModel = actionAreaModel
        }
        
        @State private var opacity: CGFloat = 0
        @State private var fullScreenCoverPresented = false

        public func body(content: Content) -> some View {
            content
                .fullScreenCover(isPresented: $fullScreenCoverPresented) {
                    Popup {
                        AnyView(popupContent())
                    }
                    .modalNavigation(navigation)
                    .modalActionArea(actionAreaModel)
                    .opacity(opacity)
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
                .onChange(of: isPresented) { _ in
                    if isPresented {
                        fullScreenCoverPresented = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation(.easeInOut(duration: 0.29)) {
                                opacity = 1
                            }
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            opacity = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            fullScreenCoverPresented = false
                        }
                    }
                }
        }
    }
}

private struct DimmerBackgroundView: UIViewRepresentable {
    func makeUIView(context _: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .component(.materialDimmer)
        }
        return view
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

private struct DimmerBackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(DimmerBackgroundView())
    }
}

private extension View {
    func dimmerBackground() -> some View {
        modifier(DimmerBackgroundViewModifier())
    }
}
