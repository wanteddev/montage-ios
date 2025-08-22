//
//  Button.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/10.
//

import SwiftUI

/// 사용자가 상호작용할 수 있는 버튼 컴포넌트입니다.
///
/// 세 가지 스타일로 제공됩니다:
/// - `solid`: 색상이 채워진 버튼
/// - `outlined`: 테두리만 있는 버튼
/// - `text`: 텍스트만 있는 버튼
///
/// ```swift
/// // 기본 솔리드 버튼
/// Button.solid(text: "확인", handler: { print("버튼 클릭") })
///
/// // 아웃라인 버튼
/// Button.outlined(variant: .primary, size: .medium, text: "취소")
///
/// // 텍스트 버튼
/// Button.text(text: "더보기", trailingIcon: .chevronRight)
///
/// // 아이콘 버튼
/// Button.solid(icon: .bell, handler: { print("알림 보기") })
///
/// // 로딩 상태 설정
/// Button.solid(text: "저장")
///     .loading(true)
/// ```
///
/// - Note: 버튼은 다양한 수정자(modifier)를 사용하여 모양과 동작을 커스터마이즈할 수 있습니다.
public struct Button: View {
    
    // MARK: - Types
    
    /// Solid 스타일 버튼과 관련된 타입을 정의합니다.
    public enum Solid {
        /// Solid 스타일 버튼의 변형을 정의합니다.
        public enum Variant: String {
            /// 기본 강조 스타일 - 브랜드 컬러를 사용하는 가장 강조된 버튼
            case primary
            /// 보조 스타일 - 중요도가 낮은 보조 액션에 사용
            case assistive
        }
        
        /// Solid 스타일 버튼의 크기를 정의합니다.
        public enum Size: String {
            /// 작은 크기
            case small
            /// 중간 크기
            case medium
            /// 큰 크기
            case large
        }
    }

    /// Outlined 스타일 버튼과 관련된 타입을 정의합니다.
    public enum Outlined {
        /// Outlined 스타일 버튼의 변형을 정의합니다.
        public enum Variant: String {
            /// 기본 강조 스타일 - 브랜드 컬러의 테두리를 사용
            case primary
            /// 보조 강조 스타일 - 브랜드 컬러보다 덜 강조된 스타일
            case secondary
            /// 보조 스타일 - 중요도가 낮은 보조 액션에 사용
            case assistive
        }
        
        /// Outlined 스타일 버튼의 크기를 정의합니다.
        public enum Size: String {
            /// 작은 크기
            case small
            /// 중간 크기
            case medium
            /// 큰 크기
            case large
        }
    }

    /// Text 스타일 버튼과 관련된 타입을 정의합니다.
    public enum Text {
        /// Text 스타일 버튼의 변형을 정의합니다.
        public enum Variant: String {
            /// 기본 강조 스타일 - 브랜드 컬러를 텍스트에 사용
            case primary
            /// 보조 스타일 - 중요도가 낮은 텍스트 링크에 사용
            case assistive
        }
        
        /// Text 스타일 버튼의 크기를 정의합니다.
        public enum Size: String {
            /// 작은 크기
            case small
            /// 중간 크기
            case medium
        }
    }
    
    internal enum Style {
        case solid, outlined, text
    }
    
    /// 버튼의 변형을 정의합니다.
    public enum Variant: String {
        /// 기본 강조 스타일 - 주요 액션에 사용
        case primary
        /// 보조 강조 스타일 - 보조 액션에 사용
        case secondary
        /// 보조 스타일 - 덜 중요한 액션에 사용
        case assistive
    }
    
    /// 버튼의 크기를 정의합니다.
    public enum Size: String {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
        /// 큰 크기
        case large
    }
    
    // MARK: - Initializers
    
    private let style: Style
    private let variant: Variant
    private let size: Size
    private let text: String?
    private let leadingIcon: Icon?
    private let trailingIcon: Icon?
    private let handler: (() -> Void)?
    
