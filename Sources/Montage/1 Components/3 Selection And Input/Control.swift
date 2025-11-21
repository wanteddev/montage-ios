//
//  Control.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/07.
//

import SwiftUI

struct Control: View {
    // MARK: - Types

    enum Variant {
        /// 체크박스 (3가지 상태: 선택, 미선택, 중간 상태)
        case checkbox
        /// 체크마크 (선택, 미선택 상태만 지원)
        case checkmark
        /// 라디오 버튼 (선택, 미선택 상태만 지원)
        case radio
        /// 스위치 (선택, 미선택 상태만 지원)
        case `switch`
    }

    enum Size {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }

    /// 컨트롤의 상태를 정의하는 열거형입니다.
    enum State {
        /// 선택되지 않은 상태
        case unchecked
        /// 선택된 상태
        case checked
        /// 중간 상태 (checkbox에서만 지원)
        case indeterminate

        internal var isUnchecked: Bool {
            self == .unchecked
        }
    }

    // MARK: - Initializer

    private let variant: Variant
    private let state: State
    private let size: Size
    private let onSelect: ((_ newValue: State) -> Void)?

    internal init(
        variant: Variant,
        state: State,
        size: Size = .medium,
        onSelect: ((_ newValue: State) -> Void)? = nil
    ) {
        self.variant = variant
        self.state = state
        self.size = size
        self.onSelect = onSelect
    }

    internal init(
        variant: Variant,
        checked: Bool,
        size: Size = .medium,
        onSelect: ((_ newValue: Bool) -> Void)? = nil
    ) {
        self.variant = variant
        self.state = checked ? .checked : .unchecked
        self.size = size
        self.onSelect = onSelect == nil ? nil : { onSelect?(!$0.isUnchecked) }
    }

    // MARK: - Body

    @SwiftUI.State private var isPressed = false
    private let switchSize: CGSize = .init(width: 51, height: 31)

    var body: some View {
        switch variant {
        case .switch:
            Toggle(
                "",
                isOn: Binding(
                    get: {
                        !state.isUnchecked
                    },
                    set: {
                        onSelect?($0 ? .checked : .unchecked)
                    })
            )
            .disabled(disable)
            .tint(backgroundColor)
            .frame(width: switchSize.width, height: switchSize.height)
            .offset(CGSize(width: -5, height: 0))
            .transformEffect(
                CGAffineTransform(
                    scaleX: boxSize.width / switchSize.width,
                    y: boxSize.height / switchSize.height
                )
            )
            .frame(width: boxSize.width, height: boxSize.height)
            .offset(
                CGSize(
                    width: (switchSize.width - boxSize.width) / 2,
                    height: (switchSize.height - boxSize.height) / 2
                ))
        default:
            HStack(alignment: .top, spacing: spacing) {
                Group {
                    if let icon {
                        Image.icon(icon)
                            .resizable()
                            .scaledToFill()
                            .foregroundStyle(iconColor)
                            .frame(width: iconSize.width, height: iconSize.height)
                    } else {
                        SwiftUI.Color.clear
                    }
                }
                .frame(width: boxSize.width, height: boxSize.height)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                }
                .frame(width: containerSize.width, height: containerSize.height)
                .background {
                    Interaction(
                        state: isPressed ? .pressed : .normal,
                        variant: .normal,
                        color: .labelNormal
                    )
                    .clipShape(Circle())
                    .frame(width: interactionSize.width, height: interactionSize.height)
                }
                .modifier(
                    PressActionDetectingModifier(
                        isPressed: $isPressed,
                        action: onSelect == nil
                            ? nil
                            : {
                                onSelect?(state.isUnchecked ? .checked : .unchecked)
                            }
                    )
                )
                .disabled(disable)

                if label.isNotEmpty {
                    Text(label)
                        .paragraph(
                            variant: labelTypography.variant,
                            weight: isBold ? .bold : labelTypography.weight,
                            color: labelTypography.color
                        )
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, size == .medium ? 1 : 0)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard disable == false else { return }
                            onSelect?(state.isUnchecked ? .checked : .unchecked)
                        }
                }
            }
        }
    }

    // MARK: - Modifiers

    private var label: String = ""
    private var labelVariant: Typography.Variant?
    private var labelWeight: Typography.Weight?
    private var labelColor: SwiftUI.Color?
    private var isBold = false
    private var tight = false
    private var disable = false

    /// 레이블 텍스트를 설정합니다.
    ///
    /// - Parameter text: 레이블에 표시할 텍스트
    /// - Returns: 수정된 입력 컴포넌트
    ///
    /// - Note: `.switch` 변형에서는 레이블이 표시되지 않습니다.
    func label(_ text: String) -> Self {
        var zelf = self
        zelf.label = text
        return zelf
    }

    /// 레이블의 타이포그래피 속성을 설정합니다.
    ///
    /// - Parameters:
    ///   - variant: 레이블 변형, 생략하면 기본값으로 `nil` 적용
    ///   - weight: 레이블 굵기, 생략하면 기본값으로 `nil` 적용
    ///   - color: 레이블 색상, 생략하면 기본값으로 `nil` 적용
    /// - Returns: 수정된 입력 컴포넌트
    ///
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    func labelTypography(
        _ variant: Typography.Variant? = nil,
        weight: Typography.Weight? = nil,
        color: SwiftUI.Color? = nil
    ) -> Self {
        var zelf = self
        zelf.labelVariant = variant
        zelf.labelWeight = weight
        zelf.labelColor = color
        return zelf
    }

    /// 레이블을 볼드체로 설정합니다.
    ///
    /// - Parameter isBold: 볼드 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 입력 컴포넌트
    ///
    /// - Note: 이 설정은 `labelTypography`에서 지정한 굵기보다 우선합니다.
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    func bold(_ isBold: Bool = true) -> Self {
        var zelf = self
        zelf.isBold = isBold
        return zelf
    }

    /// 컨트롤을 더 조밀한 레이아웃으로 표시합니다.
    ///
    /// 이 수정자를 적용하면 컨트롤의 가로 너비가 줄어듭니다.
    /// - medium: 24px → 20px
    /// - small: 20px → 16px
    ///
    /// - Parameter tight: 조밀한 레이아웃 적용 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 컨트롤 인스턴스
    ///
    /// - Note: 레이블이 지정되지 않은 경우 이 설정은 적용되지 않습니다.
    func tight(_ tight: Bool = true) -> Self {
        var zelf = self
        zelf.tight = tight
        return zelf
    }

    /// 컨트롤을 비활성화합니다.
    ///
    /// 비활성화된 컨트롤은 사용자 상호작용이 불가능하며, 시각적으로도 흐리게 표시됩니다.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 컨트롤 인스턴스
    func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
}

