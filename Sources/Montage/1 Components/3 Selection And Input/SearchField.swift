//
//  SearchField.swift
//  Montage
//
//  Created by Samuel Kim on 8/5/26.
//

import SwiftUI

/// 검색어 입력을 위한 컴포넌트입니다.
///
/// 왼쪽 검색 아이콘과 단일 라인 입력 영역으로 구성되며, 입력값이 있으면 오른쪽에 지우기 버튼이 나타납니다.
/// 치수·패딩·타이포그래피·모서리 반경은 ``TextField``와 동일한 사이즈 체계를 따릅니다.
///
/// ```swift
/// @State private var keyword = ""
///
/// // 기본 검색 필드 (Solid, Large)
/// SearchField(text: $keyword)
///    .placeholder("검색어를 입력해 주세요.")
///
/// // 테두리만 있는 검색 필드
/// SearchField(text: $keyword)
///    .variant(.outlined)
///    .size(.medium)
///
/// // 포커스 상태를 외부에서 제어하고 검색어 제출을 처리
/// SearchField(text: $keyword)
///    .focused($isFocused)
///    .onSubmit { search(keyword) }
///
/// // 자동수정·맞춤법 검사를 끈 검색 필드
/// SearchField(text: $keyword)
///    .autocorrectionDisabled()
///
/// // 비활성화
/// SearchField(text: $keyword)
///    .disabled(true)
/// ```
///
/// - Note: 비활성화는 SwiftUI 표준 `disabled(_:)`를 사용합니다.
/// 상위 컨테이너에 한 번 걸면 하위 컴포넌트까지 함께 비활성 스타일로 표시됩니다.
public struct SearchField: View {
    // MARK: - Types

    /// 검색 필드의 스타일을 정의합니다.
    public enum Variant {
        /// 채워진 배경을 사용하고 테두리가 없는 스타일
        case solid
        /// 투명한 배경 위에 테두리를 사용하는 스타일
        case outlined
    }

    /// 검색 필드의 사이즈를 정의합니다.
    ///
    /// 사이즈에 따라 패딩, 모서리 반경, 최소 높이, 입력 타이포그래피, 아이콘 크기가 함께 결정됩니다.
    public enum Size {
        /// 큰 사이즈 (최소 높이 48)
        case large
        /// 중간 사이즈 (최소 높이 40)
        case medium
    }

    // MARK: - Initializer

    @Binding private var text: String

    /// 검색 필드를 초기화합니다.
    ///
    /// - Parameter text: 검색어의 값을 바인딩
    /// - Returns: 구성된 검색 필드 인스턴스
    public init(text: Binding<String>) {
        _text = text
    }

    // MARK: - Modifiers

    private var variant: Variant = .solid
    private var size: Size = .large
    private var placeholder: String?
    private var externalFocused: Binding<Bool>?
    private var onSubmit: (() -> Void)?
    private var onTextChange: ((String) -> Void)?
    private var onFocusChange: ((Bool) -> Void)?
    private var autocorrectionDisabled = false
    private var materialDisabled = false

    /// 검색 필드의 스타일을 설정합니다.
    ///
    /// - Parameter variant: 검색 필드의 스타일
    /// - Returns: 수정된 검색 필드 인스턴스
    public func variant(_ variant: Variant) -> Self {
        var zelf = self
        zelf.variant = variant
        return zelf
    }

