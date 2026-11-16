//
//  FramedStyle.swift
//  Views
//
//  Created by 김삼열 on 8/22/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

public enum FramedStyle {
    /// 프레임의 상태를 정의하는 열거형입니다.
    ///
    /// 각 상태마다 다른 테두리 색상과 스타일이 적용됩니다.
    /// 선택 여부는 상태와 별개로 `framedStyle(status:selected:borderRadius:shadowLevel:)`의 `selected`로 지정합니다.
    public enum Status: CaseIterable {
        /// 기본 상태
        case normal
        /// 선택된 상태
        @available(*, deprecated, message: "framedStyle(status:selected:borderRadius:shadowLevel:)에 selected: true를 넘기세요.")
        case selected
        /// 부정적 상태 (오류, 경고 등)
        case negative

        /// deprecated `.selected`는 제외합니다.
        public static var allCases: [Status] { [.normal, .negative] }
    }

    // MARK: - ViewModifier

    struct Modifier: ViewModifier {
        @Environment(\.isEnabled) private var isEnabled

        private let isNegative: Bool
        private let selected: Bool
        private let borderRadius: CGFloat
        private let shadowLevel: Shadow.Level

        init(
            status: FramedStyle.Status = .normal,
            selected: Bool = false,
            borderRadius: CGFloat = 0,
            shadowLevel: Shadow.Level = .none
        ) {
            // deprecated `.selected`는 `.normal` + 선택으로 해석한다.
            switch status {
            case .normal:
                self.isNegative = false
                self.selected = selected
            case .negative:
                self.isNegative = true
                self.selected = selected
            default:
                self.isNegative = false
                self.selected = true
            }
            self.borderRadius = borderRadius
            self.shadowLevel = shadowLevel
        }

        func body(content: Content) -> some View {
            content
                .overlay { border }
                .clipShape(RoundedRectangle(cornerRadius: borderRadius))
                // 그림자를 배경 Shape의 fill에 analytic(`ShapeStyle.shadow`)으로 적용해 오프스크린
                // 패스를 피한다. 프레임 실루엣(둥근 사각형) 기준으로 그림자가 그려진다.
                .background(
                    RoundedRectangle(cornerRadius: borderRadius)
                        .fill(backgroundColor.shadow(shadowLevel))
                )
                .background { selectionRing }
        }

        /// 선택 시에는 흰 테두리 위에 반투명 링 색을 겹쳐 그려, 콘텐츠 색과 섞이지 않게 한다.
        @ViewBuilder
        private var border: some View {
            let shape = RoundedRectangle(cornerRadius: borderRadius)
            if selected {
                ZStack {
                    shape.strokeBorder(SwiftUI.Color.semantic(.surfaceNeutralPrimary), lineWidth: 1)
                    shape.strokeBorder(selectedBorderColor, lineWidth: 1)
                }
                .opacity(isEnabled ? 1 : .opacity43)
            } else {
                shape
                    .strokeBorder(borderColor, lineWidth: 1)
                    .opacity(isEnabled ? 1 : .opacity43)
            }
        }

        /// 선택 시 테두리 바깥에 표시되는 4px 링. 프레임 클리핑 밖에 그려야 하므로 clipShape 뒤 background에 둔다.
        @ViewBuilder
        private var selectionRing: some View {
            if selected {
                RoundedRectangle(cornerRadius: borderRadius + 4)
                    .strokeBorder(ringColor, lineWidth: 4)
                    .padding(-4)
                    .opacity(isEnabled ? 1 : .opacity43)
            }
        }

        private var borderColor: SwiftUI.Color {
            isNegative ? .semantic(.lineNegativePrimary) : .semantic(.lineNeutralSecondary)
        }

        private var selectedBorderColor: SwiftUI.Color {
            isNegative ? .semantic(.lineNegativeStrong) : .semantic(.lineBrandStrong)
        }

        private var ringColor: SwiftUI.Color {
            isNegative ? .semantic(.lineNegativeFocus) : .semantic(.lineBrandFocus)
        }

