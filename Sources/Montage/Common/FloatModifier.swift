//
//  FloatModifier.swift
//  Montage
//
//  Created by 김삼열 on 1/2/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public struct FloatModifier<V: Equatable>: ViewModifier {
    public enum PresentationPolicy: Equatable {
        case presentIfNotNil(_ value: V?)
        case presentIfTrue(_ value: V)

        public static func == (
            lhs: FloatModifier<V>.PresentationPolicy,
            rhs: FloatModifier<V>.PresentationPolicy
        ) -> Bool {
            switch (lhs, rhs) {
            case (.presentIfNotNil(let lhsValue), .presentIfNotNil(let rhsValue)):
                lhsValue == rhsValue
            case (.presentIfTrue(let lhsValue), .presentIfTrue(let rhsValue)):
                lhsValue == rhsValue
            default: false
            }
        }

        var isPresented: Bool {
            switch self {
            case .presentIfNotNil(let value):
                return value != nil
            case .presentIfTrue(let value):
                return value as? Bool ?? false
            }
        }
    }

    public enum DismissPolicy {
        case after(seconds: TimeInterval)
        case onTap
        case onDisappear

        var isOnTap: Bool {
            switch self {
            case .onTap: true
            default: false
            }
        }
    }

    private let presentationPolicy: PresentationPolicy
    private let presentingAnimation: Animation
    private let dismissingAnimation: Animation
    private let dismissPolicy: DismissPolicy
    private let onDismiss: (() -> Void)?
    private let floatView: () -> any View

    public init(
        presentationPolicy: PresentationPolicy,
        presentingAnimation: Animation = .default,
        dismissingAnimation: Animation = .default,
        dismissPolicy: DismissPolicy = .onDisappear,
        onDismiss: (() -> Void)? = nil,
        floatView: @escaping () -> any View
    ) {
        self.presentationPolicy = presentationPolicy
        self.presentingAnimation = presentingAnimation
        self.dismissingAnimation = dismissingAnimation
        self.dismissPolicy = dismissPolicy
        self.onDismiss = onDismiss
        self.floatView = floatView
    }

    @State private var animationWorkItem: DispatchWorkItem?
    @State private var floatHC: FloatHostingController<AnyView>?
    @State private var floatRootView: HitTestingView?

    public func body(content: Content) -> some View {
        content
            .onChange(of: presentationPolicy) { presentationPolicy in
                if presentationPolicy.isPresented {
                    floatRootView?.removeFromSuperview()
                    let floatHC = FloatHostingController(rootView: AnyView(floatView()))
                    self.floatHC = floatHC
                    if let hostingView = floatHC.view,
                       let topView = UIApplication.windows?.first {
                        let hitTestingView = HitTestingView()
                        floatRootView = hitTestingView
                        hitTestingView.addSubview(hostingView)
                        topView.addSubview(hitTestingView)
                        hostingView.frame = topView.frame
                        hitTestingView.frame = topView.frame
                        floatHC.show(animation: presentingAnimation)

                        if case .after(let seconds) = dismissPolicy {
                            animationWorkItem?.cancel()

                            animationWorkItem = DispatchWorkItem {
                                floatHC.hide(animation: dismissingAnimation, completion: onDismiss)

                                animationWorkItem = nil
                            }

                            if let animationWorkItem {
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + seconds,
                                    execute: animationWorkItem
                                )
                            }
                        }
                    }
                } else {
                    floatRootView?.removeFromSuperview()
                }
            }
            .if(dismissPolicy.isOnTap) {
                $0.onTapGesture {
                    if case .onTap = dismissPolicy {
                        floatHC?.hide(animation: dismissingAnimation, completion: onDismiss)
                    }
                }
            }
            .onDisappear {
                if case .onDisappear = dismissPolicy {
                    floatHC?.hide(animation: dismissingAnimation, completion: onDismiss)
                }
            }
    }
}

private final class HitTestingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }

        if hitView.isSwiftUIView {
            return hitView
        } else if hitView.isUIHostingView {
            if hitView.subviews.reversed().first(where: { $0.hitTest(
                $0.convert(point, from: hitView),
                with: event
            ) != nil }) != nil {
                return hitView
            }
        }
        return nil
    }
}

private final class FloatHostingController<C: View>: UIHostingController<C> {
    override public init(rootView: C) {
        super.init(rootView: rootView)
        view.alpha = 0
        view.backgroundColor = .clear
    }

    @MainActor @preconcurrency dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(animation: Animation) {
        if #available(iOS 18.0, *) {
            UIView.animate(animation, changes: {
                self.view.alpha = 1
            })
        } else {
            UIView.animate(withDuration: animation == .default ? 0 : 0.35) {
                self.view.alpha = 1
            }
        }
    }

    func hide(animation: Animation, completion: (() -> Void)? = nil) {
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
    }
}
