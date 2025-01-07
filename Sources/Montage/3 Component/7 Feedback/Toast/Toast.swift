//
//  Toast.swift
//
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

public struct Toast: View {
    public struct Model: Equatable {
        let variant: Toast.Variant
        let message: String
        let location: Toast.Location
        
        public init(
            _ variant: Toast.Variant = .message,
            message: String,
            location: Toast.Location = .bottom(offset: .zero)
        ) {
            self.variant = variant
            self.message = message
            self.location = location
        }
    }

    public enum Variant: Equatable {
        case message
        case success
        case warning
        case custom(Montage.Icon, tint: Montage.Color.Alias? = nil)
    }
    
    public enum Location: Equatable {
        case top(offset: CGFloat = .zero)
        case bottom(offset: CGFloat = .zero)
    }
    
    private let variant: Variant
    private let message: String
    private let location: Location
    
    init(
        _ variant: Variant = .message,
        message: String = "",
        _ location: Location = .bottom(offset: .zero)
    ) {
        self.variant = variant
        self.message = message
        self.location = location
    }
    
    public var body: some View {
        switch location {
        case .top(let offset):
            VStack {
                Contents(variant, message)
                    .padding(.horizontal, 20)
                    .padding(.top, offset)
                Spacer()
            }
        case .bottom(let offset):
            VStack {
                Spacer()
                Contents(variant, message)
                    .padding(.horizontal, 20)
                    .padding(.bottom, offset)
            }
        }
    }
    
    fileprivate struct Contents: View {
        private let variant: Variant
        private let message: String
        
        init(_ variant: Variant, _ message: String) {
            self.variant = variant
            self.message = message
        }
        
        var body: some View {
            ZStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 8) {
                    Icon(variant)
                    Text(message)
                        .montage(variant: .body2, weight: .bold, alias: .staticWhite)
                        .paragraph(variant: .body2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
            }
            .padding(.vertical, 11)
            .padding(.horizontal, 16)
            .background(
                BackgroundView()
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private struct Icon: View {
        private let variant: Variant
        
        init(_ variant: Variant) {
            self.variant = variant
        }
        
        var body: some View {
            switch variant {
            case .message:
                EmptyView()
            case .success:
                ZStack {
                    Circle()
                        .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
                        .frame(width: 11, height: 11)
                    Image.montage(.circleCheckFill)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.alias(.statusPositive))
                        .frame(width: 22, height: 22)
                }
            case .warning:
                ZStack {
                    Circle()
                        .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
                        .frame(width: 11, height: 11)
                    Image.montage(.circleExclamationFill)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.alias(.statusCautionary))
                        .frame(width: 22, height: 22)
                }
            case let .custom(icon, tint):
                let tintColor: Montage.Color.Alias = {
                    if let tint {
                        tint
                    } else {
                        .staticWhite
                    }
                }()
                Image.montage(icon)
                    .resizable()
                    .foregroundStyle(SwiftUI.Color.alias(tintColor))
                    .frame(width: 22, height: 22)
            }
        }
    }

    private struct BackgroundView: View {
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            ZStack {
                SwiftUI.Color.alias(.inverseBackground).opacity(colorScheme == .light ? 0.5 : 0.46)
                SwiftUI.Color.alias(.primaryNormal).opacity(0.05)
            }
            .background(
                .ultraThinMaterial
            )
        }
    }
}

extension Toast {
    public struct LegacyToastModifier: ViewModifier {
        @Binding var model: Toast.Model?
        @State private var animationWorkItem: DispatchWorkItem?
        
        public func body(content: Content) -> some View {
            GeometryReader { proxy in
                content
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .overlay {
                        toast()
                    }
                    .onChange(
                        of: model
                    ) { toastModel in
                        guard toastModel != nil else { return }
                        showToast()
                    }
            }
        }
        
        @ViewBuilder
        private func toast() -> some View {
            if let model {
                Toast(model.variant, message: model.message, model.location)
            }
        }
        
        private func showToast() {
            animationWorkItem?.cancel()
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            animationWorkItem = task
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2.0,
                execute: task
            )
        }
        
        private func dismissToast() {
            withAnimation {
                model = nil
            }
            
            animationWorkItem?.cancel()
            animationWorkItem = nil
        }
    }
    
    public struct ToastModifier: ViewModifier {
        @Binding private var isPresented: Bool
        private let model: Toast.Model
        
        init(isPresented: Binding<Bool>, model: Toast.Model) {
            _isPresented = isPresented
            self.model = model
        }
        
        @State private var animationWorkItem: DispatchWorkItem?
        private let floatingDismissAfterWhile = (seconds: 2, animated: true)
        
        public func body(content: Content) -> some View {
            content
                .float(
                    isPresented: $isPresented,
                    dismissAfterWhile: floatingDismissAfterWhile
                ) {
                    Toast(model.variant, message: model.message, model.location)
                }
                .onChange(of: isPresented) { isPresented in
                    if isPresented {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
        }
    }
}

struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Toast(.message, message: "메세지에 마침표를 찍어요.")
            Toast.Contents(.message, "hello world!")
            Toast.Contents(.success, "메세지에 마침표를 찍어요.")
            Toast.Contents(.warning, "메세지에 마침표를 찍어요.")
            Toast.Contents(.custom(.android), "아이콘이 예외적으로 필요한 경우에만 써요.")
        }
    }
}
