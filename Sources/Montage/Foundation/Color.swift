//
//  Color.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI

/// 디자인 시스템에서 미리 정의된 컬러 네임스페이스
///
/// Color는 모든 Montage 컴포넌트에서 일관된 색상을 사용할 수 있도록
/// 설계된 색상 체계를 제공합니다. Atomic과 Semantic으로 구분된 두 가지 
/// 색상 타입을 지원합니다.
///
/// **사용 예시**:
/// ```swift
/// // Atomic 색상 사용
/// let atomicColor = Color.Atomic.blue50
/// let uiColor = UIColor.atomic(.blue50)
/// let swiftUIColor = SwiftUI.Color.atomic(.blue50)
/// 
/// // Semantic 색상 사용
/// let semanticColor = Color.Semantic.primaryNormal
/// let uiColor = UIColor.semantic(.primaryNormal)
/// let swiftUIColor = SwiftUI.Color.semantic(.primaryNormal)
/// ```
///
/// - Note: 디자인 시스템 UI 구성요소를 개발할 때는 직접 Atomic 색상을 사용하기보다
///   Semantic 색상을 사용하는 것이 권장됩니다. 이는 다크 모드와 같은 다양한 
///   환경에서 일관된 디자인을 유지하는 데 도움이 됩니다.
public enum Color {
    /// 디자인 시스템에서 정의된 Atomic 컬러 팔레트
    ///
    /// Atomic 색상은 디자인 시스템의 기본 색상 값을 정의합니다.
    /// 이 색상들은 직접 사용하기보다는 Semantic 색상의 기반이 되는 
    /// 기본 색상 팔레트로 활용됩니다.
    ///
    /// 전체 팔레트 색상을 한번에 보려면 Figma의 [Color - Atomic)](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-52196) 를 참고하세요.
    ///
    /// **사용 예시**:
    /// ```swift
    /// // UIKit에서 사용
    /// view.backgroundColor = UIColor.atomic(.blue50)
    ///
    /// // SwiftUI에서 사용
    /// Text("텍스트")
    ///     .foregroundColor(.atomic(.red60))
    /// ```
    ///
    /// - Note: 숫자가 높을수록 밝은 색상을 나타내며, 100에 가까울수록 흰색에 가깝고
    ///   0에 가까울수록 검은색에 가깝습니다.
    public enum Atomic: String, CaseIterable, ColorResolvable {
        // COMMON
        case common100
        case common0
        
        // NEUTRAL
        case neutral100
        case neutral99
        case neutral95
        case neutral90
        case neutral80
        case neutral70
        case neutral60
        case neutral50
        case neutral40
        case neutral30
        case neutral22
        case neutral20
        case neutral15
        case neutral10
        case neutral5
        case neutral0
        
        // COOL NEUTRAL
        case coolNeutral100
        case coolNeutral99
        case coolNeutral98
        case coolNeutral97
        case coolNeutral96
        case coolNeutral95
        case coolNeutral90
        case coolNeutral80
        case coolNeutral70
        case coolNeutral60
        case coolNeutral50
        case coolNeutral40
        case coolNeutral30
        case coolNeutral25
        case coolNeutral23
        case coolNeutral22
        case coolNeutral20
        case coolNeutral17
        case coolNeutral15
        case coolNeutral10
        case coolNeutral7
        case coolNeutral5
        case coolNeutral0
        
        // BLUE
        case blue100
        case blue99
        case blue95
        case blue90
        case blue80
        case blue70
        case blue65
        case blue60
        case blue55
        case blue50
        case blue45
        case blue40
        case blue30
        case blue20
        case blue10
        case blue0
        
        // RED
        case red100
        case red99
        case red95
        case red90
        case red80
        case red70
        case red60
        case red50
        case red40
        case red30
        case red20
        case red10
        case red0
        
        // GREEN
        case green100
        case green99
        case green95
        case green90
        case green80
        case green70
        case green60
        case green50
        case green40
        case green30
        case green20
        case green10
        case green0
        
        // ORANGE
        case orange100
        case orange99
        case orange95
        case orange90
        case orange80
        case orange70
        case orange60
        case orange50
        case orange40
        case orange39
        case orange30
        case orange20
        case orange10
        case orange0
        
        // LIME
        case lime100
        case lime99
        case lime95
        case lime90
        case lime80
        case lime70
        case lime60
        case lime50
        case lime40
        case lime37
        case lime30
        case lime20
        case lime10
        case lime0
        
        // CYAN
        case cyan100
        case cyan99
        case cyan95
        case cyan90
        case cyan80
        case cyan70
        case cyan60
        case cyan50
        case cyan40
        case cyan30
        case cyan20
        case cyan10
        case cyan0
        