    internal init(
        style: Style,
        variant: Variant = .primary,
        size: Size = .medium,
        text: String? = nil,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) {
        self.style = style
        self.variant = variant
        self.size = size
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.text = text
        self.handler = handler
    }
    
    /// Solid 스타일의 텍스트 버튼을 생성합니다.
    ///
    /// 배경색이 채워진 스타일의 버튼으로, 주요 액션이나 강조가 필요한 액션에 적합합니다.
    ///
    /// ```swift
    /// Button.solid(text: "로그인", handler: { loginUser() })
    /// Button.solid(variant: .assistive, size: .small, text: "확인")
    /// ```
    ///
    /// - Parameters:
    ///   - variant: 버튼의 변형, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.large`
    ///   - text: 버튼에 표시할 텍스트
    ///   - leadingIcon: 텍스트 앞에 표시할 아이콘
    ///   - trailingIcon: 텍스트 뒤에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public static func solid(
        variant: Solid.Variant = .primary,
        size: Solid.Size = .large,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .solid,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    /// Solid 스타일의 아이콘 버튼을 생성합니다.
    ///
    /// 배경색이 채워진 스타일의 아이콘 버튼으로, 공간이 제한적이거나 아이콘으로 충분히 의미가 전달될 때 사용합니다.
    ///
    /// ```swift
    /// Button.solid(icon: .plus, handler: { addItem() })
    /// Button.solid(variant: .assistive, size: .small, icon: .search)
    /// ```
    ///
    /// - Parameters:
    ///   - variant: 버튼의 변형, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.large`
    ///   - icon: 버튼에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public static func solid(
        variant: Solid.Variant = .primary,
        size: Solid.Size = .large,
        icon: Icon,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .solid,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            leadingIcon: icon,
            handler: handler
        )
    }
    
    /// Outlined 스타일의 텍스트 버튼을 생성합니다.
    ///
    /// 테두리만 있는 스타일의 버튼으로, 보조 액션이나 덜 강조된 액션에 적합합니다.
    ///
    /// ```swift
    /// Button.outlined(text: "취소", handler: { dismiss() })
    /// Button.outlined(variant: .secondary, size: .medium, text: "뒤로")
    /// ```
    ///
    /// - Parameters:
    ///   - variant: 버튼의 변형, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.large`
    ///   - text: 버튼에 표시할 텍스트
    ///   - leadingIcon: 텍스트 앞에 표시할 아이콘
    ///   - trailingIcon: 텍스트 뒤에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public static func outlined(
        variant: Outlined.Variant = .primary,
        size: Outlined.Size = .large,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .outlined,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    /// Outlined 스타일의 아이콘 버튼을 생성합니다.
    ///
    /// 테두리만 있는 스타일의 아이콘 버튼으로, 공간이 제한적이거나 보조적인 아이콘 액션에 적합합니다.
    ///
    /// ```swift
    /// Button.outlined(icon: .share, handler: { shareContent() })
    /// Button.outlined(variant: .assistive, size: .small, icon: .bookmark)
    /// ```
    ///
    /// - Parameters:
    ///   - variant: 버튼의 변형, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.large`
    ///   - icon: 버튼에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public static func outlined(
        variant: Outlined.Variant = .primary,
        size: Outlined.Size = .large,
        icon: Icon,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .outlined,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .large,
            leadingIcon: icon,
            handler: handler
        )
    }
    
    /// Text 스타일의 버튼을 생성합니다.
    ///
    /// 텍스트만 있는 스타일의 버튼으로, 가벼운 액션이나 링크 형태의 액션에 적합합니다.
    ///
    /// ```swift
    /// Button.text(text: "더 보기", handler: { showMore() })
    /// Button.text(variant: .assistive, text: "상세보기", trailingIcon: .chevronRight)
    /// ```
    ///
    /// - Parameters:
    ///   - variant: 버튼의 변형, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.medium`
    ///   - text: 버튼에 표시할 텍스트
    ///   - leadingIcon: 텍스트 앞에 표시할 아이콘
    ///   - trailingIcon: 텍스트 뒤에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public static func text(
        variant: Text.Variant = .primary,
        size: Text.Size = .medium,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) -> Self {
        .init(
            style: .text,
            variant: .init(rawValue: variant.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .medium,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
    }
    
    // MARK: - Modifiers
    
    private var disable: Bool = false
    private var contentColor: SwiftUI.Color? = nil
    private var customBackgroundColor: SwiftUI.Color? = nil
    private var customBorderColor: SwiftUI.Color? = nil
    private var fontVariant: Typography.Variant? = nil
    private var fontWeight: Typography.Weight? = nil
    private var loading = false
    private var fillHorizontal = false
    private var fillVertical = false
    
    /// 버튼을 비활성화 상태로 설정합니다.
    ///
    /// 비활성화된 버튼은 시각적으로 흐리게 표시되며 사용자 상호작용에 반응하지 않습니다.
    ///
    /// ```swift
    /// Button.solid(text: "저장")
    ///     .disable(isFormInvalid)
    /// ```
    ///
    /// - Parameter disable: 비활성화 여부, 기본값은 `true`
    /// - Returns: 수정된 버튼 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 버튼 콘텐츠(텍스트와 아이콘)의 색상을 설정합니다.
    ///
    /// ```swift
    /// Button.outlined(text: "복사")
    ///     .contentColor(.red)
    /// ```
    ///
    /// - Parameter contentColor: 설정할 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func contentColor(_ contentColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.contentColor = contentColor
        return zelf
    }
    
    /// 버튼 배경색을 설정합니다.
    ///
    /// Solid 스타일 버튼에 가장 효과적으로 적용됩니다.
    ///
    /// ```swift
    /// Button.solid(text: "특별 액션")
    ///     .backgroundColor(.blue)
    /// ```
    ///
    /// - Parameter backgroundColor: 설정할 배경색
    /// - Returns: 수정된 버튼 인스턴스
    public func backgroundColor(_ backgroundColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBackgroundColor = backgroundColor
        return zelf
    }
    
    /// 버튼 테두리 색상을 설정합니다.
    ///
    /// Outlined 스타일 버튼에 가장 효과적으로 적용됩니다.
    ///
    /// ```swift
    /// Button.outlined(text: "경고")
    ///     .borderColor(.red)
    /// ```
    ///
    /// - Parameter borderColor: 설정할 테두리 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func borderColor(_ borderColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.customBorderColor = borderColor
        return zelf
    }
    
    /// 버튼 텍스트의 폰트 변형을 설정합니다.
    ///
    /// 텍스트의 크기와 스타일을 변경할 때 사용합니다.
    ///
    /// ```swift
    /// Button.text(text: "중요 안내")
    ///     .fontVariant(.heading)
    /// ```
    ///
    /// - Parameter fontVariant: 설정할 폰트 변형
    /// - Returns: 수정된 버튼 인스턴스
    public func fontVariant(_ fontVariant: Typography.Variant?) -> Self {
        var zelf = self
        zelf.fontVariant = fontVariant
        return zelf
    }
    
    /// 버튼 텍스트의 폰트 두께를 설정합니다.
    ///
    /// 텍스트의 강조를 조절할 때 사용합니다.
    ///
    /// ```swift
    /// Button.text(text: "중요 공지")
    ///     .fontWeight(.bold)
    /// ```
    ///
    /// - Parameter fontWeight: 설정할 폰트 두께
    /// - Returns: 수정된 버튼 인스턴스
    public func fontWeight(_ fontWeight: Typography.Weight?) -> Self {
        var zelf = self
        zelf.fontWeight = fontWeight
        return zelf
    }
    
    /// 버튼을 로딩 상태로 설정합니다.
    ///
    /// 로딩 상태인 버튼은 내부 콘텐츠 대신 로딩 인디케이터를 표시하며 사용자 상호작용에 반응하지 않습니다.
    /// 비동기 작업이 진행 중일 때 사용자에게 피드백을 제공하는 데 유용합니다.
    ///
    /// ```swift
    /// Button.solid(text: "저장")
    ///     .loading(isLoading)
    /// ```
    ///
    /// - Parameter loading: 로딩 상태 여부, 기본값은 `true`
    /// - Returns: 수정된 버튼 인스턴스
    public func loading(_ loading: Bool = true) -> Self {
        var zelf = self
        zelf.loading = loading
        return zelf
    }
    
    /// 버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.
    ///
    /// 버튼의 크기를 조절하여 컨테이너 뷰의 공간을 효율적으로 활용할 때 사용합니다.
    ///
    /// ```swift
    /// // 부모 뷰의 가로 너비를 모두 채우는 버튼
    /// Button.solid(text: "전체 확인")
    ///     .fill(horizontal: true)
    ///
    /// // 가로, 세로 모두 채우는 버튼
    /// Button.outlined(text: "영역 전체 채우기")
    ///     .fill(horizontal: true, vertical: true)
    /// ```
    ///
    /// - Parameters:
    ///   - fillHorizontal: 수평 방향 채우기 여부, 기본값은 `false`
    ///   - fillVertical: 수직 방향 채우기 여부, 기본값은 `false`
    /// - Returns: 수정된 버튼 인스턴스
    public func fill(horizontal fillHorizontal: Bool = false, vertical fillVertical: Bool = false) -> Self {
        var zelf = self
        zelf.fillHorizontal = fillHorizontal
        zelf.fillVertical = fillVertical
        return zelf
    }
    
    // MARK: - Body
    
    @State private var isPressed = false
    
    public var body: some View {
        ZStack {
            SwiftUI.Color.clear
            
            HStack(alignment: .center, spacing: 4) {
                if let leadingIcon {
                    icon(leadingIcon)
                }
                if let text {
                    SwiftUI.Text(text)
                        .typographyNew(
                            variant: fontVariant ?? typoVariant,
                            weight: fontWeight ?? typoWeight,
                            color: foregroundColor
                        )
                }
                if let trailingIcon {
                    icon(trailingIcon)
                }
            }
            .opacity(loading ? 0 : 1)
            
            if loading {
                Loading(kind: .circular, size: loadingSize)
                    .foregroundColor(loadingColor)
            }
        }
        .fixedSize(horizontal: !fillHorizontal, vertical: !fillVertical)
        .contentShape(Rectangle())
        .frame(height: contentHeight)
        .padding(edgeInsets)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(borderColor)
        }
        .overlay {
            Interaction(
                state: isPressed ? .pressed : .normal,
                variant: interactionVariant,
                color: interactionColor
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .padding(.vertical, -interactionVerticalOffset)
            .padding(.horizontal, -interactionHorizontalOffset)
        }
        .modifier(PressActionDetectingModifier(isPressed: $isPressed, action: handler))
        .allowsHitTesting(!disable && !loading)
    }
}

