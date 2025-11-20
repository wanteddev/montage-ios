import SwiftUI

/// 스위치 컴포넌트입니다.
///
/// 스위치는 선택 상태를 표시하는 컴포넌트로, 체크박스와 유사한 기능을 제공합니다.
///
/// ```swift
/// Switch(checked: true) { checked in
///     print("스위치 선택 상태: \(checked)")
/// }
/// ```
public struct Switch: View {
    private let base: Control

    /// 스위치 크기 타입입니다.
    public enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }

    /// 스위치를 생성합니다.
    ///
    /// - Parameters:
    ///   - checked: 스위치의 초기 선택 상태
    ///   - size: 스위치 크기. 생략하면 기본값으로 `.small` 적용
    ///   - onSelect: 선택 상태 변경 콜백. 생략하면 기본값으로 `nil` 적용
    public init(
        checked: Bool,
        size: Size = .small,
        onSelect: ((Bool) -> Void)? = nil
    ) {
        let mappedSize: Control.Size = {
            switch size {
            case .small: .small
            case .medium: .medium
            }
        }()
        self.base = Control(
            variant: .switch, checked: checked, size: mappedSize, onSelect: onSelect)
    }

    private init(base: Control) {
        self.base = base
    }

    /// 컨트롤을 비활성화합니다.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 스위치 컴포넌트
    public func disable(_ disable: Bool = true) -> Self {
        .init(base: base.disable(disable))
    }

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        base
    }
}