        // LIGHT BLUE
        case lightBlue100
        case lightBlue99
        case lightBlue95
        case lightBlue90
        case lightBlue80
        case lightBlue70
        case lightBlue60
        case lightBlue50
        case lightBlue40
        case lightBlue30
        case lightBlue20
        case lightBlue10
        case lightBlue0
        
        // VIOLET
        case violet100
        case violet99
        case violet95
        case violet90
        case violet80
        case violet70
        case violet60
        case violet50
        case violet45
        case violet40
        case violet30
        case violet20
        case violet10
        case violet0
        
        // PURPLE
        case purple100
        case purple99
        case purple95
        case purple90
        case purple80
        case purple70
        case purple60
        case purple50
        case purple40
        case purple30
        case purple20
        case purple10
        case purple0
        
        // PINK
        case pink100
        case pink99
        case pink95
        case pink90
        case pink80
        case pink70
        case pink60
        case pink50
        case pink46
        case pink40
        case pink30
        case pink20
        case pink10
        case pink0
        
        // Red Orange
        case redOrange100
        case redOrange99
        case redOrange95
        case redOrange90
        case redOrange80
        case redOrange70
        case redOrange60
        case redOrange50
        case redOrange48
        case redOrange40
        case redOrange30
        case redOrange20
        case redOrange10
        case redOrange0
        
        public var name: String { rawValue }
        
        public func resolve(_: UITraitCollection) -> UIColor {
            .load(name: name)
        }
    }
    
    /// 디자인 시스템에서 정의된 Semantic 컬러 값
    ///
    /// Semantic 색상은 Atomic 색상을 참조하여 의미적 맥락에 따라 
    /// 적절한 색상을 제공합니다. 다크 모드와 라이트 모드에서 
    /// 자동으로 적절한 색상으로 변환됩니다.
    ///
    /// 각 컬러 모드별 색상은 Figma의 [Color - Semantic](https://www.figma.com/design/EyggXAhHnZLnMvqvjzYg7U/Wanted-Design-System--Community-?node-id=15625-32983) 를 참고하세요.
    ///
    /// **사용 예시**:
    /// ```swift
    /// // UIKit에서 사용
    /// label.textColor = UIColor.semantic(.labelNormal)
    /// 
    /// // SwiftUI에서 사용
    /// Button("버튼") { }
    ///     .foregroundColor(.semantic(.primaryNormal))
    ///     .background(Color.semantic(.backgroundNormal))
    /// ```
    ///
    /// - Note: 컴포넌트 개발 시 Atomic 색상보다 Semantic 색상을 
    ///   우선적으로 사용하는 것이 권장됩니다.
    public enum Semantic: String, CaseIterable, ColorResolvable {
        ///
        /// Figma상의 `.color-semantic-static-white` 토큰과 대응되는 값입니다.
        /// 
        case staticWhite
        
        ///
        /// Figma상의 `.color-semantic-static-black` 토큰과 대응되는 값입니다.
        ///
        case staticBlack
        
        ///
        /// Figma상의 `.color-semantic-primary-normal` 토큰과 대응되는 값입니다.
        ///
        case primaryNormal
        
        ///
        /// Figma상의 `.color-semantic-primary-strong` 토큰과 대응되는 값입니다.
        ///
        case primaryStrong
        
        ///
        /// Figma상의 `.color-semantic-primary-heavy` 토큰과 대응되는 값입니다.
        ///
        case primaryHeavy
        
        ///
        /// Figma상의 `.color-semantic-label-normal` 토큰과 대응되는 값입니다.
        ///
        case labelNormal
        
        ///
        /// Figma상의 `.color-semantic-label-strong` 토큰과 대응되는 값입니다.
        ///
        case labelStrong
        
        ///
        /// Figma상의 `.color-semantic-label-neutral` 토큰과 대응되는 값입니다.
        ///
        case labelNeutral
        
        ///
        /// Figma상의 `.color-semantic-label-alternative` 토큰과 대응되는 값입니다.
        ///
        case labelAlternative
        
        ///
        /// Figma상의 `.color-semantic-label-assistive` 토큰과 대응되는 값입니다.
        ///
        case labelAssistive
        
        ///
        /// Figma상의 `.color-semantic-label-disable` 토큰과 대응되는 값입니다.
        ///
        case labelDisable
        
        ///
        /// Figma상의 `.color-semantic-background-normal-normal` 토큰과 대응되는 값입니다.
        ///
        case backgroundNormal
        
        ///
        /// Figma상의 `.color-semantic-background-normal-alternative` 토큰과 대응되는 값입니다.
        ///
        case backgroundNormalAlternative
        
        ///
        /// Figma상의 `.color-semantic-background-elevated-normal` 토큰과 대응되는 값입니다.
        ///
        case backgroundElevated
        
