//
//  ModalFull.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/28/24.
//

import SwiftUI

/// 화면 전체를 덮는 풀스크린 모달 컴포넌트입니다.
///
/// SwiftUI의 .fullScreenCover 수정자와 함께 사용하여 
/// 전체 화면을 덮는 모달을 구현합니다. 내비게이션 바와 액션 영역을
/// 설정할 수 있습니다.
///
/// ```swift
/// @State private var showFullModal = false
///
/// Button("전체 화면 모달 열기") {
///     showFullModal = true
/// }
/// .fullScreenCover(isPresented: $showFullModal) {
///     FullModal {
///         VStack(spacing: 20) {
///             Text("풀스크린 모달 내용")
///             Button("닫기") {
///                 showFullModal = false
///             }
///         }
///         .padding()
///     }
///     .modalNavigation {
///         ModalNavigation(title: "제목")
///             .leadingButton(.back {
///                 showFullModal = false
///             })
///     }
/// }
/// ```
///
/// 모디파이어를 사용하면 더 간편하게 구현할 수 있습니다:
/// ```swift
/// YourView()
///     .modifier(
///         FullModalModifier(
///             isPresented: $showFullModal
///         ) {
///             Text("풀스크린 모달 내용")
///         }
///     )
/// ```
///
/// - SeeAlso: `FullModalModifier`, `ModalNavigation`, `ActionArea.Model`
public struct FullModal: View {
    // MARK: - Initializer
    
    private var content: () -> any View
    
    /// 풀스크린 모달을 초기화합니다.
    ///
    /// - Parameter content: 모달 내에 표시할 콘텐츠를 반환하는 클로저
    public init(_ content: @escaping () -> any View) {
        self.content = content
    }
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    public var body: some View {
        BottomSheetModal(content)
            .needHandle(false)
            .resize(.fill)
            .ignoresEdgeInsets(ignoresEdgeInsets)
            .modalNavigation(navigation)
            .modalActionArea(actionAreaModel)
            .fullModal()
    }
    
    // MARK: - Modifiers
    
    private var ignoresEdgeInsets = false
    private var navigation: (() -> Montage.ModalNavigation)?
    private var actionAreaModel: ActionArea.Model?
    
    /// 컨텐츠의 기본 여백을 무시할지 설정합니다.
    ///
    /// - Parameter ignoresEdgeInsets: 여백 무시 여부
    /// - Returns: 수정된 풀스크린 모달 뷰
    public func ignoresEdgeInsets(_ ignoresEdgeInsets: Bool = true) -> Self {
        var zelf = self
        zelf.ignoresEdgeInsets = ignoresEdgeInsets
        return zelf
    }
    
    /// 풀스크린 모달 상단에 내비게이션 바를 설정합니다.
    ///
    /// - Parameter navigation: 내비게이션 바를 반환하는 클로저
    /// - Returns: 수정된 풀스크린 모달 뷰
    public func modalNavigation(_ navigation: (() -> Montage.ModalNavigation)?) -> Self {
        var zelf = self
        zelf.navigation = navigation
        return zelf
    }
    
    /// 풀스크린 모달 하단에 액션 영역을 설정합니다.
    ///
    /// - Parameter actionAreaModel: 액션 영역 모델
    /// - Returns: 수정된 풀스크린 모달 뷰
    public func modalActionArea(_ actionAreaModel: ActionArea.Model?) -> Self {
        var zelf = self
        zelf.actionAreaModel = actionAreaModel
        return zelf
    }
}

/// 풀스크린 모달을 표시하기 위한 뷰 모디파이어입니다.
///
/// 이 모디파이어를 사용하면 풀스크린 모달을 쉽게 표시하고 설정할 수 있습니다.
///
/// ```swift
/// @State private var showFullModal = false
///
/// Button("전체 화면 모달 열기") {
///     showFullModal = true
/// }
/// .modifier(
///     FullModalModifier(
///         isPresented: $showFullModal
///     ) {
///         Text("풀스크린 모달 내용")
///     }
/// )
/// ```
///
/// - SeeAlso: `FullModal`
struct FullModalModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let ignoresEdgeInsets: Bool
    private let fullContent: () -> any View
    private let navigation: (() -> ModalNavigation)?
    private let actionAreaModel: ActionArea.Model?
    
    /// 풀스크린 모달 모디파이어를 초기화합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 풀스크린 모달 표시 여부에 대한 바인딩
    ///   - ignoresEdgeInsets: 여백 무시 여부 (기본값: false)
    ///   - content: 모달에 표시할 콘텐츠를 반환하는 클로저
    ///   - navigation: 내비게이션 바를 반환하는 클로저 (선택 사항)
    ///   - actionAreaModel: 액션 영역 모델 (선택 사항)
    init(
        isPresented: Binding<Bool>,
        ignoresEdgeInsets: Bool = false,
        _ content: @escaping () -> any View,
        navigation: (() -> ModalNavigation)? = nil,
        actionAreaModel: ActionArea.Model? = nil
    ) {
        _isPresented = isPresented
        self.ignoresEdgeInsets = ignoresEdgeInsets
        fullContent = content
        self.navigation = navigation
        self.actionAreaModel = actionAreaModel
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                FullModal {
                    AnyView(fullContent())
                }
                .ignoresEdgeInsets(ignoresEdgeInsets)
                .modalNavigation(navigation)
                .modalActionArea(actionAreaModel)
            }
    }
}

// MARK: - View Extension

extension View {
    /// 전체 화면 모달을 표시합니다.
    ///
    /// 화면 전체를 덮는 모달을 표시합니다.
    ///
    /// - Parameters:
    ///   - isPresented: 모달 표시 여부를 제어하는 바인딩
    ///   - ignoresEdgeInsets: 모달 내용이 Edge 인셋을 무시할지 여부
    ///   - actionAreaModel: 모달 하단에 표시할 액션 영역 모델
    ///   - content: 모달에 표시할 콘텐츠 클로저
    ///   - navigation: 모달 상단에 표시할 네비게이션 클로저
    /// - Returns: 전체 화면 모달이 적용된 뷰
    public func fullModal(
        isPresented: Binding<Bool>,
        ignoresEdgeInsets: Bool = false,
        actionAreaModel: ActionArea.Model? = nil,
        _ content: @escaping () -> any View,
        navigation: (() -> ModalNavigation)? = nil
    ) -> some View {
        modifier(
            FullModalModifier(
                isPresented: isPresented,
                ignoresEdgeInsets: ignoresEdgeInsets,
                content,
                navigation: navigation,
                actionAreaModel: actionAreaModel
            )
        )
    }
}
