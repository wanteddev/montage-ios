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
    ///       Modal.BottomSheet {
    ///           ...
    ///       }
    /// })
    /// ```
    ///
    /// - Parameters:
    ///     - needHandle: Content 표시 영역을 변경시킬 수 있는 handle의 여부 입니다. 기본값은 true입니다.
    ///     - resize: Content가 표시될 영역의 사이즈 입니다. 기본값은 .hug입니다.
    ///     - containScrollView: Content에 ScrollView 가 삽입된 경우 전달합니다. 기본값은 false입니다.
    public struct BottomSheet: View {
        // MARK: - Types
        
        /// Modal/Bottom의 사이즈를 나타내는 열거형입니다.
        public enum Resize {
            case hug
            case fixedRatio(CGFloat)
            case fixedHeight(CGFloat)
            case flexible
            case fill
            
            fileprivate var isFlexible: Bool {
                switch self {
                case .flexible:
                    true
                default:
                    false
                }
            }
        }
        
        // MARK: - Initializer
        
        private var content: () -> any View
        
        public init(_ content: @escaping () -> any View) {
            self.content = content
        }
        
        // MARK: - Body
        
        @Environment(\.safeAreaInsets) private var safeAreaInsets
        @State private var navigationHeight: CGFloat = 0
        @State private var contentHeight: CGFloat = 0
        @State private var actionAreaHeight: CGFloat = 0
        @State private var contentOffset: CGFloat = 0
        
        public var body: some View {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    Group {
                        let contentView = AnyView(content())
                            .padding(contentEdgeInsets)
                            .onGeometryChange(
                                for: CGFloat.self,
                                of: { $0.size.height },
                                action: { contentHeight = $0 }
                            )
                        
                        if bottomSheetContentHeight > bottomSheetMaxHeight ||
                            (resize.isFlexible && bottomSheetContentHeight > bottomSheetMaxHeight / 2) {
                            ZStack(alignment: .top) {
                                ScrollView(onOffsetChanged: {
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
                                if bottomSheetContentHeight < bottomSheetMaxHeight {
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    }
                    
                    if let actionAreaModel {
                        ActionArea(variant: actionAreaModel.variant)
                            .clearBackground(scrolledToBottom)
                            .caption(actionAreaModel.caption)
                            .extra(actionAreaModel.extra, divider: actionAreaModel.extraDivider)
                            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                                actionAreaHeight = $0
                            })
                    }
                }
            }
            .presentationDetents(detents)
            .presentationDragIndicator(needHandle ? .visible : .hidden)
        }
        
        // MARK: - Modifiers
        
        private var needHandle = true
        private var resize: Resize = .hug
        private var navigation: (() -> Montage.Modal.Navigation)?
        private var actionAreaModel: ActionAreaModifier.Model?
        private var ignoresEdgeInsets = false
        private var fullModal = false
        
        public func needHandle(_ needHandle: Bool) -> Self {
            var zelf = self
            zelf.needHandle = needHandle
            return zelf
        }
        
        public func resize(_ resize: Modal.BottomSheet.Resize) -> Self {
            var zelf = self
            zelf.resize = resize
            return zelf
        }
        
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
        
        public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self {
            var zelf = self
            zelf.ignoresEdgeInsets = ignoresEdgeInsets
            return zelf
        }
        
        internal func fullModal(_ fullModal: Bool = true) -> Self {
            var zelf = self
            zelf.fullModal = fullModal
            return zelf
        }
        
        // MARK: - Private
        
        private var scrolledToBottom: Bool {
            Int(contentOffset) <= (Int(bottomSheetMaxHeight) + (fullModal ? 10 : 0)) -
                Int(bottomSheetContentHeight)
        }
        
        private var navigationView: some View {
            Group {
                if let navigation {
                    navigation()
                        .scrollOffset($contentOffset)
                        .needHandleArea(needHandle)
                }
            }
            .ignoresSafeArea()
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { navigationHeight = $0 })
        }
        
        private var contentEdgeInsets: EdgeInsets {
            ignoresEdgeInsets
                ? .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                : .init(
                    top: navigation == nil ? (needHandle ? 32 : 20) : 0,
                    leading: 20,
                    bottom: actionAreaModel == nil ? 0 : 20,
                    trailing: 20
                )
        }
        
        private var maxDetentHeight: CGFloat {
            (UIApplication.keyWindow?.safeAreaSize.height ?? 0) - 10
        }
        
        private var bottomSheetMaxHeight: CGFloat {
            switch resize {
            case .hug:
                min(maxDetentHeight, bottomSheetContentHeight)
            case .fixedRatio(let ratio):
                maxDetentHeight * ratio
            case .fixedHeight(let height):
                height
            case .flexible, .fill:
                maxDetentHeight
            }
        }
        
        private var bottomSheetContentHeight: CGFloat {
            navigationHeight + contentHeight + actionAreaHeight
        }
        
        private var detents: Set<PresentationDetent> {
            switch resize {
            case .flexible:
                [
                    .height(min(bottomSheetContentHeight, maxDetentHeight / 2 + safeAreaInsets.bottom)),
                    .height(min(bottomSheetContentHeight, maxDetentHeight))
                ]
            default:
                [.height(bottomSheetMaxHeight)]
            }
        }
    }
    
    public struct BottomSheetModifier: ViewModifier {
        @Binding private var isPresented: Bool
        private let bottomSheetContent: () -> any View
        private let needHandle: Bool
        private let resize: BottomSheet.Resize
        private let ignoresEdgeInsets: Bool
        private let navigation: (() -> Modal.Navigation)?
        private let actionAreaModel: ActionAreaModifier.Model?
        
        public init(
            isPresented: Binding<Bool>,
            _ content: @escaping () -> any View,
            needHandle: Bool = true,
            resize: BottomSheet.Resize = .hug,
            ignoresEdgeInsets: Bool = false,
            navigation: ( () -> Modal.Navigation)? = nil,
            actionAreaModel: ActionAreaModifier.Model? = nil
        ) {
            _isPresented = isPresented
            bottomSheetContent = content
            self.needHandle = needHandle
            self.resize = resize
            self.ignoresEdgeInsets = ignoresEdgeInsets
            self.navigation = navigation
            self.actionAreaModel = actionAreaModel
        }
        
        public func body(content: Content) -> some View {
            content
                .sheet(isPresented: $isPresented) {
                    BottomSheet {
                        AnyView(bottomSheetContent())
                    }
                    .needHandle(needHandle)
                    .resize(resize)
                    .ignoresEdgeInsets(ignoresEdgeInsets)
                    .modalNavigation(navigation)
                    .modalActionArea(actionAreaModel)
                }
        }
    }
}
