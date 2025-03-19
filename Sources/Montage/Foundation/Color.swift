//
//  Color.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI

/// 디자인시스템에서 미리 정의된 컬러들입니다.
public enum Color {
    ///
    /// 디자인시스템에서 정의된 Atomic 컬러 파렛트입니다.
    ///
    /// 전체 팔레트 색상을 한번에 보려면 Figma의 [Color - Palettes (New)](https://www.figma.com/file/r0LXCzm4slyOAhR7jVp1DM/Color---Palettes-(New)?node-id=19%3A2&t=VRHF3ebMufBEkKtL-1) 를 참고하세요.
    ///
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
    
    ///
    /// 디자인시스템에서 정의된 Atomic 컬러 파렛트를 바라보는 레퍼런스 컬러 값입니다. 컬러 모드에 따라 실제로는 다른 값을 가질 수 있습니다.
    ///
    /// 각 컬러 모드별 색상은 Figma의 [Color - Light (New)](https://www.figma.com/file/YfMmyQn7XDsRFm5PqV2rLU/Color---Light-(New)?node-id=0%3A1&t=bZPnjMqOyriXwL7S-1), [Color - Dark (New)](https://www.figma.com/file/j7Y8t3z3rni3snTsQGmq2q/Color---Dark-(New)?node-id=0%3A1&t=hB7mGKI3FXnGQvHI-1) 를 참고하세요.
    ///
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
        /// Figma상의 `.color-semantic-accent-lime` 토큰과 대응되는 값입니다.
        ///
        case accentLime

        ///
        /// Figma상의 `.color-semantic-accent-cyan` 토큰과 대응되는 값입니다.
        ///
        case accentCyan

        ///
        /// Figma상의 `.color-semantic-accent-lightBlue` 토큰과 대응되는 값입니다.
        ///
        case accentLightBlue

        ///
        /// Figma상의 `.color-semantic-accent-violet` 토큰과 대응되는 값입니다.
        ///
        case accentViolet
        
        ///
        /// Figma상의 `.color-semantic-accent-purple` 토큰과 대응되는 값입니다.
        ///
        case accentPurple
        
        ///
        /// Figma상의 `.color-semantic-accent-redOrange` 토큰과 대응되는 값입니다.
        ///
        case accentRedOrange

        ///
        /// Figma상의 `.color-semantic-accent-pink` 토큰과 대응되는 값입니다.
        ///
        case accentPink
        
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
            case .accentLime:
                atomicColor = style == .dark ? .lime60 : .lime50
            case .accentCyan:
                atomicColor = style == .dark ? .cyan60 : .cyan50
            case .accentLightBlue:
                atomicColor = style == .dark ? .lightBlue60 : .lightBlue50
            case .accentViolet:
                atomicColor = style == .dark ? .violet60 : .violet50
            case .accentPurple:
                atomicColor = style == .dark ? .purple60 : .purple50
            case .accentPink:
                atomicColor = style == .dark ? .pink60 : .pink50
            case .accentRedOrange:
                atomicColor = style == .dark ? .redOrange60 : .redOrange50
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
