//
//  Color.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import UIKit

/// 디자인시스템에서 미리 정의된 컬러들입니다.
public enum Color {
    ///
    /// 디자인시스템에서 정의된 Atomic 컬러 파렛트입니다.
    ///
    /// 전체 팔레트 색상을 한번에 보려면 Figma의 [Color - Palettes (New)](https://www.figma.com/file/r0LXCzm4slyOAhR7jVp1DM/Color---Palettes-(New)?node-id=19%3A2&t=VRHF3ebMufBEkKtL-1) 를 참고하세요.
    ///
    public enum Global: String {
        // COMMON
        case globalCommon100
        case globalCommon0
        
        // NEUTRAL
        case globalNeutral100
        case globalNeutral99
        case globalNeutral95
        case globalNeutral90
        case globalNeutral80
        case globalNeutral70
        case globalNeutral60
        case globalNeutral50
        case globalNeutral40
        case globalNeutral30
        case globalNeutral20
        case globalNeutral15
        case globalNeutral10
        case globalNeutral5
        case globalNeutral0
        
        // COOL NEUTRAL
        case globalCoolNeutral100
        case globalCoolNeutral99
        case globalCoolNeutral98
        case globalCoolNeutral96
        case globalCoolNeutral95
        case globalCoolNeutral90
        case globalCoolNeutral80
        case globalCoolNeutral70
        case globalCoolNeutral60
        case globalCoolNeutral50
        case globalCoolNeutral40
        case globalCoolNeutral30
        case globalCoolNeutral25
        case globalCoolNeutral22
        case globalCoolNeutral20
        case globalCoolNeutral17
        case globalCoolNeutral15
        case globalCoolNeutral10
        case globalCoolNeutral7
        case globalCoolNeutral5
        case globalCoolNeutral0
        
        // BLUE
        case globalBlue100
        case globalBlue99
        case globalBlue95
        case globalBlue90
        case globalBlue80
        case globalBlue70
        case globalBlue60
        case globalBlue55
        case globalBlue50
        case globalBlue45
        case globalBlue40
        case globalBlue30
        case globalBlue20
        case globalBlue10
        case globalBlue0
        
        // RED
        case globalRed100
        case globalRed99
        case globalRed95
        case globalRed90
        case globalRed80
        case globalRed70
        case globalRed60
        case globalRed50
        case globalRed40
        case globalRed30
        case globalRed20
        case globalRed10
        case globalRed0
        
        // GREEN
        case globalGreen100
        case globalGreen99
        case globalGreen95
        case globalGreen90
        case globalGreen80
        case globalGreen70
        case globalGreen60
        case globalGreen50
        case globalGreen40
        case globalGreen30
        case globalGreen20
        case globalGreen10
        case globalGreen0
        
        // ORANGE
        case globalOrange100
        case globalOrange99
        case globalOrange95
        case globalOrange90
        case globalOrange80
        case globalOrange70
        case globalOrange60
        case globalOrange50
        case globalOrange40
        case globalOrange30
        case globalOrange20
        case globalOrange10
        case globalOrange0
        
        // LIME
        case globalLime100
        case globalLime99
        case globalLime95
        case globalLime90
        case globalLime80
        case globalLime70
        case globalLime60
        case globalLime50
        case globalLime40
        case globalLime30
        case globalLime20
        case globalLime10
        case globalLime0
        
        // CYAN
        case globalCyan100
        case globalCyan99
        case globalCyan95
        case globalCyan90
        case globalCyan80
        case globalCyan70
        case globalCyan60
        case globalCyan50
        case globalCyan40
        case globalCyan30
        case globalCyan20
        case globalCyan10
        case globalCyan0
        
        // LIGHT BLUE
        case globalLightBlue100
        case globalLightBlue99
        case globalLightBlue95
        case globalLightBlue90
        case globalLightBlue80
        case globalLightBlue70
        case globalLightBlue60
        case globalLightBlue50
        case globalLightBlue40
        case globalLightBlue30
        case globalLightBlue20
        case globalLightBlue10
        case globalLightBlue0
        
        // VIOLET
        case globalViolet100
        case globalViolet99
        case globalViolet95
        case globalViolet90
        case globalViolet80
        case globalViolet70
        case globalViolet60
        case globalViolet50
        case globalViolet40
        case globalViolet30
        case globalViolet20
        case globalViolet10
        case globalViolet0
        
        // PINK
        case globalPink100
        case globalPink99
        case globalPink95
        case globalPink90
        case globalPink80
        case globalPink70
        case globalPink60
        case globalPink50
        case globalPink40
        case globalPink30
        case globalPink20
        case globalPink10
        case globalPink0
        
        public var name: String { rawValue }
    }
    
