//
//  FloatModifier.swift
//  Views
//
//  Created by 김삼열 on 1/2/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public struct FloatModifier<C: View>: ViewModifier {
    @Environment(\.windowScene) private var windowScene

    @Binding private var isPresented: Bool
    private let floatingView: () -> C
    public init(isPresented: Binding<Bool>, content: @escaping () -> C) {
        _isPresented = isPresented
        floatingView = content
    }

    @State private var floatingWindow: FloatingWindow?

    public func body(content: Content) -> some View {
        content
            .if(windowScene == nil && isPresented) {
                $0.overlay(alignment: .center) {
                    floatingView()
                }
            }
            .onAppear {
                if let windowScene {
                    let floatingViewController = UIHostingController(
                        rootView: SwiftUI.Color.clear
                            .ignoresSafeArea(.all)
                            .overlay(alignment: .center) {
                                floatingView()
                            }
                    )
                    floatingViewController.view.backgroundColor = .clear
                    floatingWindow = FloatingWindow(windowScene: windowScene)
                    floatingWindow?.rootViewController = floatingViewController
                    floatingWindow?.windowLevel = .alert
                }
            }
            .onChange(of: isPresented) { isPresented in
                floatingWindow?.isHidden = !isPresented
            }
    }
}

public class FloatingWindow: UIWindow {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == hitView ? nil : hitView
    }
}