private extension Button {
    var backgroundColor: SwiftUI.Color {
        switch style {
        case .solid:
            if disable {
                .semantic(.interactionDisable)
            } else {
                if let customBackgroundColor {
                    customBackgroundColor
                } else {
                    switch variant {
                    case .primary: .semantic(.primaryNormal)
                    case .assistive: .semantic(.fillNormal)
                    default: .clear
                    }
                }
            }
        case .outlined:
            if !disable, let customBackgroundColor {
                customBackgroundColor
            } else {
                .clear
            }
        case .text: .clear
        }
    }
    
    var borderColor: SwiftUI.Color {
        if style == .outlined {
            if disable {
                .semantic(.lineNormal)
            } else {
                if let customBorderColor {
                    customBorderColor
                } else {
                    switch variant {
                    case .primary:
                        .semantic(.primaryNormal)
                    case .secondary, .assistive:
                        .semantic(.lineNeutral)
                    }
                }
            }
        } else {
            .clear
        }
    }
    
    var foregroundColor: SwiftUI.Color {
        switch style {
        case .solid:
            if disable {
                .semantic(.labelAssistive)
            } else if let contentColor {
                contentColor
            } else {
                switch variant {
                case .primary: .semantic(.staticWhite)
                case .assistive: .semantic(.labelNeutral)
                default: .clear
                }
            }
        case .outlined, .text:
            if disable {
                .semantic(.labelDisable)
            } else if let contentColor {
                contentColor
            } else {
                switch variant {
                case .primary, .secondary: .semantic(.primaryNormal)
                case .assistive: .semantic(style == .outlined ? .labelNormal : .labelAlternative)
                }
            }
        }
    }
    
