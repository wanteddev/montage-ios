//
//  SnackBar.swift
//  Montage
//
//  Created by Ahn Sang Hoon on 6/25/24.
//

import SwiftUI

/// 화면 상단 또는 하단에 임시로 표시되는 알림 메시지 컴포넌트입니다.
///
/// 사용자에게 짧은 피드백이나 알림을 제공하기 위해 사용합니다.
/// 제목, 설명, 추가 콘텐츠와 액션 버튼을 포함할 수 있으며,
/// 설정된 시간이 지나면 자동으로 사라집니다.
///
/// ```swift
/// // 모델을 통한 스낵바 표시
/// @State private var snackBarModel: SnackBar.Model?
///
/// var body: some View {
///     ContentView()
///         .snackBar(
///             $snackBarModel,
///             handler: {
///                 // 액션 버튼 클릭 시 실행할 코드
///             }
///         )
///         .onAppear {
///              snackBarModel = SnackBar.Model(
///                  duration: .short,
///                  description: "작업이 완료되었습니다.",
///                  action: "확인"
///              )
///         }
/// }
/// ```
public struct SnackBar: View {
    /// SnackBar가 자동으로 사라지는 시간을 정의하는 열거형입니다.
    public enum Duration: Double {
        /// 짧은 표시 시간 (4초)
        case short = 4.0
        /// 긴 표시 시간 (16초)
        case long = 16.0
    }

    /// 스낵바가 표시될 위치를 정의하는 열거형입니다.
    public enum Location {
        /// 화면 상단에 스낵바 표시
        /// - Parameter offset: 상단에서의 오프셋 값, 생략하면 기본값으로 `.zero` 적용
        case top(offset: CGFloat = .zero)

        /// 화면 하단에 스낵바 표시
        /// - Parameter offset: 하단에서의 오프셋 값, 생략하면 기본값으로 `.zero` 적용
        case bottom(offset: CGFloat = .zero)
    }

    /// SnackBar의 데이터 모델을 정의하는 구조체입니다.
    ///
    /// 스낵바에 표시할 콘텐츠와 동작 방식을 설정할 수 있습니다.
    ///
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
    ///         Image.icon(.bell)
    ///             .resizable()
    ///             .frame(width: 24, height: 24)
    ///     },
    ///     action: "보기"
    /// )
    /// ```
    public struct Model: Equatable {
        let duration: Duration
        let heading: String?
        let description: String?
        let extraContents: () -> AnyView
        let buttonTitle: String

        /// SnackBar 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - duration: 스낵바가 표시되는 시간, 생략하면 기본값으로 `.short` 적용
        ///   - heading: 스낵바의 제목, 생략하면 기본값으로 `nil` 적용
        ///   - description: 스낵바의 설명 텍스트, 생략하면 기본값으로 `nil` 적용
        ///   - action: 스낵바의 액션 버튼에 표시할 텍스트
        public init(
            duration: Duration = .short,
            heading: String? = nil,
            description: String? = nil,
            action: String
        ) {
            self.duration = duration
            self.heading = heading
            self.description = description
            self.extraContents = { AnyView(EmptyView()) }
            self.buttonTitle = action
        }

        /// SnackBar 모델을 초기화합니다.
        ///
        /// - Parameters:
        ///   - duration: 스낵바가 표시되는 시간, 생략하면 기본값으로 `.short` 적용
        ///   - heading: 스낵바의 제목, 생략하면 기본값으로 `nil` 적용
        ///   - description: 스낵바의 설명 텍스트, 생략하면 기본값으로 `nil` 적용
        ///   - action: 스낵바의 액션 버튼에 표시할 텍스트
        public init<V: View>(
            duration: Duration = .short,
            heading: String? = nil,
            description: String? = nil,
            @ViewBuilder extraContents: @escaping () -> V,
            action: String
        ) {
            self.duration = duration
            self.heading = heading
            self.description = description
            self.extraContents = { AnyView(extraContents()) }
            self.buttonTitle = action
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.heading == rhs.heading
                && lhs.description == rhs.description
                && lhs.buttonTitle == rhs.buttonTitle
        }
    }

    private let heading: String?
    private let description: String?
    private let extraContents: () -> AnyView
    private let buttonTitle: String
    private let location: Location
    private let handler: () -> Void
    private let dismiss: () -> Void

    init(
        heading: String? = nil,
        description: String? = nil,
        extraContents: (() -> any View)? = nil,
        buttonTitle: String,
        location: Location = .bottom(offset: .zero),
        handler: @escaping () -> Void,
        dismiss: @escaping () -> Void
    ) {
        self.heading = heading
        self.description = description
        if let extraContents {
            self.extraContents = { AnyView(extraContents()) }
        } else {
            self.extraContents = { AnyView(EmptyView()) }
        }
        self.buttonTitle = buttonTitle
        self.location = location
        self.handler = handler
        self.dismiss = dismiss
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack {
            if case .bottom = location { Spacer() }

            ZStack {
                HStack(alignment: .center, spacing: .zero) {
                    extraContents()
                        .padding(.trailing, 8)
                    
                    ZStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: .zero) {
                            if let heading {
                                Text(heading)
                                    .paragraph(variant: .body2, weight: .bold, semantic: .staticWhite)
                            }
                            if let description {
                                Text(description)
                                    .paragraph(variant: .label2, weight: .regular, semantic: .staticWhite)
                                    .lineLimit(2)
                            }
                        }
                        .padding(.horizontal, 2)
                        .padding(.vertical, 5)
                    }
                    Spacer(minLength: 12)
                    
                    TextButton(color: .assistive, size: .medium, text: buttonTitle) {
                        handler()
                        dismiss()
                    }
                    .contentColor(.semantic(.staticWhite))
                    .fontVariant(.body2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 2)
                    .padding(.vertical, 4)
                    
                    if closeButton {
                        Spacer().frame(width: 12)
                        IconButton(variant: .normal(size: 20), icon: .close) {
                            dismiss()
                        }
                        .iconColor(.semantic(.staticWhite).opacity(0.61))
                        .padding(.horizontal, 2)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 11)
            .background(
                BackgroundView()
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 20)
            .padding(locationEdge, locationOffset)

            if case .top = location { Spacer() }
        }
    }
    
