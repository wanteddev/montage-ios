//
//  FallbackView.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

/// 콘텐츠가 비어있거나 에러/접근 불가 등의 상황에서 대체(Fallback) 화면을 제공하는 컴포넌트입니다.
///
/// 데이터 없음, 검색 결과 없음(Empty) 뿐 아니라 404/네트워크 오류 등의 상태를 시각적으로 표현하고
/// 사용자에게 적절한 안내/복구 액션을 제공합니다. 제목, 설명, 버튼 요소를 조합하여
/// 다양한 상황에 맞는 대체(Fallback) 화면을 구성할 수 있습니다.
///
/// ```swift
/// // 기본 사용법
/// FallbackView(
///     description: "검색 결과가 없습니다."
/// )
///
/// // 모든 요소를 사용한 예시
/// FallbackView(
///     title: "데이터가 없습니다.",
///     description: "새로운 항목을 추가해 보세요.",
///     button: {
///         Button(variant: .outlined, color: .assistive, text: "추가하기") {
///             // 버튼 동작
///         }
///     }
/// )
/// ```
///
/// - Note: 버튼 영역은 `Assistive` 색상 버튼을 사용합니다.
/// 여러 액션이 필요하면 `HStack`·`VStack`으로 직접 배치해 전달합니다.
public struct FallbackView: View {
    private let title: String?
    private let description: String
    private let button: () -> AnyView

    /// FallbackView 컴포넌트를 초기화합니다.
    ///
    /// 원하는 레이아웃을 구성하기 위해 제목과 버튼을 선택적으로 제공할 수 있습니다.
    /// 설명은 필수이며, 최대 2줄로 표시됩니다.
    ///
    /// - Parameters:
    ///   - title: 강조되어 표시할 제목, 생략하면 기본값으로 `nil` 적용
    ///   - description: 상황을 설명하는 텍스트
    ///   - button: 하단에 표시할 버튼 뷰를 반환하는 클로저, 생략하면 기본값으로 `nil` 적용
    public init(
        title: String? = nil,
        description: String,
        button: (() -> any View)? = nil
    ) {
        self.title = title
        self.description = description
        self.button = button.map { view in { AnyView(view()) }} ?? { AnyView(EmptyView()) }
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Spacer()

            VStack(spacing: .spacing24) {
                VStack(spacing: .spacing12) {
                    if let title {
                        HStack {
                            Spacer()
                            Text(title)
                                .paragraph(variant: .headline1, weight: .bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text(description)
                            .paragraph(variant: .body2, semantic: .foregroundNeutralSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        Spacer()
                    }
                }

                button()
            }
            .padding(.vertical, .spacing12)

            Spacer()
        }
    }
}