    var loadingColor: SwiftUI.Color? {
        if let contentColor {
            contentColor
        } else {
            switch style {
            case .solid:
                switch variant {
                case .primary, .secondary: .semantic(.staticWhite)
                case .assistive: .semantic(.labelAssistive)
                }
            default:
                switch variant {
                case .primary, .secondary: .semantic(.primaryNormal)
                case .assistive: .semantic(.labelAssistive)
                }
            }
        }
    }

    func icon(_ i: Icon) -> some View {
        Image.icon(i)
            .resizable()
            .frame(
                width: iconSize.width,
                height: iconSize.height
            )
            .foregroundStyle(foregroundColor)
    }
    
    var iconSize: CGSize {
        switch size {
        case .small:
            .init(width: 16, height: 16)
        case .medium:
                .init(width: style == .text ? 20 : 18, height: style == .text ? 20 : 18)
        case .large:
            .init(width: 20, height: 20)
        }
    }
    
    var typoVariant: Typography.Variant {
        switch size {
        case .small:
            style == .text ? .label1 : .label2
        case .medium:
            style == .text ? .body1 : .body2
        case .large:
            .body1
        }
    }
    
    var typoWeight: Typography.Weight {
        switch variant {
        case .primary, .secondary: .bold
        case .assistive: style == .text ? .bold : .medium
        }
    }
    