extension Control {
    fileprivate var icon: Icon? {
        switch variant {
        case .checkbox:
            switch state {
            case .checked: .checkThick
            case .indeterminate: .lineHorizontalThick
            case .unchecked: nil
            }
        case .checkmark: .checkThick
        case .radio: state.isUnchecked ? nil : .dot
        case .switch: nil
        }
    }

    fileprivate var iconColor: SwiftUI.Color {
        switch variant {
        case .checkmark:
            .semantic(state.isUnchecked ? .labelAssistive : .primaryNormal)
                .opacity(disable ? 0.43 : 1)
        case .checkbox, .radio:
            .semantic(.staticWhite)
        case .switch:
            .clear
        }
    }

    fileprivate var iconSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .medium: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        case .checkmark:
            switch size {
            case .medium: .init(width: 24, height: 24)
            case .small: .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .medium: .init(width: 16, height: 16)
            case .small: .init(width: 14, height: 14)
            }
        case .switch: .zero
        }
    }

    fileprivate var backgroundColor: SwiftUI.Color {
        switch variant {
        case .switch:
            if state.isUnchecked {
                disable ? .clear : .semantic(.fillStrong)
            } else {
                .semantic(.primaryNormal).opacity(disable ? 0.43 : 1)
            }
        case .checkmark:
            .clear
        case .checkbox, .radio:
            state.isUnchecked ? .clear : .semantic(.primaryNormal).opacity(disable ? 0.43 : 1)
        }
    }

    fileprivate var borderColor: SwiftUI.Color {
        switch variant {
        case .checkmark, .switch: .clear
        case .checkbox, .radio:
            .semantic(state.isUnchecked ? .lineNormal : .primaryNormal).opacity(disable ? 0.43 : 1)
        }
    }

    fileprivate var borderWidth: CGFloat {
        variant == .checkmark || !state.isUnchecked ? 0 : 1.5
    }

    fileprivate var containerSize: CGSize {
        switch size {
        case .medium:
            .init(width: tight ? 20 : 24, height: 24)
        case .small:
            .init(width: tight ? 16 : 20, height: 20)
        }
    }

    fileprivate var boxSize: CGSize {
        switch variant {
        case .checkbox:
            switch size {
            case .medium:
                .init(width: 18, height: 18)
            case .small:
                .init(width: 16, height: 16)
            }
        case .checkmark:
            switch size {
            case .medium:
                .init(width: 24, height: 24)
            case .small:
                .init(width: 20, height: 20)
            }
        case .radio:
            switch size {
            case .medium:
                .init(width: 20, height: 20)
            case .small:
                .init(width: 16, height: 16)
            }
        case .switch:
            switch size {
            case .medium:
                .init(width: 52, height: 32)
            case .small:
                .init(width: 39, height: 24)
            }
        }
    }

    fileprivate var cornerRadius: CGFloat {
        switch variant {
        case .checkbox:
            5
        case .checkmark:
            .zero
        case .radio:
            boxSize.width / 2
        case .switch:
            .zero
        }
    }

    fileprivate var interactionSize: CGSize {
        switch size {
        case .medium:
            .init(width: 32, height: 32)
        case .small:
            .init(width: 28, height: 28)
        }
    }

    fileprivate var labelTypography:
        (
            variant: Typography.Variant,
            weight: Typography.Weight,
            color: SwiftUI.Color
        )
    {
        (
            variant: labelVariant ?? (size == .small ? .label1 : .body2),
            weight: labelWeight ?? .regular,
            color: disable ? .semantic(.labelDisable) : labelColor ?? .semantic(.labelNormal)
        )
    }

    fileprivate var spacing: CGFloat {
        switch variant {
        case .checkbox, .radio:
            8 + (tight ? 2 : 0)
        case .checkmark:
            4 + (tight ? 2 : 0)
        case .switch:
            0
        }
    }
}
