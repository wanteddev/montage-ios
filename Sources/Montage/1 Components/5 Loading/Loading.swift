//
//  Loading.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/29/24.
//

import SwiftUI

import Lottie

/// 로딩 상태를 표시하기 위한 애니메이션 컴포넌트입니다.
///
/// `Loading`은 다양한 종류와 크기의 로딩 애니메이션을 제공합니다. 
/// Lottie 애니메이션을 사용하여 시각적으로 매력적인 로딩 인디케이터를 표시하며,
/// 색상 및 크기를 커스터마이징할 수 있습니다.
///
/// ```swift
/// // 기본 원형 로딩 애니메이션 사용
/// Loading(kind: .circular)
///
/// // 특정 크기와 색상의 Wanted 로딩 애니메이션 사용
/// Loading(kind: .wanted, size: CGSize(width: 100, height: 100))
///     .foregroundColor(.blue)
///
/// // 로딩 오버레이로 적용
/// someView
///     .loading($isLoadingState, type: .circular(.blue))
/// ```
public struct Loading: View {
    
    // MARK: - Type
    
    /// 로딩 애니메이션의 종류를 정의하는 열거형입니다.
    ///
    /// 애플리케이션의 디자인 요구사항이나 컨텍스트에 따라 적절한 로딩 스타일을 선택할 수 있습니다.
    ///
    /// ```swift
    /// // Wanted 스타일 로딩 사용
    /// Loading(kind: .wanted)
    ///
    /// // 원형 로딩 사용
    /// Loading(kind: .circular())
    /// ```
    public enum Kind {
        /// Wanted 브랜드 스타일의 로딩 애니메이션
        case wanted
        /// 원형 회전 로딩 애니메이션
        /// - Parameters:
        ///   - color: 애니메이션의 색상을 지정합니다. 생략하면 기본값으로 `nil` 적용 (기본 색상 사용)
        case circular(color: SwiftUI.Color? = nil)
        
        func resourceName(_ colorScheme: ColorScheme) -> String {
            switch self {
            case .wanted: colorScheme == .light ? "loading-wanted-light.json" : "loading-wanted-dark.json"
            case .circular: colorScheme == .light ? "loading-circular-light.json" : "loading-circular-dark.json"
            }
        }
    }

    // MARK: - Initializer
    
    private let kind: Kind
    private let size: CGSize?

    /// Loading 컴포넌트를 초기화합니다.
    ///
    /// - Parameters:
    ///   - kind: 로딩 애니메이션의 종류 (.wanted 또는 .circular)
    ///   - size: 로딩 애니메이션의 크기 생략하면 기본값으로 `nil` 적용 (기본 크기 사용)
    public init(kind: Kind, size: CGSize? = nil) {
        self.kind = kind
        self.size = size
    }
    
    // MARK: - Body
    
    @Environment(\.colorScheme) private var colorScheme
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        LottieView(animation: .named(kind.resourceName(colorScheme), bundle: .module))
            .playing(loopMode: .loop)
            .if(size != nil) {
                $0.resizable()
                    .frame(width: size?.width, height: size?.height)
            }
            .modifying {
                if case .circular(let color) = kind, let color {
                    $0.colorMultiply(color)
                } else {
                    $0
                }
            }
    }
    
    struct LoadingViewModifier: ViewModifier {
        @Binding var isLoading: Bool
        let type: Loading.Kind
        let dimmedColor: SwiftUI.Color
        
        init(_ isLoading: Binding<Bool>, type: Loading.Kind, dimmedColor: SwiftUI.Color) {
            _isLoading = isLoading
            self.type = type
            self.dimmedColor = dimmedColor
        }
        
        @State var opacity: CGFloat = 0

        func body(content: Content) -> some View {
            ZStack {
                content
                    .userInteractionDisabled(isLoading)
                dimmedColor
                    .opacity(opacity)
                    .ignoresSafeArea()
                Loading(kind: type)
                    .if(isLoading)
            }
            .onChange(of: isLoading, perform: { newValue in
                opacity = newValue ? 0 : 1
                withAnimation {
                    opacity = newValue ? 1 : 0
                }
            })
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 로딩 인디케이터와 함께 로딩 오버레이를 적용합니다.
    ///
    /// 로딩 상태일 때 뷰 위에 반투명 배경과 로딩 애니메이션을 표시합니다.
    /// 로딩 중에는 사용자 상호작용이 비활성화됩니다.
    ///
    /// - Parameters:
    ///   - isLoading: 로딩 상태를 제어하는 바인딩 불리언 값
    ///   - type: 로딩 애니메이션 종류 (.wanted 또는 .circular)
    ///   - dimmedColor: 오버레이 배경색, 생략하면 기본값으로 `.clear` 적용
    /// - Returns: 로딩 기능이 적용된 뷰
    ///
    /// ```swift
    /// @State private var isLoading = false
    ///
    /// contentView
    ///     .loading($isLoading, type: .wanted)
    ///     .onAppear {
    ///         // 로딩 상태 시작
    ///         isLoading = true
    ///     }
    /// ```
    public func loading(
        _ isLoading: Binding<Bool>,
        type: Loading.Kind,
        dimmedColor: SwiftUI.Color = .clear
    ) -> some View {
        modifier(Loading.LoadingViewModifier(isLoading, type: type, dimmedColor: dimmedColor))
    }
}