        ///
        /// Figma상의 `.color-semantic-background-elevated-alternative` 토큰과 대응되는 값입니다.
        ///
        case backgroundElevatedAlternative
        
        ///
        /// Figma상의 `.color-semantic-interaction-inactive` 토큰과 대응되는 값입니다.
        ///
        case interactionInactive
        
        ///
        /// Figma상의 `.color-semantic-interaction-disable` 토큰과 대응되는 값입니다.
        ///
        case interactionDisable
        
        ///
        /// Figma상의 `.color-semantic-line-normal` 토큰과 대응되는 값입니다.
        ///
        case lineNormal
        
        ///
        /// Figma상의 `.color-semantic-line-neutral` 토큰과 대응되는 값입니다.
        ///
        case lineNeutral
        
        ///
        /// Figma상의 `.color-semantic-line-alternative` 토큰과 대응되는 값입니다.
        ///
        case lineAlternative
        
        ///
        /// Figma상의 `.color-semantic-line-solid-normal` 토큰과 대응되는 값입니다.
        ///
        case lineSolidNormal
        
        ///
        /// Figma상의 `.color-semantic-line-solid-neutral` 토큰과 대응되는 값입니다.
        ///
        case lineSolidNeutral
        
        ///
        /// Figma상의 `.color-semantic-line-solid-alternative` 토큰과 대응되는 값입니다.
        ///
        case lineSolidAlternative
        
        ///
        /// Figma상의 `.color-semantic-status-positive` 토큰과 대응되는 값입니다.
        ///
        case statusPositive
        
        ///
        /// Figma상의 `.color-semantic-status-cautionary` 토큰과 대응되는 값입니다.
        ///
        case statusCautionary
        
        ///
        /// Figma상의 `.color-semantic-status-negative` 토큰과 대응되는 값입니다.
        ///
        case statusNegative
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-red` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundRed
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-redOrange` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundRedOrange

        ///
        /// Figma상의 `.color-semantic-accent-foreground-orange` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundOrange

        ///
        /// Figma상의 `.color-semantic-accent-foreground-lime` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundLime
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-green` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundGreen

        ///
        /// Figma상의 `.color-semantic-accent-foreground-cyan` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundCyan

        ///
        /// Figma상의 `.color-semantic-accent-foreground-lightBlue` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundLightBlue
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-blue` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundBlue

