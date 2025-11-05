//
//  Color.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/12.
//

import SwiftUI
import UIKit

/// 디자인 시스템에서 미리 정의된 컬러 네임스페이스
///
/// Color는 모든 Montage 컴포넌트에서 일관된 색상을 사용할 수 있도록
/// 설계된 색상 체계를 제공합니다. Atomic과 Semantic으로 구분된 두 가지 
/// 색상 타입을 지원합니다.
///
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
/// - Note: UI 구성요소를 개발할 때는 직접 Atomic 색상을 사용하기보다
///   Semantic 색상을 사용하는 것이 권장됩니다. 이는 다크 모드와 같은 다양한 
///   환경에서 일관된 디자인을 유지하는 데 도움이 됩니다.
public enum Color {
    /// 디자인 시스템에서 정의된 Atomic 컬러 팔레트
    ///
    /// Atomic 색상은 디자인 시스템의 기본 색상 값을 정의합니다.
    /// 이 색상들은 직접 사용하기보다는 Semantic 색상의 기반이 되는 
    /// 기본 색상 팔레트로 활용됩니다.
    ///
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
        /// 흰색 계열의 기본 색상
        case common100
        /// 검은색 계열의 기본 색상
        case common0
        
        // NEUTRAL
        /// 가장 밝은 중립 색상
        case neutral100
        /// 매우 밝은 중립 색상
        case neutral99
        /// 밝은 중립 색상
        case neutral95
        /// 약간 밝은 중립 색상
        case neutral90
        /// 중간 밝기의 중립 색상
        case neutral80
        /// 중간 중립 색상
        case neutral70
        /// 약간 어두운 중립 색상
        case neutral60
        /// 중간 어두운 중립 색상
        case neutral50
        /// 어두운 중립 색상
        case neutral40
        /// 매우 어두운 중립 색상
        case neutral30
        /// 특별한 어두운 중립 색상
        case neutral22
        /// 매우 어두운 중립 색상
        case neutral20
        /// 거의 검은색에 가까운 중립 색상
        case neutral15
        /// 거의 검은색 중립 색상
        case neutral10
        /// 매우 어두운 중립 색상
        case neutral5
        /// 가장 어두운 중립 색상
        case neutral0
        
        // COOL NEUTRAL
        /// 가장 밝은 차가운 중립 색상
        case coolNeutral100
        /// 매우 밝은 차가운 중립 색상
        case coolNeutral99
        /// 밝은 차가운 중립 색상
        case coolNeutral98
        /// 약간 밝은 차가운 중립 색상
        case coolNeutral97
        /// 중간 밝기의 차가운 중립 색상
        case coolNeutral96
        /// 밝은 차가운 중립 색상
        case coolNeutral95
        /// 약간 밝은 차가운 중립 색상
        case coolNeutral90
        /// 중간 밝기의 차가운 중립 색상
        case coolNeutral80
        /// 중간 차가운 중립 색상
        case coolNeutral70
        /// 약간 어두운 차가운 중립 색상
        case coolNeutral60
        /// 중간 어두운 차가운 중립 색상
        case coolNeutral50
        /// 어두운 차가운 중립 색상
        case coolNeutral40
        /// 매우 어두운 차가운 중립 색상
        case coolNeutral30
        /// 특별한 어두운 차가운 중립 색상
        case coolNeutral25
        /// 매우 어두운 차가운 중립 색상
        case coolNeutral23
        /// 어두운 차가운 중립 색상
        case coolNeutral22
        /// 매우 어두운 차가운 중립 색상
        case coolNeutral20
        /// 거의 검은색에 가까운 차가운 중립 색상
        case coolNeutral17
        /// 거의 검은색 차가운 중립 색상
        case coolNeutral15
        /// 매우 어두운 차가운 중립 색상
        case coolNeutral10
        /// 거의 검은색에 가까운 차가운 중립 색상
        case coolNeutral7
        /// 매우 어두운 차가운 중립 색상
        case coolNeutral5
        /// 가장 어두운 차가운 중립 색상
        case coolNeutral0
        
