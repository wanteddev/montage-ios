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
/// // 버튼 1개를 사용한 예시
/// FallbackView(
///     title: "데이터가 없습니다.",
///     description: "새로운 항목을 추가해 보세요.",
///     buttonActionArea: .single(
///         .init(text: "추가하기", action: { addItem() })
///     )
/// )
///
/// // 버튼 2개를 가로로 배치한 예시
/// FallbackView(
///     title: "불러올 수 없어요.",
///     description: "네트워크 상태를 확인해 주세요.",
///     buttonActionArea: .horizontal(
///         main: .init(text: "다시 시도", action: { retry() }),
///         alternative: .init(text: "홈으로", action: { goHome() })
///     )
/// )
///
/// // 상하 여백을 좁게 적용한 예시
/// FallbackView(
///     description: "검색 결과가 없습니다.",
///     padding: .compact
/// )
/// ```
public struct FallbackView: View {

    // MARK: - Types

    /// 하단 버튼 영역의 버튼 구성과 배치를 정의합니다.
    ///
    /// 버튼은 항상 `Assistive` 색상의 외곽선(`outlined`) 스타일로 표시됩니다.
    public enum ButtonActionArea {
        /// 버튼 1개를 배치합니다.
        /// - Parameter buttonInfo: 버튼 정보
        case single(_ buttonInfo: ButtonInfo)
        /// 버튼 2개를 가로로 배치합니다. 대체 버튼이 왼쪽, 주 버튼이 오른쪽에 표시됩니다.
        /// - Parameters:
        ///   - main: 주 버튼 정보
        ///   - alternative: 대체 버튼 정보
        case horizontal(main: ButtonInfo, alternative: ButtonInfo)
        /// 버튼 2개를 세로로 배치합니다. 주 버튼이 위, 대체 버튼이 아래에 표시됩니다.
        /// - Parameters:
        ///   - main: 주 버튼 정보
        ///   - alternative: 대체 버튼 정보
        case vertical(main: ButtonInfo, alternative: ButtonInfo)

        /// 버튼에 표시할 텍스트와 탭 시 실행할 액션을 정의하는 구조체입니다.
        public struct ButtonInfo {
            internal let text: String
            internal let action: () -> Void

            /// 버튼 정보를 초기화합니다.
            ///
            /// - Parameters:
            ///   - text: 버튼에 표시할 텍스트
            ///   - action: 버튼 탭 시 실행할 액션
            /// - Returns: 구성된 ButtonInfo 인스턴스
            public init(text: String, action: @escaping () -> Void) {
                self.text = text
                self.action = action
            }
        }
    }

    /// 콘텐츠 영역의 상하 여백 크기를 정의합니다.
    public enum Padding {
        /// 기본 여백(160)을 적용합니다. 화면 전체를 대체할 때 사용합니다.
        case normal
        /// 좁은 여백(80)을 적용합니다. 화면 일부 영역만 대체할 때 사용합니다.
        case compact

        internal var verticalSpacing: CGFloat {
            switch self {
            case .normal: 160
            case .compact: 80
            }
        }
    }

    // MARK: - Initializers

    private let title: String?
    private let description: String
    private let buttonActionArea: ButtonActionArea?
    private let padding: Padding

    /// FallbackView 컴포넌트를 초기화합니다.
    ///
    /// 원하는 레이아웃을 구성하기 위해 제목과 버튼 영역을 선택적으로 제공할 수 있습니다.
    /// 설명은 필수이며, 제목과 설명 모두 최대 2줄로 표시되고 넘치는 텍스트는 말줄임 처리됩니다.
    ///
    /// 콘텐츠는 상위 뷰의 세로 중앙에 배치되며, `padding`으로 확보할 최소 상하 여백을 조절할 수 있습니다.
    ///
    /// - Parameters:
    ///   - title: 강조되어 표시할 제목, 생략하면 기본값으로 `nil` 적용
    ///   - description: 상황을 설명하는 텍스트
    ///   - buttonActionArea: 하단 버튼 영역의 구성, 생략하거나 `nil`을 전달하면 버튼을 표시하지 않음
    ///   - padding: 콘텐츠 영역의 상하 여백 크기, 생략하면 기본값으로 `.normal` 적용
    public init(
        title: String? = nil,
        description: String,
        buttonActionArea: ButtonActionArea? = nil,
        padding: Padding = .normal
    ) {
        self.title = title
        self.description = description
        self.buttonActionArea = buttonActionArea
        self.padding = padding
    }

    // MARK: - Body

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Spacer(minLength: padding.verticalSpacing)

            VStack(spacing: .spacing24) {
                VStack(spacing: .spacing12) {
                    if let title {
                        HStack {
                            Spacer()
                            Text(title)
                                .paragraph(variant: .headline1, weight: .bold)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
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

                if let buttonActionArea {
                    buttonArea(buttonActionArea)
                }
            }

            Spacer(minLength: padding.verticalSpacing)
        }
    }

    @ViewBuilder
    private func buttonArea(_ actionArea: ButtonActionArea) -> some View {
        switch actionArea {
        case let .single(buttonInfo):
            button(buttonInfo)
        case let .horizontal(main, alternative):
            HStack(spacing: .spacing10) {
                button(alternative)
                button(main)
            }
        case let .vertical(main, alternative):
            VStack(spacing: .spacing8) {
                button(main)
                button(alternative)
            }
        }
    }

    private func button(_ buttonInfo: ButtonActionArea.ButtonInfo) -> some View {
        Button(
            variant: .outlined,
            color: .assistive,
            size: .medium,
            text: buttonInfo.text,
            handler: buttonInfo.action
        )
    }
}
