import SwiftUI

/// 라디오 버튼 컴포넌트입니다.
///
/// - 선택 상태 변경 시 콜백을 받을 수 있으며, 크기와 스타일을 조정할 수 있습니다.
/// - 2가지 상태를 지원합니다: `checked`, `unchecked`
///
/// ```swift
/// Radio(checked: true) { checked in
///     print("라디오 버튼 선택 상태: \(checked)")
/// }
///
/// Radio(checked: false, size: .small) { checked in
///     print("라디오 버튼 선택 상태: \(checked)")
/// }
/// ```
public struct Radio: View {
    private let base: Control

    /// 라디오 버튼 크기 타입입니다.
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }

    /// 라디오 버튼을 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 라디오 버튼의 초기 선택 상태
    ///   - size: 라디오 버튼 크기. 생략하면 기본값으로 `.medium` 적용
    ///   - onSelect: 선택 상태 변경 콜백. 생략하면 기본값으로 `nil` 적용
    public init(
        checked: Bool,
        size: Size = .medium,
        onSelect: ((Bool) -> Void)? = nil
    ) {
        let mappedSize: Control.Size = {
            switch size {
            case .small: .small
            case .medium: .medium
            }
        }()
        self.base = Control(variant: .radio, checked: checked, size: mappedSize, onSelect: onSelect)
    }

    private init(base: Control) {
        self.base = base
    }

    /// 레이블 텍스트를 설정합니다.
    ///
    /// - Parameter text: 레이블에 표시할 텍스트
    /// - Returns: 수정된 라디오 버튼 컴포넌트
    public func label(_ text: String) -> Self {
        .init(base: base.label(text))
    }

    /// 레이블의 타이포그래피 속성을 설정합니다.
    ///
    /// - Parameters:
    ///   - variant: 레이블 변형, 생략하면 기본값으로 `nil` 적용
    ///   - weight: 레이블 굵기, 생략하면 기본값으로 `nil` 적용
    ///   - color: 레이블 색상, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 수정된 라디오 버튼 컴포넌트
    ///
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    public func labelTypography(
        _ variant: Typography.Variant? = nil,
        weight: Typography.Weight? = nil,
        color: SwiftUI.Color? = nil
    ) -> Self {
        .init(base: base.labelTypography(variant, weight: weight, color: color))
    }

    /// 레이블을 볼드체로 설정합니다.
    ///
    /// - Parameter isBold: 볼드 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 라디오 버튼 컴포넌트
    ///
    /// - Note: 이 설정은 `labelTypography`에서 지정한 굵기보다 우선합니다.
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    public func bold(_ isBold: Bool = true) -> Self {
        .init(base: base.bold(isBold))
    }

    /// 레이블을 더 조밀한 레이아웃으로 표시합니다.
    ///
    /// - Parameter tight: 조밀한 레이아웃 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 라디오 버튼 컴포넌트
    ///
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    public func tight(_ tight: Bool = true) -> Self {
        .init(base: base.tight(tight))
    }

    /// 컨트롤을 비활성화합니다.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 라디오 버튼 컴포넌트
    public func disable(_ disable: Bool = true) -> Self {
        .init(base: base.disable(disable))
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        base
    }
}