        // BLUE
        /// 가장 밝은 파란색
        case blue100
        /// 매우 밝은 파란색
        case blue99
        /// 밝은 파란색
        case blue95
        /// 약간 밝은 파란색
        case blue90
        /// 중간 밝기의 파란색
        case blue80
        /// 중간 파란색
        case blue70
        /// 약간 어두운 파란색
        case blue65
        /// 중간 어두운 파란색
        case blue60
        /// 어두운 파란색
        case blue55
        /// 중간 어두운 파란색
        case blue50
        /// 어두운 파란색
        case blue45
        /// 매우 어두운 파란색
        case blue40
        /// 거의 검은색에 가까운 파란색
        case blue30
        /// 거의 검은색 파란색
        case blue20
        /// 매우 어두운 파란색
        case blue10
        /// 가장 어두운 파란색
        case blue0
        
        // RED
        /// 가장 밝은 빨간색
        case red100
        /// 매우 밝은 빨간색
        case red99
        /// 밝은 빨간색
        case red95
        /// 약간 밝은 빨간색
        case red90
        /// 중간 밝기의 빨간색
        case red80
        /// 중간 빨간색
        case red70
        /// 약간 어두운 빨간색
        case red60
        /// 중간 어두운 빨간색
        case red50
        /// 어두운 빨간색
        case red40
        /// 매우 어두운 빨간색
        case red30
        /// 거의 검은색에 가까운 빨간색
        case red20
        /// 거의 검은색 빨간색
        case red10
        /// 가장 어두운 빨간색
        case red0
        
        // GREEN
        /// 가장 밝은 초록색
        case green100
        /// 매우 밝은 초록색
        case green99
        /// 밝은 초록색
        case green95
        /// 약간 밝은 초록색
        case green90
        /// 중간 밝기의 초록색
        case green80
        /// 중간 초록색
        case green70
        /// 약간 어두운 초록색
        case green60
        /// 중간 어두운 초록색
        case green50
        /// 어두운 초록색
        case green40
        /// 매우 어두운 초록색
        case green30
        /// 거의 검은색에 가까운 초록색
        case green20
        /// 거의 검은색 초록색
        case green10
        /// 가장 어두운 초록색
        case green0
        
        // ORANGE
        /// 가장 밝은 주황색
        case orange100
        /// 매우 밝은 주황색
        case orange99
        /// 밝은 주황색
        case orange95
        /// 약간 밝은 주황색
        case orange90
        /// 중간 밝기의 주황색
        case orange80
        /// 중간 주황색
        case orange70
        /// 약간 어두운 주황색
        case orange60
        /// 중간 어두운 주황색
        case orange50
        /// 어두운 주황색
        case orange40
        /// 특별한 어두운 주황색
        case orange39
        /// 매우 어두운 주황색
        case orange30
        /// 거의 검은색에 가까운 주황색
        case orange20
        /// 거의 검은색 주황색
        case orange10
        /// 가장 어두운 주황색
        case orange0
        
        // LIME
        /// 가장 밝은 라임색
        case lime100
        /// 매우 밝은 라임색
        case lime99
        /// 밝은 라임색
        case lime95
        /// 약간 밝은 라임색
        case lime90
        /// 중간 밝기의 라임색
        case lime80
        /// 중간 라임색
        case lime70
        /// 약간 어두운 라임색
        case lime60
        /// 중간 어두운 라임색
        case lime50
        /// 어두운 라임색
        case lime40
        /// 특별한 어두운 라임색
        case lime37
        /// 매우 어두운 라임색
        case lime30
        /// 거의 검은색에 가까운 라임색
        case lime20
        /// 거의 검은색 라임색
        case lime10
        /// 가장 어두운 라임색
        case lime0
        
