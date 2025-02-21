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
    /// .fullScreenCover(
    ///   isPresented: Binding<Bool>,
    ///   content: {
    ///       Modal.Full {...}
    /// })
    /// ```
    ///
    public struct Full: View {
        // MARK: - Initializer
        
        private var content: () -> any View
        
        public init(_ content: @escaping () -> any View) {
            self.content = content
        }
        
        @Environment(\.safeAreaInsets) private var safeAreaInsets

        public var body: some View {
            Modal.BottomSheet(content)
                .needHandle(false)
                .resize(.fill)
                .modalNavigation(navigation)
                .modalActionArea(actionAreaModel)
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
    }
    
    public struct FullModifier: ViewModifier {
        @Binding private var isPresented: Bool
        private let fullContent: () -> any View
        private let navigation: (() -> Modal.Navigation)?
        private let actionAreaModel: ActionAreaModifier.Model?
        
        public init(
            isPresented: Binding<Bool>,
            _ content: @escaping () -> any View,
            navigation: (() -> Modal.Navigation)? = nil,
            actionAreaModel: ActionAreaModifier.Model? = nil
        ) {
            _isPresented = isPresented
            fullContent = content
            self.navigation = navigation
            self.actionAreaModel = actionAreaModel
        }
        
        public func body(content: Content) -> some View {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    Full {
                        AnyView(fullContent())
                    }
                    .modalNavigation(navigation)
                    .modalActionArea(actionAreaModel)
                }
        }
    }
}