        ///
        /// Figma상의 `.color-semantic-accent-foreground-violet` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundViolet
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-purple` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundPurple
        
        ///
        /// Figma상의 `.color-semantic-accent-foreground-pink` 토큰과 대응되는 값입니다.
        ///
        case accentForegroundPink
        
        ///
        /// Figma상의 `.color-semantic-accent-background-redOrange` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundRedOrange
        
        ///
        /// Figma상의 `.color-semantic-accent-background-lime` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundLime

        ///
        /// Figma상의 `.color-semantic-accent-background-cyan` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundCyan

        ///
        /// Figma상의 `.color-semantic-accent-background-lightBlue` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundLightBlue

        ///
        /// Figma상의 `.color-semantic-accent-background-violet` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundViolet
        
        ///
        /// Figma상의 `.color-semantic-accent-background-purple` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundPurple

        ///
        /// Figma상의 `.color-semantic-accent-background-pink` 토큰과 대응되는 값입니다.
        ///
        case accentBackgroundPink
        
        ///
        /// Figma상의 `.color-semantic-inverse-primary` 토큰과 대응되는 값입니다.
        ///
        case inversePrimary
        
        ///
        /// Figma상의 `.color-semantic-inverse-background` 토큰과 대응되는 값입니다.
        ///
        case inverseBackground
        
        ///
        /// Figma상의 `.color-semantic-inverse-label` 토큰과 대응되는 값입니다.
        ///
        case inverseLabel
        
        ///
        /// Figma상의 `.color-semantic-fill-normal` 토큰과 대응되는 값입니다.
        ///
        case fillNormal
        
        ///
        /// Figma상의 `.color-semantic-fill-strong` 토큰과 대응되는 값입니다.
        ///
        case fillStrong
        
        ///
        /// Figma상의 `.color-semantic-fill-alternative` 토큰과 대응되는 값입니다.
        ///
        case fillAlternative
        
        ///
        /// Figma상의 `.color-semantic-material-dimmer` 토큰과 대응되는 값입니다.
        ///
        case materialDimmer
        
        public var name: String { rawValue }
        
        public func resolve(_ traitCollection: UITraitCollection) -> UIColor {
            let style = traitCollection.userInterfaceStyle
            let atomicColor: Color.Atomic
            var opacity: Decorate.Opacity = .p100
            
            switch self {
            case .staticWhite:
                atomicColor = .common100
            case .staticBlack:
                atomicColor = .common0
            case .primaryNormal:
                atomicColor = style == .dark ? .blue60 : .blue50
            case .primaryStrong:
                atomicColor = style == .dark ? .blue55 : .blue45
            case .primaryHeavy:
                atomicColor = style == .dark ? .blue50 : .blue40
            case .labelNormal:
                atomicColor = style == .dark ? .coolNeutral99 : .coolNeutral10
            case .labelStrong:
                atomicColor = style == .dark ? .common100 : .common0
            case .labelNeutral:
                atomicColor = style == .dark ? .coolNeutral90 : .coolNeutral22
                opacity = .p088
            case .labelAlternative:
                atomicColor = style == .dark ? .coolNeutral80 : .coolNeutral25
                opacity = .p061
            case .labelAssistive:
                atomicColor = style == .dark ? .coolNeutral80 : .coolNeutral25
                opacity = .p028
            case .labelDisable:
                atomicColor = style == .dark ? .coolNeutral70 : .coolNeutral25
                opacity = .p016
            case .backgroundNormal:
                atomicColor = style == .dark ? .coolNeutral15 : .common100
            case .backgroundNormalAlternative:
                atomicColor = style == .dark ? .coolNeutral5 : .coolNeutral99
            case .backgroundElevated:
                atomicColor = style == .dark ? .coolNeutral17 : .common100
            case .backgroundElevatedAlternative:
                atomicColor = style == .dark ? .coolNeutral7 : .coolNeutral99
            case .interactionInactive:
                atomicColor = style == .dark ? .coolNeutral40 : .coolNeutral70
            case .interactionDisable:
                atomicColor = style == .dark ? .coolNeutral22 : .coolNeutral98
            case .lineNormal:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p032 : .p022
            case .lineNeutral:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p028 : .p016
            case .lineAlternative:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p022 : .p008
            case .lineSolidNormal:
                atomicColor = style == .dark ? .coolNeutral25 : .coolNeutral96
            case .lineSolidNeutral:
                atomicColor = style == .dark ? .coolNeutral23 : .coolNeutral97
            case .lineSolidAlternative:
                atomicColor = style == .dark ? .coolNeutral22 : .coolNeutral98
            case .statusPositive:
                atomicColor = style == .dark ? .green60 : .green50
            case .statusCautionary:
                atomicColor = style == .dark ? .orange60 : .orange50
            case .statusNegative:
                atomicColor = style == .dark ? .red60 : .red50
            case .accentForegroundRed:
                atomicColor = .red40
            case .accentForegroundRedOrange:
                atomicColor = .redOrange48
            case .accentForegroundOrange:
                atomicColor = .orange39
            case .accentForegroundLime:
                atomicColor = .lime37
            case .accentForegroundGreen:
                atomicColor = .green40
            case .accentForegroundCyan:
                atomicColor = .cyan40
            case .accentForegroundLightBlue:
                atomicColor = .lightBlue40
            case .accentForegroundBlue:
                atomicColor = .blue45
            case .accentForegroundViolet:
                atomicColor = .violet45
            case .accentForegroundPurple:
                atomicColor = .purple40
            case .accentForegroundPink:
                atomicColor = .pink46
            case .accentBackgroundRedOrange:
                atomicColor = style == .dark ? .redOrange60 : .redOrange50
            case .accentBackgroundLime:
                atomicColor = style == .dark ? .lime60 : .lime50
            case .accentBackgroundCyan:
                atomicColor = style == .dark ? .cyan60 : .cyan50
            case .accentBackgroundLightBlue:
                atomicColor = style == .dark ? .lightBlue60 : .lightBlue50
            case .accentBackgroundViolet:
                atomicColor = style == .dark ? .violet60 : .violet50
            case .accentBackgroundPurple:
                atomicColor = style == .dark ? .purple60 : .purple50
            case .accentBackgroundPink:
                atomicColor = style == .dark ? .pink60 : .pink50
            case .inversePrimary:
                atomicColor = style == .dark ? .blue50 : .blue60
            case .inverseBackground:
                atomicColor = style == .dark ? .common100 : .coolNeutral15
            case .inverseLabel:
                atomicColor = style == .dark ? .neutral10 : .neutral99
            case .fillNormal:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p022 : .p008
            case .fillStrong:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p028 : .p016
            case .fillAlternative:
                atomicColor = .coolNeutral50
                opacity = style == .dark ? .p012 : .p005
            case .materialDimmer:
                atomicColor = style == .dark ? .coolNeutral5 : .coolNeutral10
                opacity = style == .dark ? .p074 : .p052
            }
            
            return .load(name: atomicColor.name).withAlphaComponent(.opacity(opacity))
        }
    }
}

public protocol ColorResolvable {
    func resolve(_ traitCollection: UITraitCollection) -> UIColor
}