    /// 검색 필드의 사이즈를 설정합니다.
    ///
    /// - Parameter size: 검색 필드의 사이즈
    /// - Returns: 수정된 검색 필드 인스턴스
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }

    /// 검색어가 없을 때 표시할 플레이스홀더를 설정합니다.
    ///
    /// - Parameter placeholder: 표시할 플레이스홀더 텍스트
    /// - Returns: 수정된 검색 필드 인스턴스
    public func placeholder(_ placeholder: String?) -> Self {
        var zelf = self
        zelf.placeholder = placeholder
        return zelf
    }

    /// 검색 필드의 포커스 상태를 외부 바인딩과 연결합니다.
    ///
    /// 바인딩 값을 `true`로 바꾸면 키보드가 올라오고, 사용자가 직접 포커스를 옮기면 바인딩 값이 갱신됩니다.
    ///
    /// - Parameter focused: 포커스 상태 바인딩
    /// - Returns: 수정된 검색 필드 인스턴스
    public func focused(_ focused: Binding<Bool>) -> Self {
        var zelf = self
        zelf.externalFocused = focused
        return zelf
    }

    /// 검색어 제출 시 호출할 클로저를 설정합니다.
    ///
    /// 키보드의 검색(return) 키를 눌렀을 때 호출됩니다.
    ///
    /// - Parameter handler: 검색어 제출 시 실행할 클로저
    /// - Returns: 수정된 검색 필드 인스턴스
    public func onSubmit(_ handler: @escaping () -> Void) -> Self {
        var zelf = self
        zelf.onSubmit = handler
        return zelf
    }

    /// 검색어가 변경될 때마다 호출할 클로저를 설정합니다.
    ///
    /// - Parameter handler: 변경된 검색어를 전달받는 클로저
    /// - Returns: 수정된 검색 필드 인스턴스
    public func onTextChange(_ handler: @escaping (String) -> Void) -> Self {
        var zelf = self
        zelf.onTextChange = handler
        return zelf
    }

    /// 포커스 상태가 변경될 때 호출할 클로저를 설정합니다.
    ///
    /// - Parameter handler: 변경된 포커스 상태를 전달받는 클로저
    /// - Returns: 수정된 검색 필드 인스턴스
    public func onFocusChange(_ handler: @escaping (Bool) -> Void) -> Self {
        var zelf = self
        zelf.onFocusChange = handler
        return zelf
    }

    /// 자동수정과 맞춤법 검사를 비활성화할지 설정합니다.
    ///
    /// 사람 이름·회사명·약어처럼 사전에 없는 검색어를 자주 입력하는 화면에서 사용합니다.
    /// `true`이면 입력 중 자동수정이 적용되지 않고, 맞춤법 검사 밑줄도 표시되지 않습니다.
    ///
    /// 검색 필드가 내부에서 SwiftUI의 `autocorrectionDisabled(_:)`를 직접 적용하므로,
    /// 호출부에서 인스턴스 바깥에 같은 모디파이어를 붙이면 내부 설정에 덮어써집니다.
    /// 반드시 이 모디파이어로 설정해 주세요.
    ///
    /// - Parameter disable: 비활성화 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 검색 필드 인스턴스
    public func autocorrectionDisabled(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.autocorrectionDisabled = disable
        return zelf
    }

    /// 배경 머티리얼을 생략할지 설정합니다.
    ///
    /// ``TopNavigation``처럼 컨테이너가 이미 머티리얼 배경을 깔고 있는 자리에서는 검색 필드가
    /// 그 위에 머티리얼을 한 겹 더 쌓아 표면이 필요 이상으로 밝아집니다. 그런 경우 이 모디파이어로
    /// 머티리얼을 끄고 틴트만 남깁니다.
    ///
    /// 머티리얼 중첩은 컴포넌트를 조합하는 쪽에서만 판단할 수 있어 Montage 내부 전용으로 두고
    /// `public`으로 열지 않습니다. 호출부에서 검색 필드를 직접 배치할 때는 컨테이너 배경에 따라
    /// 이 값을 조정할 필요가 없습니다.
    ///
    /// - Parameter disable: 머티리얼을 생략할지 여부, 생략하면 기본값으로 `true` 적용
    /// - Returns: 수정된 검색 필드 인스턴스
    func disableMaterial(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.materialDisabled = disable
        return zelf
    }

    // MARK: - Body

    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var focusState: Bool
    @State private var internalFocused = false
    @State private var fixAutocorrection = false

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        searchBar
    }
}

// MARK: - Private

private extension SearchField {
    var isDisabled: Bool { isEnabled == false }

    var focused: Binding<Bool> {
        externalFocused ?? $internalFocused
    }

