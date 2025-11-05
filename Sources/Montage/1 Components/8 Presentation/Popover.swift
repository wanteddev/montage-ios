//
//  Popover.swift
//  Views
//
//  Created by 김삼열 on 10/22/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public enum Popover {
    struct NormalModifier: ViewModifier {
        @Binding private var isPresented: Bool
        private let heading: String
        private let text: String
        private let closeButton: Bool
        private let action: (title: String, action: () -> Void)?
        private let subAction: (title: String, action: () -> Void)?

        init(
            isPresented: Binding<Bool>,
            heading: String,
            text: String,
            closeButton: Bool,
            action: (title: String, action: () -> Void)?,
            subAction: (title: String, action: () -> Void)?
        ) {
            self._isPresented = isPresented
            self.heading = heading
            self.text = text
            self.closeButton = closeButton
            self.action = action
            self.subAction = subAction
        }

        @State private var contentSize: CGSize = .zero
        @State private var headingHeight: CGFloat = .zero
        @State private var textHeight: CGFloat = .zero

        func body(content: Content) -> some View {
            content
                .padding(8)
                .background {
                    popoverContent
                        .onGeometryChange(
                            for: CGSize.self, of: { $0.size }, action: { contentSize = $0 }
                        )
                        .hidden()
                }
                .background(
                    PopoverPresenter(
                        isPresented: $isPresented,
                        contentSize: contentSize
                    ) {
                        popoverContent
                    }
                )
        }

        var popoverContent: some View {
            VStack(spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    VStack(spacing: 6) {
                        if heading.isNotEmpty {
                            ZStack {
                                SwiftUI.Color.clear
                                    .frame(height: headingHeight)
                                HStack {
                                    Text(heading)
                                        .paragraph(
                                            variant: .body2, weight: .bold,
                                            color: .semantic(.labelNormal)
                                        )
                                        .lineLimit(2)
                                        .multilineTextAlignment(.leading)
                                        .onGeometryChange(
                                            for: CGFloat.self,
                                            of: { $0.size.height },
                                            action: { headingHeight = $0 }
                                        )
                                    Spacer(minLength: closeButton ? 22 + 7 : 0)
                                }
                            }
                        }
                        if text.isNotEmpty {
                            ZStack {
                                SwiftUI.Color.clear
                                    .frame(height: textHeight)
                                HStack {
                                    Text(text)
                                        .paragraph(
                                            variant: .label2, weight: .medium,
                                            color: .semantic(.labelNeutral)
                                        )
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.leading)
                                        .padding(.vertical, 2)
                                        .onGeometryChange(
                                            for: CGFloat.self,
                                            of: { $0.size.height },
                                            action: { textHeight = $0 }
                                        )
                                    Spacer(minLength: closeButton ? 22 + 7 : 0)
                                }
                            }
                        }
                    }
                    if closeButton {
                        IconButton(variant: .normal(size: 16), icon: .close) {
                            isPresented = false
                        }
                        .padding(.all, 3)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)

                if action != nil || subAction != nil {
                    HStack(spacing: 16) {
                        Spacer()
                        if let action {
                            if let subAction {
                                TextButton(color: .assistive, size: .small, text: subAction.title) {
                                    isPresented = false
                                    subAction.action()
                                }
                            }
                            TextButton(color: .primary, size: .small, text: action.title) {
                                isPresented = false
                                action.action()
                            }
                        }
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 12)
                }
            }
            .frame(minWidth: 140, maxWidth: 360)
            .fixedSize(horizontal: true, vertical: true)
            .background(.ultraThinMaterial)
            .background(SwiftUI.Color.semantic(.backgroundElevated).opacity(0.88))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    struct CustomModifier<V: View>: ViewModifier {
        @Binding private var isPresented: Bool
        private let popoverContent: () -> V

        init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> V) {
            self._isPresented = isPresented
            self.popoverContent = content
        }

        @State private var contentSize: CGSize = .zero

        func body(content: Content) -> some View {
            content
                .padding(8)
                .background {
                    popoverContent()
                        .onGeometryChange(
                            for: CGSize.self, of: { $0.size }, action: { contentSize = $0 }
                        )
                        .hidden()
                }
                .background(
                    PopoverPresenter(
                        isPresented: $isPresented,
                        contentSize: contentSize,
                        popoverContent: popoverContent
                    )
                )
        }
    }
    
    struct PopoverPresenter<V: View>: UIViewControllerRepresentable {
        @Binding var isPresented: Bool
        let contentSize: CGSize
        let popoverContent: () -> V
        
        func makeUIViewController(context: Context) -> UIViewController {
            let vc = UIViewController()
            vc.view.backgroundColor = .clear
            return vc
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            guard isPresented else {
                if let contentVC = context.coordinator.contentVC {
                    contentVC.dismiss(animated: true) {
                        context.coordinator.contentVC = nil
                    }
                }
                return
            }
            
            // 이미 present된 경우 rootView만 업데이트
            if let contentVC = context.coordinator.contentVC {
                contentVC.rootView = popoverContent()
                contentVC.preferredContentSize = contentSize
                return
            }
            
            // 처음 present하는 경우
            let contentVC = UIHostingController(rootView: popoverContent())
            contentVC.view.backgroundColor = .clear
            contentVC.preferredContentSize = contentSize
            contentVC.modalPresentationStyle = .popover
            
            if let popover = contentVC.popoverPresentationController {
                popover.sourceView = uiViewController.view
                popover.sourceRect = CGRect(
                    x: uiViewController.view.bounds.minX,
                    y: uiViewController.view.bounds.minY,
                    width: uiViewController.view.bounds.width,
                    height: uiViewController.view.bounds.height)
                popover.permittedArrowDirections = [.any]
                popover.popoverLayoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
                popover.popoverBackgroundViewClass = NoArrowPopoverBackground.self
                popover.delegate = context.coordinator
            }
            
            context.coordinator.contentVC = contentVC
            uiViewController.present(contentVC, animated: true)
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
            var parent: PopoverPresenter
            var contentVC: UIHostingController<V>?
            
            init(_ parent: PopoverPresenter) {
                self.parent = parent
            }
            
            func adaptivePresentationStyle(
                for controller: UIPresentationController
            ) -> UIModalPresentationStyle {
                .none
            }
            
            func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
                parent.isPresented = false
                contentVC = nil
            }
        }
    }
    
    class NoArrowPopoverBackground: UIPopoverBackgroundView {
        override var arrowOffset: CGFloat {
            get { 0 }
            set {}
        }
        
        override var arrowDirection: UIPopoverArrowDirection {
            get { .any }
            set {}
        }
        
        override class func contentViewInsets() -> UIEdgeInsets {
            .zero
        }
        
        override class func arrowBase() -> CGFloat { 0 }
        override class func arrowHeight() -> CGFloat { 0 }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            layer.shadowOpacity = 0
        }
    }
}

