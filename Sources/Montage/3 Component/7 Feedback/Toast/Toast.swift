//
//  Toast.swift
//
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

/// 화면의 상단 또는 하단에 짧게 표시되는 알림 메시지 컴포넌트입니다.
///
/// 사용자에게 간단한 피드백이나 정보를 제공하기 위해 사용합니다.
/// 일반, 긍정, 주의, 부정적인 상태로 표시할 수 있으며,
/// 설정된 시간이 지나면 자동으로 사라집니다.
///
/// **사용 예시**:
/// ```swift
/// // 토스트 메시지 표시
/// @State private var toastModel: Toast.Model?
///
/// var body: some View {
///     ContentView()
///         .modifier(
///             Toast.ToastModifier(
///                 model: $toastModel,
///                 location: .bottom(),
///                 duration: .short
///             )
///         )
///         .onAppear {
///             toastModel = Toast.Model(
///                 .positive,
///                 message: "성공적으로 저장되었습니다."
///             )
///         }
/// }
/// ```
///
/// - SeeAlso: `Toast.Model`, `Toast.Variant`, `Toast.Location`, `Toast.Duration`, `Toast.ToastModifier`
public struct Toast: View {
    /// 토스트 메시지의 데이터 모델을 정의하는 구조체입니다.
    ///
    /// 토스트에 표시할 메시지와 스타일을 설정할 수 있습니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// // 기본 토스트 모델
    /// Toast.Model(message: "작업이 완료되었습니다.")
    ///
    /// // 특정 상태의 토스트 모델
    /// Toast.Model(.negative, message: "오류가 발생했습니다.")
    ///
    /// // 아이콘이 있는 토스트 모델
    /// Toast.Model(.normal(Icon.bell), message: "새 알림이 있습니다.")
    /// ```
    public struct Model: Equatable {
        private let id = UUID()
        let variant: Toast.Variant
        let message: String
        
        /// Toast 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - variant: 토스트 메시지의 스타일 (기본값: .normal())
        ///   - message: 토스트에 표시할 메시지 텍스트
        public init(
            _ variant: Toast.Variant = .normal(),
            message: String
        ) {
            self.variant = variant
            self.message = message
        }
    }

    /// 토스트 메시지의 시각적 스타일을 정의하는 열거형입니다.
    ///
    /// - normal: 기본 토스트 스타일 (선택적으로 아이콘과 색상 지정 가능)
    /// - positive: 성공이나 긍정적인 메시지를 위한 녹색 체크 아이콘 스타일
    /// - cautionary: 주의가 필요한 메시지를 위한 주황색 경고 아이콘 스타일
    /// - negative: 오류나 실패 메시지를 위한 빨간색 아이콘 스타일
    public enum Variant: Equatable {
        /// 기본 스타일의 토스트
        /// - Parameters:
        ///   - icon: 표시할 아이콘 (선택 사항)
        ///   - tint: 아이콘의 색상 (선택 사항)
        case normal(Montage.Icon? = nil, tint: Montage.Color.Semantic? = nil)
        
        /// 성공 메시지를 위한 녹색 체크 아이콘 스타일
        case positive
        
        /// 주의 메시지를 위한 주황색 경고 아이콘 스타일
        case cautionary
        
        /// 오류 메시지를 위한 빨간색 경고 아이콘 스타일
        case negative
    }
    
    /// 토스트 메시지가 표시될 위치를 정의하는 열거형입니다.
    ///
    /// - top: 화면 상단에 표시
    /// - bottom: 화면 하단에 표시
    public enum Location {
        /// 화면 상단에 토스트 표시
        /// - Parameter offset: 상단에서의 오프셋 값 (기본값: 0)
        case top(offset: CGFloat = .zero)
        
        /// 화면 하단에 토스트 표시
        /// - Parameter offset: 하단에서의 오프셋 값 (기본값: 0)
        case bottom(offset: CGFloat = .zero)
    }
    
    /// 토스트 메시지의 표시 시간을 정의하는 열거형입니다.
    ///
    /// - short: 짧은 표시 시간 (3초)
    /// - long: 긴 표시 시간 (5초)
    public enum Duration {
        case short, long
    }
    
    private let variant: Variant
    private let message: String
    private let location: Location
    