    var searchBar: some View {
        contentRow
            .frame(minHeight: size.contentMinHeight)
            .padding(.all, size.containerPadding)
            .frame(minHeight: size.minHeight)
            .background { fieldBackground }
            .overlay {
                if let strokeColor = fieldStrokeColor {
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .strokeBorder(strokeColor, lineWidth: 1)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .onTapGesture {
                focusState = true
            }
    }

    var contentRow: some View {
        HStack(spacing: .spacing2) {
            Image.icon(.search)
                .resizable()
                .frame(width: size.iconSize, height: size.iconSize)
                .foregroundStyle(iconColor)
                .padding(size.iconPadding)

            SwiftUI.TextField("", text: $text)
                // fixAutocorrection은 clear 버튼의 자동완성 잔상을 지우려고 한 프레임만 켜는 내부 트릭이므로,
                // 호출부 설정(autocorrectionDisabled)과 OR로 합성해 외부 설정을 덮어쓰지 않게 한다.
                .autocorrectionDisabled(autocorrectionDisabled || fixAutocorrection)
                .textInputAutocapitalization(.never)
                .submitLabel(.search)
                .onSubmit { onSubmit?() }
                .font(.font(variant: size.inputVariant, weight: .regular))
                .foregroundStyle(SwiftUI.Color.semantic(.foregroundNeutralPrimary))
                .focused($focusState)
                // placeholder를 prompt로 전달하면 폭이 부족할 때 시스템이 폰트를 자동 축소(shrink-to-fit)하므로,
                // 레이아웃에 참여하지 않는 overlay로 직접 그려 폰트 크기를 유지한 채 말줄임 처리한다.
                .overlay(alignment: .leading) { placeholderOverlay }
                .padding(.horizontal, .spacing4)
                // 실제 입력 텍스트가 보조 기술에 그대로 노출되도록 value는 덮어쓰지 않는다.
                // 필드의 용도는 placeholder로 라벨링한다.
                .accessibilityLabel(placeholder.map(Text.init) ?? Text("검색어", bundle: .module))
                .onChange(of: text) { newValue in
                    onTextChange?(newValue)
                }
                // 비활성 상태에서는 외부 바인딩이 포커스를 켜지 못하게 막는다.
                // (막지 않으면 비활성 필드에 키보드가 올라온다)
                .onChange(of: focused.wrappedValue) { newValue in
                    let target = isDisabled ? false : newValue
                    if focusState != target {
                        focusState = target
                    }
                }
                // 비활성화되면 열려 있던 포커스를 내리고, 다시 활성화되면 바인딩이 요청한 포커스를 반영한다.
                // (활성화 방향을 처리하지 않으면 focused == true인데 포커스가 없는 상태로 남는다)
                .onChange(of: isEnabled) { isEnabled in
                    let target = isEnabled ? focused.wrappedValue : false
                    if focusState != target {
                        focusState = target
                    }
                }
                .onChange(of: focusState) { newValue in
                    if focused.wrappedValue != newValue {
                        focused.wrappedValue = newValue
                    }
                    onFocusChange?(newValue)
                }

            clearButton
        }
        .padding(.horizontal, .spacing4)
    }

    @ViewBuilder
    var placeholderOverlay: some View {
        if text.isEmpty, let placeholder {
            Text(placeholder)
                .typography(
                    variant: size.inputVariant,
                    weight: .regular,
                    color: placeholderTextColor
                )
                .lineLimit(1)
                .allowsHitTesting(false)
                // 필드의 accessibilityLabel이 이미 placeholder를 노출하므로 중복 낭독을 막는다.
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    var clearButton: some View {
        if text.isNotEmpty, isDisabled == false {
            IconButton(
                variant: .normal(size: size.clearButtonSize),
                icon: .circleCloseFill
            ) {
                text = ""
                fixAutocorrection = true
                Task { fixAutocorrection = false }
            }
            .iconColor(.semantic(.foregroundNeutralQuaternary))
            .accessibilityLabel(Text("검색어 지우기", bundle: .module))
        }
    }

    @ViewBuilder
    var fieldBackground: some View {
        // 둥근 표면을 배경 Shape로 직접 그려 `clipShape`의 오프스크린 마스킹을 제거한다.
        let surface = RoundedRectangle(cornerRadius: size.cornerRadius)
        switch variant {
        case .solid:
            tintedSurface(
                surface,
                tint: [
                    .semantic(.backgroundNeutralPrimary).opacity(CGFloat.opacity61),
                    .semantic(.surfaceNeutralSecondary)
                ],
                flatTint: .semantic(.surfaceNeutralSecondary)
            )
        case .outlined:
            // outlined는 배경을 비워 뒤 콘텐츠가 비치도록 하고, 비활성일 때만 표면을 채운다.
            if isDisabled {
                surface
                    .fill(SwiftUI.Color.semantic(.surfaceNeutralTertiary))
            } else {
                tintedSurface(
                    surface,
                    tint: [.semantic(.backgroundNeutralPrimary).opacity(0.61)],
                    flatTint: .clear
                )
            }
        }
    }

    /// 머티리얼 위에 틴트를 얹은 표면. `disableMaterial(_:)`이 켜져 있으면 머티리얼을 빼고 `flatTint`만 그린다.
    ///
    /// 머티리얼이 있을 때와 없을 때 필요한 색이 다르다. 머티리얼은 스스로 표면을 배경보다 어둡게
    /// 만들어 경계를 잡아 주므로 그 위에는 투명 틴트(`effectTransparent*`)를 얹는다. 머티리얼을
    /// 빼면 그 경계가 사라지므로, 피그마 스펙에서 머티리얼(background blur) 효과만 제거한
    /// 채워진 색(`Fill/Normal` 계열)을 직접 써야 한다.
    ///
    /// - Parameters:
    ///   - shape: 표면 모양
    ///   - tint: 머티리얼 위에 얹을 틴트
    ///   - flatTint: 머티리얼을 뺐을 때 표면에 채울 색
    @ViewBuilder
    func tintedSurface<S: Shape>(
        _ shape: S,
        tint: [SwiftUI.Color],
        flatTint: SwiftUI.Color
    ) -> some View {
        if materialDisabled {
            shape.fill(flatTint)
        } else {
            MaterialBackground(in: shape, tint: tint)
        }
    }

    /// 테두리 색상. `nil`이면 테두리를 그리지 않는다.
    var fieldStrokeColor: SwiftUI.Color? {
        switch variant {
        case .solid:
            nil
        case .outlined:
            isDisabled ? .semantic(.lineNeutralTertiary) : .semantic(.lineNeutralSecondary)
        }
    }

    var iconColor: SwiftUI.Color {
        isDisabled ? .semantic(.foregroundDisablePrimary) : .semantic(.foregroundNeutralTertiary)
    }

    var placeholderTextColor: SwiftUI.Color {
        isDisabled ? .semantic(.foregroundDisablePrimary) : .semantic(.foregroundNeutralTertiary)
    }
}

// MARK: - Size Tokens

private extension SearchField.Size {
    /// Container 내부 패딩
    var containerPadding: CGFloat {
        switch self {
        case .large: .spacing8
        case .medium: .spacing6
        }
    }

    /// 모서리 반경
    var cornerRadius: CGFloat {
        switch self {
        case .large: .radius14
        case .medium: .radius12
        }
    }

    /// Container 최소 높이
    var minHeight: CGFloat {
        switch self {
        case .large: .dimension48
        case .medium: .dimension40
        }
    }

    /// Content 영역 최소 높이
    var contentMinHeight: CGFloat {
        switch self {
        case .large: .dimension24
        case .medium: .dimension20
        }
    }

    /// 지우기 버튼 크기
    var clearButtonSize: IconButton.NormalSize {
        switch self {
        case .large: .large
        case .medium: .medium
        }
    }

    /// 아이콘 크기
    var iconSize: CGFloat {
        switch self {
        case .large: .dimension20
        case .medium: .dimension18
        }
    }

    /// 아이콘 묶음 내부 패딩
    var iconPadding: CGFloat {
        switch self {
        case .large: .spacing2
        case .medium: .spacing1
        }
    }

    /// 입력 타이포그래피 변형
    var inputVariant: Typography.Variant {
        switch self {
        case .large: .body2
        case .medium: .label1
        }
    }
}