        private var backgroundColor: SwiftUI.Color {
            if !isEnabled {
                .semantic(.surfaceDisablePrimary)
            } else if isNegative, !selected {
                .semantic(.surfaceElevatedPrimary)
            } else {
                .semantic(.backgroundNeutralPrimary)
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// 현재 뷰에 프레임 스타일을 적용합니다.
    ///
    /// 테두리와 배경이 있는 프레임을 뷰에 적용하여 일관된 디자인을 제공합니다.
    /// 그림자는 기본으로 적용되지 않으며, `shadowLevel`을 지정했을 때만 표시됩니다.
    ///
    /// - Parameters:
    ///   - status: 프레임 상태, 생략하면 기본값으로 `.normal` 적용
    ///   - borderRadius: 테두리 반경, 생략하면 기본값으로 `0` 적용
    ///   - shadowLevel: 그림자 레벨, 생략하면 기본값으로 `.none` 적용
    /// - Returns: 프레임 스타일이 적용된 뷰
    ///
    /// - Note: 선택 상태는 `framedStyle(status:selected:borderRadius:shadowLevel:)`를 사용합니다.
    ///
    /// ```swift
    /// // 기본 사용법
    /// Text("입력 필드")
    ///     .framedStyle()
    ///
    /// // 부정적 상태의 프레임 (오류 표시)
    /// Text("오류 메시지")
    ///     .framedStyle(status: .negative)
    /// ```
    public func framedStyle(
        status: FramedStyle.Status = .normal,
        borderRadius: CGFloat = 0,
        shadowLevel: Shadow.Level = .none
    ) -> some View {
        modifier(
            FramedStyle.Modifier(
                status: status,
                borderRadius: borderRadius,
                shadowLevel: shadowLevel
            ))
    }

    /// 현재 뷰에 선택 여부를 지정해 프레임 스타일을 적용합니다.
    ///
    /// 선택되면 테두리 바깥에 4pt 링이 표시됩니다. 링 색은 `status`를 따르므로
    /// `.negative`와 함께 쓰면 오류 상태의 선택으로 표시됩니다.
    /// 그림자는 기본으로 적용되지 않으며, `shadowLevel`을 지정했을 때만 표시됩니다.
    ///
    /// - Parameters:
    ///   - status: 프레임 상태, 생략하면 기본값으로 `.normal` 적용
    ///   - selected: 선택 여부
    ///   - borderRadius: 테두리 반경, 생략하면 기본값으로 `0` 적용
    ///   - shadowLevel: 그림자 레벨, 생략하면 기본값으로 `.none` 적용
    /// - Returns: 프레임 스타일이 적용된 뷰
    ///
    /// - Note: 그림자에는 원본 View 배경색의 opacity가 동일하게 적용되므로, 원본 View의 opacity가 0.0인 경우 그림자가 표시되지 않습니다.
    ///
    /// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
    /// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
    ///
    /// ```swift
    /// // 선택된 프레임
    /// Text("선택된 항목")
    ///     .framedStyle(selected: true, borderRadius: 16)
    ///
    /// // 오류 상태에서 선택된 프레임
    /// Text("선택된 항목")
    ///     .framedStyle(status: .negative, selected: true, borderRadius: 16)
    ///
    /// // 프레임에 그림자 적용
    /// Text("카드")
    ///     .framedStyle(selected: isSelected, shadowLevel: .xsmall)
    ///
    /// // 비활성화된 프레임
    /// Text("비활성화된 항목")
    ///     .framedStyle(selected: true)
    ///     .disabled(true)
    /// ```
    public func framedStyle(
        status: FramedStyle.Status = .normal,
        selected: Bool,
        borderRadius: CGFloat = 0,
        shadowLevel: Shadow.Level = .none
    ) -> some View {
        modifier(
            FramedStyle.Modifier(
                status: status,
                selected: selected,
                borderRadius: borderRadius,
                shadowLevel: shadowLevel
            ))
    }
}
