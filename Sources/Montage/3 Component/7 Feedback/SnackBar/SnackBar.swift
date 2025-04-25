//
//  SnackBar.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

/// 화면 하단에 임시로 표시되는 알림 메시지 컴포넌트입니다.
///
/// 사용자에게 짧은 피드백이나 알림을 제공하기 위해 사용합니다.
/// 제목, 설명, 추가 콘텐츠와 액션 버튼을 포함할 수 있으며,
/// 설정된 시간이 지나면 자동으로 사라집니다.
///
/// **사용 예시**:
/// ```swift
/// // 모델을 통한 스낵바 표시
/// @State private var snackBarModel: SnackBar.Model?
///
/// var body: some View {
///     ContentView()
///         .modifier(
///             SnackBar.SnackBarModifier(
///                 model: $snackBarModel,
///                 handler: {
///                     // 액션 버튼 클릭 시 실행할 코드
///                 }
///             )
///         )
///         .onAppear {
///             snackBarModel = SnackBar.Model(
///                 duration: .short,
///                 description: "작업이 완료되었습니다.",
///                 action: "확인"
///             )
///         }
/// }
/// ```
///
/// - SeeAlso: `SnackBar.Duration`, `SnackBar.Model`, `SnackBar.SnackBarModifier`
public struct SnackBar: View {
    /// SnackBar가 자동으로 사라지는 시간을 정의하는 열거형입니다.
    ///
    /// - short: 짧은 표시 시간 (4초)
    /// - long: 긴 표시 시간 (16초)
    public enum Duration: Double {
        case short = 4.0
        case long = 16.0
    }

    /// SnackBar의 데이터 모델을 정의하는 구조체입니다.
    ///
    /// 스낵바에 표시할 콘텐츠와 동작 방식을 설정할 수 있습니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// // 기본 스낵바 모델
    /// SnackBar.Model(
    ///     description: "저장되었습니다.",
    ///     action: "확인"
    /// )
    ///
    /// // 모든 요소를 활용한 스낵바 모델
    /// SnackBar.Model(
    ///     duration: .long,
    ///     heading: "알림",
    ///     description: "새로운 메시지가 도착했습니다.",
    ///     extraContents: {
    ///         Image.montage(.bell)
    ///             .resizable()
    ///             .frame(width: 24, height: 24)
    ///     },
    ///     action: "보기"
    /// )
    /// ```
    public struct Model: Equatable {
        let duration: Duration
        var heading: String? = nil
        var description: String? = nil
        var extraContents: (() -> any View)? = nil
        let action: String
        
        /// SnackBar 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - duration: 스낵바가 표시되는 시간
        ///   - heading: 스낵바의 제목 (선택 사항)
        ///   - description: 스낵바의 설명 텍스트 (선택 사항)
        ///   - extraContents: 스낵바에 표시할 추가 콘텐츠를 반환하는 클로저 (선택 사항)
        ///   - action: 스낵바의 액션 버튼에 표시할 텍스트
        public init(
            duration: Duration = .short,
            heading: String? = nil,
            description: String? = nil,
            extraContents: (() -> any View)? = nil,
            action: String
        ) {
            self.duration = duration
            self.heading = heading
            self.description = description
            self.extraContents = extraContents
            self.action = action
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.heading == rhs.heading
                && lhs.description == rhs.description
                && lhs.action == rhs.action
        }
    }
    
    private var heading: String?
    private var description: String?
    private var extraContents: (() -> any View)?
    private let action: String
    private let handler: () -> Void
    