    // MARK: - Modifiers
    
    private var closeButton: Bool = false
    
    /// 닫기 버튼 노출 여부를 설정합니다.
    ///
    /// - Parameters:
    ///   - isEnabled: 닫기 버튼 노출 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 SnackBar 인스턴스
    public func closeButton(_ isEnabled: Bool = true) -> SnackBar {
        var zelf = self
        zelf.closeButton = isEnabled
        return zelf
    }

    // MARK: - Private
    
    private var locationEdge: Edge.Set {
        switch location {
        case .top: return .top
        case .bottom: return .bottom
        }
    }

    private var locationOffset: CGFloat {
        switch location {
        case .top(let offset), .bottom(let offset): return offset
        }
    }

    private struct BackgroundView: View {
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
            ZStack {
                SwiftUI.Color.semantic(.inverseBackground).opacity(
                    colorScheme == .light ? 0.5 : 0.46)
                SwiftUI.Color.semantic(.primaryNormal).opacity(0.05)
            }
            .background(
                .ultraThinMaterial
            )
        }
    }

    struct SnackBarModifier: ViewModifier, KeyboardReadable {
        @Binding var model: SnackBar.Model?
        @State private var animationWorkItem: DispatchWorkItem?

        let handler: () -> Void
        let location: Location
        let closeButtonEnabled: Bool

        /// SnackBarModifier를 초기화합니다.
        ///
        /// - Parameters:
        ///   - model: 표시할 스낵바 모델에 대한 바인딩. nil이면 스낵바가 표시되지 않습니다.
        ///   - location: 스낵바가 표시될 위치
        ///   - handler: 스낵바의 액션 버튼이 클릭될 때 실행할 핸들러
        ///   - closeButtonEnabled: 닫기 버튼 노출 여부
        init(
            model: Binding<SnackBar.Model?>,
            location: Location = .bottom(offset: .zero),
            closeButtonEnabled: Bool = false,
            handler: @escaping () -> Void
        ) {
            self._model = model
            self.location = location
            self.closeButtonEnabled = closeButtonEnabled
            self.handler = handler
        }
        
        @State private var isKeyboardVisible: Bool = false
        
        func body(content: Content) -> some View {
            GeometryReader { proxy in
                content
                    .frame(maxWidth: proxy.size.width, maxHeight: proxy.size.height)
                    .overlay(
                        snackBar()
                    )
                    .onChange(of: model) { newValue in
                        guard newValue != nil else { return }
                        showSnackBar()
                    }
                    .onReceive(keyboardPublisher) { isKeyboardVisible = $0 }
            }
        }

        @ViewBuilder
        private func snackBar() -> some View {
            if let model {
                SnackBar(
                    heading: model.heading,
                    description: model.description,
                    extraContents: model.extraContents,
                    buttonTitle: model.buttonTitle,
                    location: location,
                    handler: {
                        handler()
                        dismissSnackBar()
                    },
                    dismiss: {
                        dismissSnackBar()
                    }
                )
                .closeButton(closeButtonEnabled)
                .padding(.bottom, isKeyboardVisible ? 20 : 0)
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

// MARK: - View Extension

extension View {
    /// 현재 뷰에 SnackBar를 표시하는 modifier를 적용합니다.
    ///
    /// - Parameters:
    ///   - model: SnackBar 모델을 바인딩합니다. nil이 아닌 값이 설정되면 SnackBar가 표시됩니다.
    ///   - location: SnackBar가 표시될 위치, 생략하면 기본값으로 `.bottom(offset: .zero)` 적용
    ///   - closeButtonEnabled: 닫기 버튼 노출 여부
    ///   - handler: SnackBar의 액션 버튼이 클릭되었을 때 실행될 클로저
    /// - Returns: SnackBar가 적용된 뷰
    ///
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
    ///     .snackBar($snackBarModel, closeButtonEnabled: true) {
    ///         // 액션 버튼 클릭 시 실행될 코드
    ///     }
    /// }
    /// ```
    public func snackBar(
        _ model: Binding<SnackBar.Model?>,
        location: SnackBar.Location = .bottom(offset: .zero),
        closeButtonEnabled: Bool = false,
        handler: @escaping () -> Void
    ) -> some View {
        modifier(
            SnackBar.SnackBarModifier(
                model: model,
                location: location,
                closeButtonEnabled: closeButtonEnabled,
                handler: handler
            )
        )
    }
}