    var cornerRadius: CGFloat {
        if style == .text {
            6.0
        } else {
            switch size {
            case .large: 12.0
            case .medium: 10.0
            case .small: 8.0
            }
        }
    }
    
    var contentHeight: CGFloat {
        switch size {
        case .small: style == .text ? 20 : 18
        case .medium: style == .text ? 24 : 22
        case .large: 24
        }
    }
    
    var edgeInsets: EdgeInsets {
        if style == .text {
            .init()
        } else {
            switch size {
            case .small:
                text == nil && leadingIcon != nil
                ? .init(top: 7, leading: 7, bottom: 7, trailing: 7)
                : .init(top: 7, leading: 14, bottom: 7, trailing: 14)
            case .medium:
                text == nil && leadingIcon != nil
                ? .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                : .init(top: 9, leading: 20, bottom: 9, trailing: 20)
            case .large:
                text == nil && leadingIcon != nil
                ? .init(top: 12, leading: 12, bottom: 12, trailing: 12)
                : .init(top: 12, leading: 28, bottom: 12, trailing: 28)
            }
        }
    }
    
    var interactionVariant: Interaction.Variant {
        switch variant {
        case .primary: style == .solid ? .strong : .normal
        case .secondary, .assistive: style == .solid ? .normal : .light
        }
    }
    
    var interactionColor: Color.Semantic {
        switch variant {
        case .primary: style == .solid ? .labelNormal : .primaryNormal
        case .secondary, .assistive: .labelNormal
        }
    }

    var interactionVerticalOffset: CGFloat { style == .text ? 4 : 0 }
    var interactionHorizontalOffset: CGFloat { style == .text ? 7 : 0 }
    
    var loadingSize: CGSize {
        let textHeight = (fontVariant ?? typoVariant).fontHeight
        return .init(width: textHeight, height: textHeight)
    }
}