        // CYAN
        /// 가장 밝은 시안색
        case cyan100
        /// 매우 밝은 시안색
        case cyan99
        /// 밝은 시안색
        case cyan95
        /// 약간 밝은 시안색
        case cyan90
        /// 중간 밝기의 시안색
        case cyan80
        /// 중간 시안색
        case cyan70
        /// 약간 어두운 시안색
        case cyan60
        /// 중간 어두운 시안색
        case cyan50
        /// 어두운 시안색
        case cyan40
        /// 매우 어두운 시안색
        case cyan30
        /// 거의 검은색에 가까운 시안색
        case cyan20
        /// 거의 검은색 시안색
        case cyan10
        /// 가장 어두운 시안색
        case cyan0
        
        // LIGHT BLUE
        /// 가장 밝은 하늘색
        case lightBlue100
        /// 매우 밝은 하늘색
        case lightBlue99
        /// 밝은 하늘색
        case lightBlue95
        /// 약간 밝은 하늘색
        case lightBlue90
        /// 중간 밝기의 하늘색
        case lightBlue80
        /// 중간 하늘색
        case lightBlue70
        /// 약간 어두운 하늘색
        case lightBlue60
        /// 중간 어두운 하늘색
        case lightBlue50
        /// 어두운 하늘색
        case lightBlue40
        /// 매우 어두운 하늘색
        case lightBlue30
        /// 거의 검은색에 가까운 하늘색
        case lightBlue20
        /// 거의 검은색 하늘색
        case lightBlue10
        /// 가장 어두운 하늘색
        case lightBlue0
        
        // VIOLET
        /// 가장 밝은 보라색
        case violet100
        /// 매우 밝은 보라색
        case violet99
        /// 밝은 보라색
        case violet95
        /// 약간 밝은 보라색
        case violet90
        /// 중간 밝기의 보라색
        case violet80
        /// 중간 보라색
        case violet70
        /// 약간 어두운 보라색
        case violet60
        /// 중간 어두운 보라색
        case violet50
        /// 특별한 어두운 보라색
        case violet45
        /// 어두운 보라색
        case violet40
        /// 매우 어두운 보라색
        case violet30
        /// 거의 검은색에 가까운 보라색
        case violet20
        /// 거의 검은색 보라색
        case violet10
        /// 가장 어두운 보라색
        case violet0
        
        // PURPLE
        /// 가장 밝은 자주색
        case purple100
        /// 매우 밝은 자주색
        case purple99
        /// 밝은 자주색
        case purple95
        /// 약간 밝은 자주색
        case purple90
        /// 중간 밝기의 자주색
        case purple80
        /// 중간 자주색
        case purple70
        /// 약간 어두운 자주색
        case purple60
        /// 중간 어두운 자주색
        case purple50
        /// 어두운 자주색
        case purple40
        /// 매우 어두운 자주색
        case purple30
        /// 거의 검은색에 가까운 자주색
        case purple20
        /// 거의 검은색 자주색
        case purple10
        /// 가장 어두운 자주색
        case purple0
        
        // PINK
        /// 가장 밝은 분홍색
        case pink100
        /// 매우 밝은 분홍색
        case pink99
        /// 밝은 분홍색
        case pink95
        /// 약간 밝은 분홍색
        case pink90
        /// 중간 밝기의 분홍색
        case pink80
        /// 중간 분홍색
        case pink70
        /// 약간 어두운 분홍색
        case pink60
        /// 중간 어두운 분홍색
        case pink50
        /// 특별한 어두운 분홍색
        case pink46
        /// 어두운 분홍색
        case pink40
        /// 매우 어두운 분홍색
        case pink30
        /// 거의 검은색에 가까운 분홍색
        case pink20
        /// 거의 검은색 분홍색
        case pink10
        /// 가장 어두운 분홍색
        case pink0
        
        // Red Orange
        /// 가장 밝은 붉은 주황색
        case redOrange100
        /// 매우 밝은 붉은 주황색
        case redOrange99
        /// 밝은 붉은 주황색
        case redOrange95
        /// 약간 밝은 붉은 주황색
        case redOrange90
        /// 중간 밝기의 붉은 주황색
        case redOrange80
        /// 중간 붉은 주황색
        case redOrange70
        /// 약간 어두운 붉은 주황색
        case redOrange60
        /// 중간 어두운 붉은 주황색
        case redOrange50
        /// 특별한 어두운 붉은 주황색
        case redOrange48
        /// 어두운 붉은 주황색
        case redOrange40
        /// 매우 어두운 붉은 주황색
        case redOrange30
        /// 거의 검은색에 가까운 붉은 주황색
        case redOrange20
        /// 거의 검은색 붉은 주황색
        case redOrange10
        /// 가장 어두운 붉은 주황색
        case redOrange0
        
