//
//  FloatModifier.swift
//  Views
//
//  Created by 김삼열 on 1/2/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public struct FloatModifier<C: View>: ViewModifier {
    @Environment(\.floatingWindow) private var floatingWindow

    @Binding private var presenting: (isPresented: Bool, animated: Bool)
    private let dismissWhenDisappearing: Bool
    private let floatingView: () -> C
    public init(
        presenting: Binding<(isPresented: Bool, animated: Bool)>,
        dismissWhenDisappearing: Bool = true,
        content: @escaping () -> C
    ) {
        _presenting = presenting
        self.dismissWhenDisappearing = dismissWhenDisappearing
        floatingView = content
    }

    public init(
        isPresented: Binding<Bool>,
        dismissWhenDisappearing: Bool = true,
        content: @escaping () -> C
    ) {
        _presenting = Binding(
            get: { (isPresented: isPresented.wrappedValue, animated: false)
            },
            set: { isPresented.wrappedValue = $0.isPresented }
        )
        self.dismissWhenDisappearing = dismissWhenDisappearing
        floatingView = content
    }

    @State private var viewDidLoad = false
    @State private var viewDidDisappear = false
    @State private var viewHash = 0
    @State private var size: CGSize = .zero

    public func body(content: Content) -> some View {
        ZStack {
            floatingView()
                .onGeometryChange(for: CGSize.self, of: { $0.size }, action: { size = $0 })
                .opacity(0)
            content
        }
        .if(floatingWindow == nil && presenting.isPresented) {
            $0.overlay(alignment: .center) {
                floatingView()
            }
        }
        .onAppear {
            defer { viewDidLoad = true }
            viewDidDisappear = false

            if !viewDidLoad || dismissWhenDisappearing {
                viewHash = floatingWindow?.addSubview(swiftUIView: rootView) ?? 0
                floatingWindow?.layoutSubview(hashValue: viewHash, size: size)
                floatingWindow?.setSubviewHidden(hashValue: viewHash, hidden: true)
            }
        }
        .onChange(of: size) { _ in
            floatingWindow?.layoutSubview(hashValue: viewHash, size: size)
        }
        .onChange(of: presenting.isPresented) { _ in
            floatingWindow?.setSubviewHidden(
                hashValue: viewHash,
                hidden: !presenting.isPresented,
                animated: presenting.animated
            )
            if !presenting.isPresented {
                if dismissWhenDisappearing && viewDidDisappear {
                    floatingWindow?.removeSubView(hashValue: viewHash)
                }
            }
        }
        .onDisappear {
            defer { viewDidDisappear = true }

            if dismissWhenDisappearing {
                presenting = (isPresented: false, animated: false)
                floatingWindow?.removeSubView(hashValue: viewHash)
            }
        }
    }

    var rootView: some View {
        SwiftUI.Color.clear
            .ignoresSafeArea(.all)
            .overlay(alignment: .center) {
                floatingView()
            }
    }
}

public class FloatingWindow: UIWindow {
    override public init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        rootViewController = UIViewController()
        rootViewController?.view.backgroundColor = .clear
        windowLevel = .alert
        isHidden = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == hitView || hitView
            .getPixelColor(at: point) == UIColor.rgb(0, 0, 0, 0) ? nil : hitView
    }

    func addSubview<V: View>(swiftUIView: V) -> Int? {
        guard let rootView = rootViewController?.view,
              let subview = UIHostingController(rootView: swiftUIView).view else { return nil }
        rootView.addSubview(subview)
        subview.backgroundColor = .clear
        return subview.hashValue
    }

    func findSubview(_ hashValue: Int) -> UIView? {
        rootViewController?.view.subviews.first(where: { $0.hashValue == hashValue })
    }

    func layoutSubview(hashValue: Int, size: CGSize) {
        if let rootView = rootViewController?.view,
           let subview = findSubview(hashValue) {
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
            subview.centerYAnchor.constraint(equalTo: rootView.centerYAnchor).isActive = true
            subview.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            subview.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func setSubviewHidden(hashValue: Int, hidden: Bool, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.35) {
                self.findSubview(hashValue)?.alpha = hidden ? 0 : 1
            }
        } else {
            findSubview(hashValue)?.alpha = hidden ? 0 : 1
        }
    }

    func removeSubView(hashValue: Int) {
        findSubview(hashValue)?.removeFromSuperview()
    }
}

fileprivate extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }

    func getPixelColor(at point: CGPoint) -> UIColor? {
        asImage().cgImage?.getPixelColor(at: point)
    }
}

fileprivate extension CGImage {
    func getPixelColor(at point: CGPoint) -> UIColor? {
        guard let provider = dataProvider else { return nil }
        let pixelData = provider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let count: CFIndex = CFDataGetLength(pixelData)
        let pixelInfoIndex: Int = ((Int(width) * Int(point.y)) + Int(point.x)) * 4
        guard pixelInfoIndex < count else { return nil }

        let r = Int(data[pixelInfoIndex])
        let g = Int(data[pixelInfoIndex + 1])
        let b = Int(data[pixelInfoIndex + 2])
        let a = CGFloat(data[pixelInfoIndex + 3]) / CGFloat(255.0)
        return UIColor.rgb(r, g, b, a)
    }
}

fileprivate extension UIColor {
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}