    init(
        _ variant: Variant = .normal(),
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
                        .montage(variant: .body2, weight: .bold, semantic: .staticWhite)
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
            case let .normal(icon, tint):
                if let icon {
                    let tintColor: Montage.Color.Semantic = {
                        if let tint {
                            tint
                        } else {
                            .staticWhite
                        }
                    }()
                    Image.montage(icon)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.semantic(tintColor))
                        .frame(width: 22, height: 22)
                } else {
                    EmptyView()
                }
            case .positive:
                ZStack {
                    Circle()
                        .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
                        .frame(width: 11, height: 11)
                    Image.montage(.circleCheckFill)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.atomic(.green60))
                        .frame(width: 22, height: 22)
                }
            case .cautionary:
                ZStack {
                    Circle()
                        .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
                        .frame(width: 11, height: 11)
                    Image.montage(.triangleExclamationFill)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.atomic(.orange60))
                        .frame(width: 22, height: 22)
                }
            case .negative:
                ZStack {
                    Circle()
                        .foregroundStyle(SwiftUI.Color.semantic(.staticWhite))
                        .frame(width: 11, height: 11)
                    Image.montage(.circleExclamationFill)
                        .resizable()
                        .foregroundStyle(SwiftUI.Color.atomic(.red60))
                        .frame(width: 22, height: 22)
                }
            }
        }
    }

    private struct BackgroundView: View {
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            ZStack {
                SwiftUI.Color.semantic(.inverseBackground).opacity(colorScheme == .light ? 0.5 : 0.46)
                SwiftUI.Color.semantic(.primaryNormal).opacity(0.05)
            }
            .background(
                .ultraThinMaterial
            )
        }
    }
}

extension Toast {
    /// Toast를 화면에 표시하기 위한 뷰 모디파이어입니다.
    ///
    /// 바인딩된 Model 값이 nil이 아닐 때 토스트를 표시하며,
    /// 설정된 시간이 지나면 자동으로 사라집니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var toastModel: Toast.Model?
    ///
    /// var body: some View {
    ///     VStack {
    ///         Button("토스트 표시") {
    ///             toastModel = Toast.Model(
    ///                 .cautionary,
    ///                 message: "주의가 필요합니다."
    ///             )
    ///         }
    ///     }
    ///     .modifier(
    ///         Toast.ToastModifier(
    ///             model: $toastModel,
    ///             location: .top(),
    ///             duration: .long
    ///         )
    ///     )
    /// }
    /// ```
    ///
    /// - Note: 토스트가 표시될 때 진동 피드백이 발생합니다.
    public struct ToastModifier: ViewModifier {
        @Binding private var model: Toast.Model?
        private let location: Toast.Location
        private let duration: Toast.Duration
        
        /// ToastModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - model: 표시할 토스트 모델에 대한 바인딩. nil이면 토스트가 표시되지 않습니다.
        ///   - location: 토스트가 표시될 위치
        ///   - duration: 토스트가 표시될 시간
        init(model: Binding<Toast.Model?>, location: Toast.Location, duration: Toast.Duration) {
            _model = model
            self.location = location
            self.duration = duration
        }

        public func body(content: Content) -> some View {
            content
                .modifier(
                    FloatModifier(
                        isPresented: model != nil,
                        updatingValue: $model,
                        dismissPolicy: .after(seconds: durationTime),
                        presentingAnimation: .easeIn(duration: 0.35),
                        dismissingAnimation: .easeIn(duration: 0.35),
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
                )
                .onChange(of: model) { _ in
                    if model != nil {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    }
                }
        }
        
        private var durationTime: TimeInterval {
            switch duration {
            case .short: 3
            case .long: 5
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 Toast 메시지를 표시하는 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - model: Toast 모델을 바인딩합니다. nil이 아닌 값이 설정되면 Toast가 표시됩니다.
    ///   - location: Toast가 표시될 위치 (기본값: .bottom)
    ///   - duration: Toast가 표시될 시간 (기본값: .short)
    /// - Returns: Toast가 적용된 뷰
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var toastModel: Toast.Model?
    ///
    /// var body: some View {
    ///     VStack {
    ///         Button("Show Toast") {
    ///             toastModel = Toast.Model(message: "작업이 완료되었습니다")
    ///         }
    ///     }
    ///     .toast($toastModel)
    /// }
    /// ```
    public func toast(
        _ model: Binding<Toast.Model?>,
        location: Toast.Location = .bottom(offset: 0),
        duration: Toast.Duration = .short
    ) -> some View {
        modifier(Toast.ToastModifier(model: model, location: location, duration: duration))
    }
}