    ///
    /// 디자인시스템에서 정의된 Atomic 컬러 파렛트를 바라보는 레퍼런스 컬러 값입니다. 컬러 모드에 따라 실제로는 다른 값을 가질 수 있습니다.
    ///
    /// 각 컬러 모드별 색상은 Figma의 [Color - Light (New)](https://www.figma.com/file/YfMmyQn7XDsRFm5PqV2rLU/Color---Light-(New)?node-id=0%3A1&t=bZPnjMqOyriXwL7S-1), [Color - Dark (New)](https://www.figma.com/file/j7Y8t3z3rni3snTsQGmq2q/Color---Dark-(New)?node-id=0%3A1&t=hB7mGKI3FXnGQvHI-1) 를 참고하세요.
    ///
    public enum Alias: String {
        ///
        /// Figma상의 `.color-alias-static-white` 토큰과 대응되는 값입니다.
        ///
        case staticWhite
        
        ///
        /// Figma상의 `.color-alias-static-black` 토큰과 대응되는 값입니다.
        ///
        case staticBlack
        
        ///
        /// Figma상의 `.color-alias-primary-normal` 토큰과 대응되는 값입니다.
        ///
        case primaryNormal
        
        ///
        /// Figma상의 `.color-alias-primary-strong` 토큰과 대응되는 값입니다.
        ///
        case primaryStrong
        
        ///
        /// Figma상의 `.color-alias-primary-heavy` 토큰과 대응되는 값입니다.
        ///
        case primaryHeavy
        
        ///
        /// Figma상의 `.color-alias-label-normal` 토큰과 대응되는 값입니다.
        ///
        case labelNormal
        
        ///
        /// Figma상의 `.color-alias-label-strong` 토큰과 대응되는 값입니다.
        ///
        case labelStrong
        
        ///
        /// Figma상의 `.color-alias-label-alternative` 토큰과 대응되는 값입니다.
        ///
        case labelAlternative
        
        ///
        /// Figma상의 `.color-alias-label-assistive` 토큰과 대응되는 값입니다.
        ///
        case labelAssistive
        
        ///
        /// Figma상의 `.color-alias-label-disable` 토큰과 대응되는 값입니다.
        ///
        case labelDisable
        
        ///
        /// Figma상의 `.color-alias-background-normal-normal` 토큰과 대응되는 값입니다.
        ///
        case backgroundNormal
        
        ///
        /// Figma상의 `.color-alias-background-normal-alternative` 토큰과 대응되는 값입니다.
        ///
        case backgroundNormalAlternative
        
        ///
        /// Figma상의 `.color-alias-background-elevated-normal` 토큰과 대응되는 값입니다.
        ///
        case backgroundElevated
        
        ///
        /// Figma상의 `.color-alias-background-elevated-alternative` 토큰과 대응되는 값입니다.
        ///
        case backgroundElevatedAlternative
        
        ///
        /// Figma상의 `.color-alias-interaction-inactive` 토큰과 대응되는 값입니다.
        ///
        case interactionInactive
        
        ///
        /// Figma상의 `.color-alias-interaction-disable` 토큰과 대응되는 값입니다.
        ///
        case interactionDisable
        
        ///
        /// Figma상의 `.color-alias-line-normal` 토큰과 대응되는 값입니다.
        ///
        case lineNormal
        
        ///
        /// Figma상의 `.color-alias-line-alternative` 토큰과 대응되는 값입니다.
        ///
        case lineAlternative
        
        ///
        /// Figma상의 `.color-alias-status-positive` 토큰과 대응되는 값입니다.
        ///
        case statusPositive
        
        ///
        /// Figma상의 `.color-alias-status-cautionary` 토큰과 대응되는 값입니다.
        ///
        case statusCautionary
        
        ///
        /// Figma상의 `.color-alias-status-negative` 토큰과 대응되는 값입니다.
        ///
        case statusNegative
        
        ///
        /// Figma상의 `.color-alias-accent-lime` 토큰과 대응되는 값입니다.
        ///
        case accentLime

        ///
        /// Figma상의 `.color-alias-accent-cyan` 토큰과 대응되는 값입니다.
        ///
        case accentCyan

        ///
        /// Figma상의 `.color-alias-accent-lightBlue` 토큰과 대응되는 값입니다.
        ///
        case accentLightBlue

        ///
        /// Figma상의 `.color-alias-accent-violet` 토큰과 대응되는 값입니다.
        ///
        case accentViolet

        ///
        /// Figma상의 `.color-alias-accent-pink` 토큰과 대응되는 값입니다.
        ///
        case accentPink
        
        ///
        /// Figma상의 `.color-alias-inverse-primary` 토큰과 대응되는 값입니다.
        ///
        case inversePrimary
        
        ///
        /// Figma상의 `.color-alias-inverse-background` 토큰과 대응되는 값입니다.
        ///
        case inverseBackground
        
        ///
        /// Figma상의 `.color-alias-inverse-label` 토큰과 대응되는 값입니다.
        ///
        case inverseLabel
        
        public var name: String { rawValue }
        