extension View {
    /// 일반적인 팝오버 모디파이어를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 팝오버 표시 여부에 대한 바인딩
    ///   - heading: 팝오버 제목
    ///   - text: 팝오버 텍스트
    ///   - closeButton: 팝오버 닫기 버튼 표시 여부
    ///   - action: 팝오버 행동 버튼 표시 여부
    ///   - subAction: 팝오버 보조 행동 버튼 표시 여부
    /// - Returns: 일반적인 팝오버 모디파이어
    public func popoverNormal(
        isPresented: Binding<Bool>,
        heading: String = "",
        text: String,
        closeButton: Bool = true,
        action: (title: String, action: () -> Void)?,
        subAction: (title: String, action: () -> Void)? = nil
    ) -> some View {
        modifier(
            Popover.NormalModifier(
                isPresented: isPresented,
                heading: heading,
                text: text,
                closeButton: closeButton,
                action: action,
                subAction: subAction
            )
        )
    }

    /// 사용자 정의 팝오버 모디파이어를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 팝오버 표시 여부에 대한 바인딩
    ///   - content: 팝오버 콘텐츠를 반환하는 클로저
    /// - Returns: 사용자 정의 팝오버 모디파이어
    public func popoverCustom<V: View>(
        isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> V
    ) -> some View {
        modifier(Popover.CustomModifier(isPresented: isPresented, content: content))
    }
}