        /// 주어진 UITraitCollection에 따라 UIColor를 반환합니다.
        ///
        /// - Parameter traitCollection: 색상을 해석할 UITraitCollection
        /// - Returns: 해석된 UIColor 인스턴스
        public func resolve(_ traitCollection: UITraitCollection) -> UIColor {
            .load(name: rawValue)
        }
    }
    
    /// 디자인 시스템에서 정의된 Semantic 컬러 값
    ///
    /// Semantic 색상은 Atomic 색상을 참조하여 의미적 맥락에 따라 
    /// 적절한 색상을 제공합니다. 다크 모드와 라이트 모드에서 
    /// 자동으로 적절한 색상으로 변환됩니다.
    ///
    /// ```swift
    /// // UIKit에서 사용
    /// label.textColor = UIColor.semantic(.labelNormal)
    /// 
    /// // SwiftUI에서 사용
    /// Button("버튼") { }
    ///     .foregroundColor(.semantic(.primaryNormal))
    ///     .background(Color.semantic(.backgroundNormal))
    /// ```
    public enum Semantic: String, CaseIterable, ColorResolvable {
        /// 정적 흰색 색상
        case staticWhite
        /// 정적 검은색 색상
        case staticBlack

        /// 기본 주요 색상
        case primaryNormal
        /// 강조된 주요 색상
        case primaryStrong
        /// 매우 강조된 주요 색상
        case primaryHeavy

        /// 기본 라벨 색상
        case labelNormal
        /// 강조된 라벨 색상
        case labelStrong
        /// 중립적인 라벨 색상
        case labelNeutral
        /// 대체 라벨 색상
        case labelAlternative
        /// 보조 라벨 색상
        case labelAssistive
        /// 비활성화된 라벨 색상
        case labelDisable

        /// 기본 배경 색상
        case backgroundNormal
        /// 대체 배경 색상
        case backgroundNormalAlternative
        /// 상승된 배경 색상
        case backgroundElevated
        /// 상승된 대체 배경 색상
        case backgroundElevatedAlternative
        /// 투명 배경 색상
        case backgroundTransparent
        /// 투명 대체 배경 색상
        case backgroundTransparentAlternative
        
        /// 비활성화된 상호작용 색상
        case interactionInactive
        /// 비활성화된 상호작용 색상
        case interactionDisable

        /// 기본 선 색상
        case lineNormal
        /// 중립적인 선 색상
        case lineNeutral
        /// 대체 선 색상
        case lineAlternative
        /// 기본 실선 색상
        case lineSolidNormal
        /// 중립적인 실선 색상
        case lineSolidNeutral
        /// 대체 실선 색상
        case lineSolidAlternative

        /// 긍정적인 상태 색상
        case statusPositive
        /// 주의 상태 색상
        case statusCautionary
        /// 부정적인 상태 색상
        case statusNegative

        /// 빨간색 강조 전경 색상
        case accentForegroundRed
        /// 붉은 주황색 강조 전경 색상
        case accentForegroundRedOrange
        /// 주황색 강조 전경 색상
        case accentForegroundOrange
        /// 라임색 강조 전경 색상
        case accentForegroundLime
        /// 초록색 강조 전경 색상
        case accentForegroundGreen
        /// 시안색 강조 전경 색상
        case accentForegroundCyan
        /// 하늘색 강조 전경 색상
        case accentForegroundLightBlue
        /// 파란색 강조 전경 색상
        case accentForegroundBlue
        /// 보라색 강조 전경 색상
        case accentForegroundViolet
        /// 자주색 강조 전경 색상
        case accentForegroundPurple
        /// 분홍색 강조 전경 색상
        case accentForegroundPink
        /// 붉은 주황색 강조 배경 색상
        case accentBackgroundRedOrange
        /// 라임색 강조 배경 색상
        case accentBackgroundLime
        /// 시안색 강조 배경 색상
        case accentBackgroundCyan
        /// 하늘색 강조 배경 색상
        case accentBackgroundLightBlue
        /// 보라색 강조 배경 색상
        case accentBackgroundViolet
        /// 자주색 강조 배경 색상
        case accentBackgroundPurple
        /// 분홍색 강조 배경 색상
        case accentBackgroundPink

        /// 역전된 주요 색상
        case inversePrimary
        /// 역전된 배경 색상
        case inverseBackground
        /// 역전된 라벨 색상
        case inverseLabel

        /// 기본 채우기 색상
        case fillNormal
        /// 강조된 채우기 색상
        case fillStrong
        /// 대체 채우기 색상
        case fillAlternative
        /// 어두운 재질 색상
        case materialDimmer
        
        /// 주어진 UITraitCollection에 따라 UIColor를 반환합니다.
        ///
        /// - Parameter traitCollection: 색상을 해석할 UITraitCollection
        /// - Returns: 해석된 UIColor 인스턴스
        public func resolve(_ traitCollection: UITraitCollection) -> UIColor {
            let style = traitCollection.userInterfaceStyle
            let atomicColor: Color.Atomic
            var opacity: Opacity = .p100
            
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
            case .backgroundTransparent:
                atomicColor = style == .dark ? .coolNeutral17 : .common100
                opacity = style == .dark ? .p061 : .p008
            case .backgroundTransparentAlternative:
                atomicColor = style == .dark ? .coolNeutral17 : .common100
                opacity = style == .dark ? .p061 : .p028
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
            
            return .load(name: atomicColor.rawValue).withAlphaComponent(.opacity(opacity))
        }
    }
}