        func resolve(_ traitCollection: UITraitCollection) -> UIColor {
            let style = traitCollection.userInterfaceStyle
            let globalType: Color.Global
            
            switch self {
            case .staticWhite:
                globalType = .globalCommon100
            case .staticBlack:
                globalType = .globalCommon0
            case .primaryNormal:
                globalType = style == .dark ? .globalBlue60 : .globalBlue50
            case .primaryStrong:
                globalType = style == .dark ? .globalBlue55 : .globalBlue45
            case .primaryHeavy:
                globalType = style == .dark ? .globalBlue50 : .globalBlue40
            case .labelNormal:
                globalType = style == .dark ? .globalNeutral99 : .globalNeutral10
            case .labelStrong:
                globalType = style == .dark ? .globalCommon100 : .globalCommon0
            case .labelAlternative:
                globalType = style == .dark ? .globalNeutral50 : .globalNeutral60
            case .labelAssistive:
                globalType = style == .dark ? .globalNeutral30 : .globalNeutral90
            case .labelDisable:
                globalType = style == .dark ? .globalNeutral20 : .globalNeutral95
            case .backgroundNormal:
                globalType = style == .dark ? .globalCoolNeutral15 : .globalCommon100
            case .backgroundNormalAlternative:
                globalType = style == .dark ? .globalCoolNeutral5 : .globalCoolNeutral99
            case .backgroundElevated:
                globalType = style == .dark ? .globalCoolNeutral17 : .globalCommon100
            case .backgroundElevatedAlternative:
                globalType = style == .dark ? .globalCoolNeutral7 : .globalCoolNeutral99
            case .interactionInactive:
                globalType = style == .dark ? .globalCoolNeutral40 : .globalCoolNeutral70
            case .interactionDisable:
                globalType = style == .dark ? .globalCoolNeutral22 : .globalCoolNeutral98
            case .lineNormal:
                globalType = style == .dark ? .globalCoolNeutral25 : .globalCoolNeutral96
            case .lineAlternative:
                globalType = style == .dark ? .globalCoolNeutral22 : .globalCoolNeutral98
            case .statusPositive:
                globalType = style == .dark ? .globalGreen60 : .globalGreen50
            case .statusCautionary:
                globalType = style == .dark ? .globalOrange60 : .globalOrange50
            case .statusNegative:
                globalType = style == .dark ? .globalRed60 : .globalRed50
            case .accentLime:
                globalType = style == .dark ? .globalLime60 : .globalLime50
            case .accentCyan:
                globalType = style == .dark ? .globalCyan60 : .globalCyan50
            case .accentLightBlue:
                globalType = style == .dark ? .globalLightBlue60 : .globalLightBlue50
            case .accentViolet:
                globalType = style == .dark ? .globalViolet60 : .globalViolet50
            case .accentPink:
                globalType = style == .dark ? .globalPink60 : .globalPink50
            case .inversePrimary:
                globalType = style == .dark ? .globalBlue50 : .globalBlue60
            case .inverseBackground:
                globalType = style == .dark ? .globalCommon100 : .globalCoolNeutral15
            case .inverseLabel:
                globalType = style == .dark ? .globalNeutral10 : .globalNeutral99
            }
            
            return .load(name: globalType.name)
        }
    }
    
    ///
    /// 디자인시스템에서 정의된 Component 컬러 파렛트를 바라보는 레퍼런스 컬러 값입니다. 컬러 모드에 따라 실제로는 다른 값을 가질 수 있습니다.
    ///
    /// 각 컬러 모드별 색상은 Figma의 [Color - Light (New)](https://www.figma.com/file/YfMmyQn7XDsRFm5PqV2rLU/Color---Light-(New)?node-id=0%3A1&t=bZPnjMqOyriXwL7S-1), [Color - Dark (New)](https://www.figma.com/file/j7Y8t3z3rni3snTsQGmq2q/Color---Dark-(New)?node-id=0%3A1&t=hB7mGKI3FXnGQvHI-1) 를 참고하세요.
    ///
    public enum Component: String {
        ///
        /// Figma상의 `.color-component-fill-normal` 토큰과 대응되는 값입니다.
        ///
        case fillNormal
        
        ///
        /// Figma상의 `.color-component-fill-strong` 토큰과 대응되는 값입니다.
        ///
        case fillStrong
        
        ///
        /// Figma상의 `.color-component-fill-alternative` 토큰과 대응되는 값입니다.
        ///
        case fillAlternative
        
        ///
        /// Figma상의 `.color-component-material-dimmer` 토큰과 대응되는 값입니다.
        ///
        case materialDimmer
        
        public var name: String { rawValue }
        
        func resolve(_ traitCollection: UITraitCollection) -> UIColor {
            let style = traitCollection.userInterfaceStyle
            
            let baseColor: UIColor
            let alpha: CGFloat
            
            switch self {
            case .fillNormal:
                baseColor = .load(name: Global.globalCoolNeutral50.name)
                alpha = style == .dark ? 0.22 : 0.08
            case .fillStrong:
                baseColor = .load(name: Global.globalCoolNeutral50.name)
                alpha = style == .dark ? 0.28 : 0.16
            case .fillAlternative:
                baseColor = .load(name: Global.globalCoolNeutral50.name)
                alpha = style == .dark ? 0.12 : 0.05
            case .materialDimmer:
                let gColor = style == .dark ? Global.globalCoolNeutral5 : Global.globalCoolNeutral10
                baseColor = .load(name: gColor.name)
                alpha = style == .dark ? 0.74 : 0.52
            }
            
            return baseColor.withAlphaComponent(alpha)
        }
    }
}
