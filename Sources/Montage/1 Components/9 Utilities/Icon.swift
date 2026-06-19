//
//  Icon.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//
import Foundation
import SwiftUI
import UIKit

/// Montage 디자인 시스템의 아이콘 세트
///
/// Icon은 Montage 디자인 시스템에서 사용 가능한 모든 아이콘을 정의합니다.
/// 각 아이콘은 전체 앱에서 일관된 방식으로 시각적 요소를 표현하기 위해 
/// 사용됩니다. 아이콘은 크기 및 색상을 조정할 수 있습니다.
///
/// ```swift
/// // UIKit에서 사용
/// let imageView = UIImageView()
/// imageView.image = UIImage.icon(.home)
///
/// // SwiftUI에서 사용
/// Image.icon(.heart)
///     .foregroundColor(.red)
///     .frame(width: 24, height: 24)
///
/// // 버튼에 아이콘 사용
/// Button(action: {}) {
///     Image.icon(.download)
/// }
/// ```
///
/// - Note: Fill로 끝나는 아이콘 이름은 채워진 스타일의 아이콘을 나타냅니다.
/// 동일한 아이콘의 윤곽선 버전과 채워진 버전이 모두 제공되는 경우가 많습니다.
public enum Icon: String, CaseIterable {
    case agent
    case agentColor
    case agentSearch
    case aiReview
    case alignCenter
    case alignJustify
    case alignLeft
    case alignRight
    case android
    case apps
    case arrowDown
    case arrowDownThick
    case arrowLeft
    case arrowLeftThick
    case arrowRight
    case arrowRightThick
    case arrowTurnDownLeft
    case arrowTurnDownRight
    case arrowUp
    case arrowUpRight
    case arrowUpRightThick
    case arrowUpThick
    case attachment
    case bell
    case bellFill
    case bellPlus
    case blank
    case blankColor
    case bold
    case book
    case bookFill
    case bookmark
    case bookmarkFill
    case bubble
    case bubbleFill
    case bubblePlus
    case bubblePlusFill
    case bulb
    case bulbFill
    case businessBag
    case businessBagFill
    case calendar
    case calendarFill
    case calendarPerson
    case camera
    case cameraFill
    case caretDown
    case caretUp
    case certificate
    case change
    case chat
    case check
    case checkThick
    case chevronDoubleLeft
    case chevronDoubleLeftSmall
    case chevronDoubleLeftThick
    case chevronDoubleLeftThickSmall
    case chevronDoubleRight
    case chevronDoubleRightSmall
    case chevronDoubleRightThick
    case chevronDoubleRightThickSmall
    case chevronDown
    case chevronDownSmall
    case chevronDownThick
    case chevronDownThickSmall
    case chevronLeft
    case chevronLeftSmall
    case chevronLeftThick
    case chevronLeftThickSmall
    case chevronLeftTight
    case chevronLeftTightSmall
    case chevronLeftTightThick
    case chevronLeftTightThickSmall
    case chevronRight
    case chevronRightSmall
    case chevronRightThick
    case chevronRightThickSmall
    case chevronRightTight
    case chevronRightTightSmall
    case chevronRightTightThick
    case chevronRightTightThickSmall
    case chevronUp
    case chevronUpSmall
    case chevronUpThick
    case chevronUpThickSmall
    case circle
    case circleBlock
    case circleCheck
    case circleCheckFill
    case circleCheckOpaque
    case circleClose
    case circleCloseFill
    case circleCloseOpaque
    case circleDot
    case circleExclamation
    case circleExclamationFill
    case circleExclamationOpaque
    case circleFill
    case circleInfo
    case circleInfoFill
    case circleInfoOpaque
    case circlePlus
    case circlePlusFill
    case circlePlusOpaque
    case circlePoint
    case circlePointFill
    case circleQuestion
    case circleQuestionFill
    case circleQuestionOpaque
    case circleUpRight
    case circleUpRightFill
    case clock
    case clockFill
    case close
    case closeThick
    case code
    case coffee
    case coffeeFill
    case coins
    case coinsFill
    case column
    case company
    case companyCheck
    case companyCheckFill
    case companyFill
    case companyPlus
    case companyPlusFill
    case compass
    case compassFill
    case component
    case componentFill
    case copy
    case crop
    case crown
    case crownFill
    case deepSearch
    case desktop
    case desktopFill
    case diamond
    case diamondFill
    case dislike
    case dislikeFill
    case document
    case documentFill
    case documentPerson
    case documentPersonFill
    case documentSearch
    case documentText
    case documentTextFill
    case dot
    case download
    case exclamation
    case externalLink
    case eye
    case eyeFill
    case eyeSlash
    case eyeSlashFill
    case faceSmile
    case faceSmileFill
    case filter
    case filterFill
    case fire
    case fireFill
    case flag
    case flagFill
    case flip
    case flipBackward
    case folder
    case folderFill
    case folderJob
    case folderJobFill
    case folderStar
    case folderStarFill
    case full
    case globe
    case globeFill
    case graduation
    case graduationFill
    case handle
    case handleDesktop
    case heart
    case heartFill
    case heartInHeart
    case heartInHeartFill
    case history
    case home
    case homeFill
    case hourglass
    case image
    case imageFill
    case inbox
    case instance
    case keyboard
    case leftSide
    case like
    case likeFill
    case lineHorizontal
    case lineHorizontalThick
    case link
    case list
    case listCategory
    case listOrdered
    case location
    case locationFill
    case lock
    case lockFill
    case lockOpen
    case lockOpenFill
    case login
    case logoApple
    case logoAppleColor
    case logoBrunch
    case logoFacebook
    case logoFacebookColor
    case logoGoogleColor
    case logoGooglePlay
    case logoGooglePlayColor
    case logoInstagram
    case logoInstagramColor
    case logoKakao
    case logoKakaoColor
    case logoLinkedIn
    case logoLinkedInColor
    case logoMicrosoft
    case logoMicrosoftColor
    case logoNaverBlog
    case logoNaverBlogColor
    case logoX
    case logoYoutube
    case logoYoutubeColor
    case logout
    case magicWand
    case mail
    case mailOpen
    case medal
    case megaphone
    case megaphoneFill
    case menu
    case menuThick
    case message
    case messageFill
    case microphone
    case microphoneFill
    case microphoneSlash
    case microphoneSlashFill
    case minus
    case minusThick
    case mobile
    case mobileFill
    case moon
    case moreHorizontal
    case moreVertical
    case moreVerticalTight
    case musicMicrophone
    case navigationCareer
    case navigationMenu
    case navigationMypage
    case navigationRecruit
    case navigationSocial
    case palette
    case paletteFill
    case passport
    case passportFill
    case pause
    case pencil
    case pencilFill
    case person
    case personFill
    case personPlus
    case personPlusFill
    case persons
    case personsFill
    case phone
    case phoneFill
    case pin
    case pinFill
    case play
    case plus
    case plusThick
    case positionReview
    case pouch
    case pouchFill
    case presentation
    case printer
    case question
    case quote
    case refresh
    case regex
    case replace
    case replaceAll
    case reset
    case rightSide
    case rotate
    case search
    case searchThick
    case send
    case sendFill
    case setting
    case share
    case shareIos
    case sparkle
    case sparkleFill
    case square
    case squareCaret
    case squareCheck
    case squareFill
    case squareHan
    case squareHangul
    case squareKana
    case squareLatin
    case squareLatinFill
    case squareMore
    case squarePlay
    case squarePlus
    case squarePlusFill
    case star
    case starFill
    case storage
    case strikethrough
    case sun
    case tag
    case tagFill
    case telescope
    case template
    case templateFill
    case textFormat
    case textVariable
    case thumbnail
    case thunder
    case thunderFill
    case ticket
    case ticketFill
    case trash
    case triangle
    case triangleExclamation
    case triangleExclamationFill
    case triangleFill
    case trophy
    case trophyFill
    case tune
    case umbrella
    case umbrellaFill
    case underline
    case upload
    case utility
    case utilityFill
    case verifiedCheck
    case verifiedCheckFill
    case verifiedStar
    case verifiedStarFill
    case video
    case webinar
    case wholeWord
    case write
    case zepFast
    case zepFastFill
}

