//
//  Toast.swift
//
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

public struct Toast: View {
    public struct Model: Equatable {
        private let id = UUID()
        let variant: Toast.Variant
        let message: String
        
        public init(
            _ variant: Toast.Variant = .message,
            message: String
        ) {
            self.variant = variant
            self.message = message
        }
    }

    public enum Variant: Equatable {
        case message
        case success
        case warning
        case custom(Montage.Icon, tint: Montage.Color.Alias? = nil)
    }
    
    public enum Location {
        case top(offset: CGFloat = .zero)
        case bottom(offset: CGFloat = .zero)
    }
    
    public enum Duration {
        case short, long
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
    public struct ToastModifier: ViewModifier {
        @Binding private var model: Toast.Model?
        private let location: Toast.Location
        private let duration: Toast.Duration
        
        init(model: Binding<Toast.Model?>, location: Toast.Location, duration: Toast.Duration) {
            _model = model
            self.location = location
            self.duration = duration
        }

        public func body(content: Content) -> some View {
            content
                .float(
                    presentationPolicy: .presentIfNotNil(model),
                    presentingAnimation: .easeIn(duration: 0.35),
                    dismissingAnimation: .easeIn(duration: 0.35),
                    dismissPolicy: .after(seconds: durationTime),
                    onDismiss: {
                        model = nil
                    },
                    floatView: {
                        Group {
                            if let model {
                                Toast(
                                    model.variant,
                                    message: model.message,
                                    location
                                )
                            }
                        }
                    }
                )
                .onChange(of: model) { _ in
                    if model != nil {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
        }
        
        private var durationTime: TimeInterval {
            switch duration {
            case .short: return 3
            case .long: return 5
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