// MARK: - UIKit Color Extensions
extension UIColor {
    static func load(name: String) -> UIColor {
        .init(named: name, in: Bundle.module, compatibleWith: nil) ?? .clear
    }

    /// Atomic 색상 타입에 해당하는 UIColor를 생성합니다.
    ///
    /// - Parameter type: 생성할 Atomic 색상 타입
    /// - Returns: 동적으로 생성된 UIColor 인스턴스
    public static func atomic(_ type: Color.Atomic) -> UIColor {
        .init(dynamicProvider: type.resolve)
    }

    /// Semantic 색상 타입에 해당하는 UIColor를 생성합니다.
    ///
    /// - Parameter type: 생성할 Semantic 색상 타입
    /// - Returns: 동적으로 생성된 UIColor 인스턴스
    public static func semantic(_ type: Color.Semantic) -> UIColor {
        .init(dynamicProvider: type.resolve)
    }
}

extension UIColor {
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat) -> UIColor {
        UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - SwiftUI Color Extensions
extension SwiftUI.Color {
    private static func load(name: String) -> SwiftUI.Color {
        .init(UIColor(named: name, in: Bundle.module, compatibleWith: nil)!)
    }

    /// Atomic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.
    ///
    /// - Parameter type: 생성할 Atomic 색상 타입
    /// - Returns: 동적으로 생성된 SwiftUI.Color 인스턴스
    public static func atomic(_ type: Color.Atomic) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.atomic(type))
    }

    /// Semantic 색상 타입에 해당하는 SwiftUI.Color를 생성합니다.
    ///
    /// - Parameter type: 생성할 Semantic 색상 타입
    /// - Returns: 동적으로 생성된 SwiftUI.Color 인스턴스
    public static func semantic(_ type: Color.Semantic) -> SwiftUI.Color {
        SwiftUI.Color(UIColor.semantic(type))
    }
}

extension SwiftUI.Color {
    /// SwiftUI.Color를 UIColor로 변환합니다.
    ///
    /// - Returns: 변환된 UIColor 인스턴스
    public var uiColor: UIColor {
        UIColor(self)
    }
}

protocol ColorResolvable {
    func resolve(_ traitCollection: UITraitCollection) -> UIColor
}