// MARK: - UIKit Extensions
extension UIImage {
    /// Montage 디자인 시스템의 아이콘을 생성합니다.
    ///
    /// - `color`가 없으면: `renderingMode`에 따라 `.alwaysTemplate`(`foregroundColor`로 틴트) 또는 `.alwaysOriginal`(원본 색)로 동작합니다.
    /// - `color`가 있으면: 해당 색으로 틴트한 한 장의 Image를 만듭니다. 일반 아이콘은 전체가 `color`로 칠해지고, `Opaque` 아이콘(흰색·검은색·투명 혼합)은 검은 영역만 `color`로 치환하고 흰색·투명 영역은 유지합니다.
    ///
    /// - Parameters:
    ///   - type: 생성할 아이콘 타입
    ///   - renderingMode: `color`가 없을 때의 렌더링 모드 (기본 `.alwaysTemplate`)
    ///   - color: 틴트 색. 지정하면 `renderingMode`와 무관하게 색이 적용됩니다.
    /// - Returns: 생성된 UIImage 인스턴스
    public static func icon(
        _ type: Icon,
        renderingMode: RenderingMode = .alwaysTemplate,
        color: UIColor? = nil
    ) -> UIImage {
        guard let color else {
            return load(name: type.rawValue).withRenderingMode(renderingMode)
        }
        return tintedImage(name: type.rawValue, color: color)
    }
    
