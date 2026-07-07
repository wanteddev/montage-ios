//
//  FormControlGroup.swift
//  Montage
//
//  Created by 김삼열 on 7/7/26.
//

import SwiftUI

/// 여러 ``FormControl``을 세로로 쌓을 때, 라벨 열의 폭을 **가장 긴 라벨 기준으로 통일**해
/// 입력(input)의 시작 위치를 정렬하는 컨테이너입니다. (``FormControl/LabelPlacement/leading`` 대상)
///
/// 개별 FormControl에 폭을 지정할 필요 없이 이 컨테이너로 감싸기만 하면, 내부 leading 라벨들의
/// 본연 폭 중 최댓값으로 라벨 열이 맞춰집니다. Dynamic Type·다국어로 라벨 길이가 바뀌어도
/// 자동으로 재정렬되므로 호출부에 고정 폭(매직 넘버)을 두지 않아도 됩니다.
///
/// ```swift
/// FormControlGroup {
///     FormControl { context in
///         TextField(text: $name).status(context.status.textFieldStatus)
///     }
///     .labelPlacement(.leading)
///     .label("이름")
///
///     FormControl { context in
///         TextField(text: $email).status(context.status.textFieldStatus)
///     }
///     .labelPlacement(.leading)
///     .label("이메일 주소")
/// }
/// // → 두 입력의 leading이 정렬되고, 라벨 열은 "이메일 주소" 폭으로 통일된다.
/// ```
///
/// 자동 측정 대신 라벨 열 폭을 **고정**하고 싶으면 `labelWidth`를 지정합니다. 이 경우 측정을 건너뛰고
/// 모든 행이 그 폭을 씁니다. (여러 화면에서 동일한 폭을 맞추거나, 측정으로 인한 1프레임 흔들림을 피하고 싶을 때)
///
/// ```swift
/// FormControlGroup(labelWidth: .dimension64) { … }   // 전 행 라벨 폭을 64로 고정
/// ```
///
/// - Note: ``FormControl/LabelPlacement/top`` 배치 FormControl에는 영향을 주지 않습니다.
///   특정 행 하나만 다른 폭으로 두려면 그 FormControl에 ``FormControl/labelWidth(_:)``를 사용하세요
///   (per-control 값이 컨테이너 폭보다 우선합니다).
public struct FormControlGroup<Content: View>: View {
    private let fixedLabelWidth: CGFloat?
    private let spacing: CGFloat
    private let content: Content

    @State private var measuredLabelWidth: CGFloat?

    /// 컨테이너를 생성합니다.
    ///
    /// - Parameters:
    ///   - labelWidth: 라벨 열 폭을 고정할 값. 생략(`nil`)하면 내부 라벨 최댓값으로 **자동 측정**한다.
    ///   - spacing: FormControl 사이의 세로 간격. 생략하면 기본값으로 `.spacing16` 적용
    ///   - content: 세로로 쌓을 ``FormControl`` 목록
    public init(labelWidth: CGFloat? = nil, spacing: CGFloat = .spacing16, @ViewBuilder content: () -> Content) {
        self.fixedLabelWidth = labelWidth
        self.spacing = spacing
        self.content = content()
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            content
        }
        // 고정 폭이 없을 때만 내부 라벨들의 본연 폭 최댓값을 수집해 공유 폭으로 재주입한다(2-pass).
        .onPreferenceChange(FormLabelWidthKey.self) { width in
            guard fixedLabelWidth == nil else { return }
            measuredLabelWidth = width > 0 ? width : nil
        }
        .environment(\.formLabelColumnWidth, fixedLabelWidth ?? measuredLabelWidth)
    }
}
