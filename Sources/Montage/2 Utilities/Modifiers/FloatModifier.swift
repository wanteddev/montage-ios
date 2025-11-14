//
//  FloatModifier.swift
//  Montage
//
//  Created by 김삼열 on 1/2/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

struct FloatModifier<V: Equatable>: ViewModifier {
    enum DismissPolicy {
        case after(seconds: TimeInterval)
        case onTouchOutside
        case onViewDisappear
        case manually

        var isOnTouchOutside: Bool {
            switch self {
            case .onTouchOutside: true
            default: false
            }
        }
    }

    @Binding private var isPresented: Bool
    private var updatingValue: Binding<V?>
    private let dismissPolicy: DismissPolicy
    private let presentingAnimation: Animation?
    private let dismissingAnimation: Animation?
    private let onDismiss: (() -> Void)?
    private let floatView: () -> any View

    init(
        isPresented: Bool,
        updatingValue: Binding<V?>,
        dismissPolicy: DismissPolicy = .onViewDisappear,
        presentingAnimation: Animation? = .none,
        dismissingAnimation: Animation? = .none,
        onDismiss: (() -> Void)? = nil,
        floatView: @escaping () -> any View
    ) {
        _isPresented = .constant(isPresented)
        self.updatingValue = updatingValue
        self.presentingAnimation = presentingAnimation
        self.dismissingAnimation = dismissingAnimation
        self.dismissPolicy = dismissPolicy
        self.onDismiss = onDismiss
        self.floatView = floatView
    }

    init(
        isPresented: Binding<Bool>,
        updatingValue: Binding<V?>,
        dismissPolicy: DismissPolicy = .manually,
        presentingAnimation: Animation? = .none,
        dismissingAnimation: Animation? = .none,
        onDismiss: (() -> Void)? = nil,
        floatView: @escaping () -> any View
    ) {
        _isPresented = isPresented
        self.updatingValue = updatingValue
        self.presentingAnimation = presentingAnimation
        self.dismissingAnimation = dismissingAnimation
        self.dismissPolicy = dismissPolicy
        self.onDismiss = onDismiss
        self.floatView = floatView
    }

    @State private var animationWorkItem: DispatchWorkItem?
    @State private var floatHC: FloatHostingController<AnyView>?
    @State private var floatRootView: HitTestingView?

    func body(content: Content) -> some View {
        content
            .onChange(of: updatingValue.wrappedValue) {
                if $0 != nil {
                    isPresented = true
                }
            }
            .onChange(of: isPresented) {
                if $0 {
                    present()
                } else {
                    dismiss()
                }
            }
            .onDisappear {
                if case .onViewDisappear = dismissPolicy {
                    floatHC?.hide(animation: dismissingAnimation) {
                        dismiss()
                    }
                }
            }
    }

    @MainActor
    func present() {
        animationWorkItem?.cancel()
        animationWorkItem = nil
        floatRootView?.onHitTest = nil
        floatRootView?.removeFromSuperview()
        floatRootView = nil
        floatHC = nil
        
        let floatHC: FloatHostingController<AnyView> = FloatHostingController(rootView: AnyView(floatView()))
        self.floatHC = floatHC
        if let hostingView = floatHC.view,
           let windowScene = UIApplication.shared.connectedScenes
               .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let topView = windowScene.windows.first(where: { $0.isKeyWindow }) {
            let hitTestingView = HitTestingView()
            floatRootView = hitTestingView
            if dismissPolicy.isOnTouchOutside {
                floatRootView?.onHitTest = { [weak floatHC] in
                    if $0 == nil {
                        floatHC?.hide(animation: dismissingAnimation) {
                            dismiss()
                        }
                    }
                }
            }
            hitTestingView.addSubview(hostingView)
            topView.addSubview(hitTestingView)
            hostingView.frame = topView.frame
            hitTestingView.frame = topView.frame
            floatHC.show(animation: presentingAnimation)

            if case .after(let seconds) = dismissPolicy {
                let workItem = DispatchWorkItem { [weak floatHC] in
                    floatHC?.hide(animation: dismissingAnimation) {
                        dismiss()
                    }
                }
                
                animationWorkItem = workItem

                DispatchQueue.main.asyncAfter(
                    deadline: .now() + seconds,
                    execute: workItem
                )
            }
        }
    }
    
    @MainActor
    func dismiss() {
        animationWorkItem?.cancel()
        animationWorkItem = nil
        floatRootView?.onHitTest = nil
        floatRootView?.removeFromSuperview()
        floatRootView = nil
        floatHC = nil
        isPresented = false
        updatingValue.wrappedValue = nil
        onDismiss?()
    }
}

private final class HitTestingView: UIView {
    var onHitTest: ((UIView?) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }

        if hitView.isSwiftUIView {
            onHitTest?(hitView)
            return hitView
        } else if hitView.isUIHostingView {
            if hitView.subviews.reversed().first(where: { $0.hitTest(
                $0.convert(point, from: hitView),
                with: event
            ) != nil }) != nil {
                onHitTest?(hitView)
                return hitView
            }
        }
        onHitTest?(nil)
        return nil
    }
}

private final class FloatHostingController<C: View>: UIHostingController<C> {
    override init(rootView: C) {
        super.init(rootView: rootView)
        view.alpha = 0
        view.backgroundColor = .clear
    }

    @MainActor @preconcurrency dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(animation: Animation?) {
        if let animation {
            if #available(iOS 18.0, *) {
                UIView.animate(animation, changes: {
                    self.view.alpha = 1
                })
            } else {
                UIView.animate(withDuration: animation == .default ? 0 : 0.35) {
                    self.view.alpha = 1
                }
            }
        } else {
            view.alpha = 1
        }
    }

    func hide(animation: Animation?, completion: (() -> Void)? = nil) {
        if let animation {
            if #available(iOS 18.0, *) {
                UIView.animate(
                    animation,
                    changes: {
                        self.view.alpha = 0
                    },
                    completion: completion
                )
            } else {
                UIView.animate(withDuration: animation == .default ? 0 : 0.35) {
                    self.view.alpha = 0
                } completion: { finished in
                    if finished {
                        completion?()
                    }
                }
            }
        } else {
            view.alpha = 0
            completion?()
        }
    }
}