    /// 틴트 합성 결과를 캐시한다. `body` 재평가마다 래스터화가 반복되는 것을 막기 위한 것으로,
    /// 같은 (이름·색·인터페이스 스타일) 입력에 대해 결과가 결정적이므로 안전하게 재사용된다.
    private static let tintedImageCache = NSCache<NSString, UIImage>()
    
    /// 아이콘을 `color`로 틴트한 한 장의 UIImage로 합성합니다.
    ///
    /// 원본(`base`) 위에 `color`로 틴트한 실루엣을 덮습니다. 틴트 대상은 이름의 `Opaque`를 `Fill`로 치환한 에셋이며,
    /// `Opaque` 아이콘은 검은 영역만 가리키는 별도 `Fill` 실루엣이 덮여 흰색 영역이 보존되고,
    /// 그 외 아이콘은 이름이 그대로라 자기 자신이 덮여 전체가 `color`로 칠해집니다.
    fileprivate static func tintedImage(name: String, color: UIColor) -> UIImage {
        // 캐시 키와 에셋 로딩이 동일한 trait를 보도록 현재 trait를 한 번만 캡처한다.
        // (로딩에 nil을 넘기면 키는 current 기준인데 실제 선택 에셋은 시스템 기본 trait를 따라 불일치할 수 있다.)
        let traits = UITraitCollection.current
        let cacheKey = "\(name)|\(color)|\(traits.userInterfaceStyle.rawValue)" as NSString
        if let cached = tintedImageCache.object(forKey: cacheKey) {
            return cached
        }

        let base = UIImage.load(name: name, compatibleWith: traits)
        let tintIconName = name.replacingOccurrences(of: "Opaque", with: "Fill")
        let tint = UIImage.load(name: tintIconName, compatibleWith: traits).withTintColor(color, renderingMode: .alwaysOriginal)
        
        let format = UIGraphicsImageRendererFormat.preferred()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: base.size, format: format)
        let composite = renderer.image { _ in
            let rect = CGRect(origin: .zero, size: base.size)
            // base는 흰색·검은색이 섞인 원본일 수 있으므로 template 마스크가 아닌 원본 색으로 그린다.
            base.withRenderingMode(.alwaysOriginal).draw(in: rect)
            tint.draw(in: rect)
        }
            .withRenderingMode(.alwaysOriginal)
        
        tintedImageCache.setObject(composite, forKey: cacheKey)
        return composite
    }
}

// MARK: - SwiftUI Extensions
extension Image {
    /// Montage 디자인 시스템의 아이콘을 생성합니다.
    ///
    /// - `color`가 없으면: `renderingMode`에 따라 `.template`(`foregroundColor`로 틴트) 또는 `.original`(원본 색)로 동작합니다.
    /// - `color`가 있으면: 해당 색으로 틴트한 한 장의 Image를 만듭니다. 일반 아이콘은 전체가 `color`로 칠해지고, `Opaque` 아이콘(흰색·검은색·투명 혼합)은 검은 영역만 `color`로 치환하고 흰색·투명 영역은 유지합니다.
    ///
    /// - Parameters:
    ///   - type: 생성할 아이콘 타입
    ///   - renderingMode: `color`가 없을 때의 렌더링 모드 (기본 `.template`)
    ///   - color: 틴트 색. 지정하면 `renderingMode`와 무관하게 색이 적용됩니다.
    /// - Returns: 생성된 Image 인스턴스
    public static func icon(
        _ type: Icon,
        renderingMode: TemplateRenderingMode = .template,
        color: SwiftUI.Color? = nil
    ) -> Image {
        guard let color else {
            return load(name: type.rawValue).renderingMode(renderingMode)
        }
        return Image(uiImage: UIImage.tintedImage(name: type.rawValue, color: color.uiColor))
    }
}