    init(
        heading: String? = nil,
        description: String? = nil,
        extraContents: (() -> any View)? = nil,
        action: String,
        handler: @escaping () -> Void
    ) {
        self.heading = heading
        self.description = description
        self.extraContents = extraContents
        self.action = action
        self.handler = handler
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Contents(
                heading: heading,
                description: description,
                extraContents: extraContents,
                action: action,
                handler: handler
            )
            .padding(.horizontal, 20)
        }
    }
    
    fileprivate struct Contents: View {
        private var heading: String?
        private var description: String?
        private var extraContents: (() -> any View)?
        private let action: String
        private let handler: (() -> Void)?
        
        public init(
            heading: String? = nil,
            description: String? = nil,
            extraContents: (() -> any View)? = nil,
            action: String,
            handler: (() -> Void)? = nil
        ) {
            self.heading = heading
            self.description = description
            self.extraContents = extraContents
            self.action = action
            self.handler = handler
        }
        
        var body: some View {
            ZStack {
                HStack(alignment: .center, spacing: .zero) {
                    if let extraContents {
                        AnyView(extraContents())
                        Spacer()
                            .frame(width: 12)
                    }
                    ZStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: .zero) {
                            if let heading {
                                Text(heading)
                                    .montage(variant: .body2, weight: .bold, semantic: .staticWhite)
                                    .paragraph(variant: .body2)
                            }
                            if let description {
                                Text(description)
                                    .montage(variant: .label2, weight: .regular, semantic: .staticWhite)
                                    .paragraph(variant: .label2)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.vertical, 5)
                    }
                    Spacer()
                    Action(action, handler)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(
                BackgroundView()
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private struct Action: View {
        @State private var isPressed = false
        @State private var interaction: Decorate.Interaction.State = .normal
        
        private let action: String
        private let handler: (() -> Void)?
        
        init(_ action: String, _ handler: (() -> Void)?) {
            self.action = action
            self.handler = handler
        }
        
        var body: some View {
            Text(action)
                .montage(variant: .body2, weight: .bold, semantic: .staticWhite)
                .paragraph(variant: .body2)
                .background(
                    Decorate.Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .light,
                        color: .backgroundNormal
                    )
                    .padding(.horizontal, -7)
                    .padding(.vertical, -4)
                )
                .modifier(PressActionDetectingModifier(isPressed: $isPressed) {
                    handler?()
                })
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
    
    /// SnackBar를 화면에 표시하기 위한 뷰 모디파이어입니다.
    ///
    /// 바인딩된 Model 값이 nil이 아닐 때 스낵바를 표시하며,
    /// 설정된 시간이 지나면 자동으로 사라집니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var snackBarModel: SnackBar.Model?
    ///
    /// var body: some View {
    ///     VStack {
    ///         // 콘텐츠
    ///     }
    ///     .modifier(
    ///         SnackBar.SnackBarModifier(
    ///             model: $snackBarModel,
    ///             handler: {
    ///                 print("액션 버튼 클릭됨")
    ///             }
    ///         )
    ///     )
    ///     .onTapGesture {
    ///         snackBarModel = SnackBar.Model(
    ///             description: "탭 감지됨",
    ///             action: "확인"
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Note: 스낵바가 표시될 때 진동 피드백이 발생합니다.
    public struct SnackBarModifier: ViewModifier {
        @Binding var model: SnackBar.Model?
        @State private var animationWorkItem: DispatchWorkItem?

        let handler: () -> Void
        
        /// SnackBarModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - model: 표시할 스낵바 모델에 대한 바인딩. nil이면 스낵바가 표시되지 않습니다.
        ///   - handler: 스낵바의 액션 버튼이 클릭될 때 실행할 핸들러
        public init(model: Binding<SnackBar.Model?>, handler: @escaping () -> Void) {
            self._model = model
            self.handler = handler
        }

        public func body(content: Content) -> some View {
            GeometryReader { proxy in
                content
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .overlay(
                        snackBar()
                    )
                    .onChange(
                        of: model
                    ) { newValue in
                        guard newValue != nil else { return }
                        showSnackBar()
                    }
            }
        }
        
        @ViewBuilder
        private func snackBar() -> some View {
            if let model {
                SnackBar(
                    heading: model.heading,
                    description: model.description,
                    extraContents: model.extraContents,
                    action: model.action,
                    handler: {
                        handler()
                        self.model = nil
                    }
                )
            }
        }
        
        private func showSnackBar() {
            animationWorkItem?.cancel()
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            let task = DispatchWorkItem {
                dismissSnackBar()
            }
            
            animationWorkItem = task
            
            DispatchQueue.main.asyncAfter(
                deadline: .now() + (model?.duration.rawValue ?? 4.0),
                execute: task
            )
        }
        
        private func dismissSnackBar() {
            withAnimation {
                model = nil
            }
            
            animationWorkItem?.cancel()
            animationWorkItem = nil
        }
    }
}

struct SnackBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SnackBar(
                heading: "메시지에 마침표를 찍어요.",
                description: "설명은 필요할 때만 써요.",
                action: "텍스트",
                handler: {}
            )
            SnackBar(
                description: "메시지가 두 줄 이상 길어지는 경우 예외적으로 사용해요.",
                action: "텍스트",
                handler: {}
            )
            SnackBar(
                description: "메시지에 마침표를 찍어요.",
                extraContents: {
                    Image.montage(.android).resizable().frame(width: 32, height: 32)
                },
                action: "텍스트",
                handler: {}
            )
            SnackBar(
                heading: "메시지에 마침표를 찍어요.",
                description: "설명은 필요할 때만 써요.",
                extraContents: {
                    Image.montage(.android).resizable().frame(width: 32, height: 32)
                },
                action: "텍스트",
                handler: {}
            )
            SnackBar(
                heading: "흠",
                description: "흠 이게 몇줄까지되는걸까용가리어카메라이터보닥트리오리꽥꼬ㅒㄱ고양이는띠방",
                extraContents: {
                    Image.montage(.android).resizable().frame(width: 32, height: 32)
                },
                action: "텍스트",
                handler: {}
            )
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 SnackBar를 표시하는 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - model: SnackBar 모델을 바인딩합니다. nil이 아닌 값이 설정되면 SnackBar가 표시됩니다.
    ///   - handler: SnackBar의 액션 버튼이 클릭되었을 때 실행될 클로저
    /// - Returns: SnackBar가 적용된 뷰
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var snackBarModel: SnackBar.Model?
    ///
    /// var body: some View {
    ///     VStack {
    ///         Button("Show SnackBar") {
    ///             snackBarModel = SnackBar.Model(
    ///                 description: "작업이 완료되었습니다",
    ///                 action: "확인"
    ///             )
    ///         }
    ///     }
    ///     .snackBar($snackBarModel) {
    ///         // 액션 버튼 클릭 시 실행될 코드
    ///     }
    /// }
    /// ```
    public func snackBar(_ model: Binding<SnackBar.Model?>, handler: @escaping () -> Void) -> some View {
        modifier(SnackBar.SnackBarModifier(model: model, handler: handler))
    }
}
