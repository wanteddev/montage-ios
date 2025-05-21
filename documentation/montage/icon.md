---
title: Icon
description: Montage 디자인 시스템의 아이콘 세트
---

```swift
enum Icon
```

## Overview

Icon은 Montage 디자인 시스템에서 사용 가능한 모든 아이콘을 정의합니다. 각 아이콘은 전체 앱에서 일관된 방식으로 시각적 요소를 표현하기 위해 사용됩니다. 아이콘은 크기 및 색상을 조정할 수 있습니다.

```swift
// UIKit에서 사용
let imageView = UIImageView()
imageView.image = UIImage.montage(.home)

// SwiftUI에서 사용
Image.montage(.heart)
    .foregroundColor(.red)
    .frame(width: 24, height: 24)

// 버튼에 아이콘 사용
Button(action: {}) {
    Image.montage(.download)
}
```

>  Note
>
> Fill로 끝나는 아이콘 이름은 채워진 스타일의 아이콘을 나타냅니다. 동일한 아이콘의 윤곽선 버전과 채워진 버전이 모두 제공되는 경우가 많습니다.

## Topics

### Enumeration Cases


``case alignCenter``

``case alignJustify``

``case alignLeft``

``case alignRight``

``case android``

``case apps``

``case arrowDown``

``case arrowDownThick``

``case arrowLeft``

``case arrowLeftThick``

``case arrowRight``

``case arrowRightThick``

``case arrowTurnDownLeft``

``case arrowTurnDownRight``

``case arrowUp``

``case arrowUpThick``

``case attachment``

``case bell``

``case bellFill``

``case bellPlus``

``case blank``

``case blankColor``

``case bold``

``case book``

``case bookFill``

``case bookmark``

``case bookmarkFill``

``case bubble``

``case bubbleFill``

``case bubblePlus``

``case bubblePlusFill``

``case bulb``

``case businessBag``

``case businessBagFill``

``case calendar``

``case calendarPerson``

``case camera``

``case cameraFill``

``case caretDown``

``case caretUp``

``case certificate``

``case change``

``case chat``

``case check``

``case checkThick``

``case chevronDoubleLeft``

``case chevronDoubleLeftSmall``

``case chevronDoubleLeftThick``

``case chevronDoubleLeftThickSmall``

``case chevronDoubleRight``

``case chevronDoubleRightSmall``

``case chevronDoubleRightThick``

``case chevronDoubleRightThickSmall``

``case chevronDown``

``case chevronDownSmall``

``case chevronDownThick``

``case chevronDownThickSmall``

``case chevronLeft``

``case chevronLeftSmall``

``case chevronLeftThick``

``case chevronLeftThickSmall``

``case chevronLeftTight``

``case chevronLeftTightSmall``

``case chevronLeftTightThick``

``case chevronLeftTightThickSmall``

``case chevronRight``

``case chevronRightSmall``

``case chevronRightThick``

``case chevronRightThickSmall``

``case chevronRightTight``

``case chevronRightTightSmall``

``case chevronRightTightThick``

``case chevronRightTightThickSmall``

``case chevronUp``

``case chevronUpSmall``

``case chevronUpThick``

``case chevronUpThickSmall``

``case circle``

``case circleBlock``

``case circleCheck``

``case circleCheckFill``

``case circleClose``

``case circleCloseFill``

``case circleDot``

``case circleExclamation``

``case circleExclamationFill``

``case circleFill``

``case circleInfo``

``case circleInfoFill``

``case circlePlus``

``case circlePlusFill``

``case circlePoint``

``case circleQuestion``

``case circleQuestionFill``

``case clock``

``case clockFill``

``case close``

``case closeThick``

``case code``

``case coffee``

``case coffeeFill``

``case coins``

``case coinsFill``

``case column``

``case company``

``case companyCheck``

``case companyCheckFill``

``case companyFill``

``case companyPlus``

``case companyPlusFill``

``case compass``

``case compassFill``

``case component``

``case componentFill``

``case copy``

``case crown``

``case crownFill``

``case desktop``

``case desktopFill``

``case diamond``

``case diamondFill``

``case dislike``

``case dislikeFill``

``case document``

``case documentFill``

``case documentPerson``

``case documentPersonFill``

``case documentSearch``

``case documentText``

``case documentTextFill``

``case dot``

``case download``

``case exclamation``

``case externalLink``

``case eye``

``case eyeFill``

``case eyeSlash``

``case eyeSlashFill``

``case faceSmile``

``case faceSmileFill``

``case filter``

``case filterFill``

``case fire``

``case fireFill``

``case flag``

``case flipBackward``

``case folder``

``case folderFill``

``case folderJob``

``case folderJobFill``

``case folderStar``

``case folderStarFill``

``case full``

``case globe``

``case graduation``

``case graduationFill``

``case handle``

``case handleDesktop``

``case heart``

``case heartFill``

``case heartInHeart``

``case heartInHeartFill``

``case history``

``case home``

``case homeFill``

``case hourglass``

``case image``

``case inbox``

``case instance``

``case keyboard``

``case like``

``case likeFill``

``case lineHorizontal``

``case lineHorizontalThick``

``case link``

``case list``

``case listCategory``

``case listOrdered``

``case location``

``case locationFill``

``case lock``

``case lockFill``

``case lockOpen``

``case lockOpenFill``

``case login``

``case logoApple``

``case logoAppleColor``

``case logoBrunch``

``case logoFacebook``

``case logoFacebookColor``

``case logoGoogleColor``

``case logoGooglePlay``

``case logoGooglePlayColor``

``case logoInstagram``

``case logoInstagramColor``

``case logoKakao``

``case logoKakaoColor``

``case logoLinkedIn``

``case logoLinkedInColor``

``case logoMicrosoft``

``case logoMicrosoftColor``

``case logoNaverBlog``

``case logoNaverBlogColor``

``case logoX``

``case logoYoutube``

``case logoYoutubeColor``

``case logout``

``case magicWand``

``case mail``

``case mailOpen``

``case medal``

``case megaphone``

``case megaphoneFill``

``case menu``

``case menuThick``

``case message``

``case messageFill``

``case microphone``

``case microphoneFill``

``case microphoneSlash``

``case microphoneSlashFill``

``case minus``

``case minusThick``

``case mobile``

``case mobileFill``

``case moon``

``case moreHorizontal``

``case moreVertical``

``case moreVerticalTight``

``case musicMicrophone``

``case navigationCareer``

``case navigationMenu``

``case navigationMypage``

``case navigationRecruit``

``case navigationSocial``

``case pause``

``case pencil``

``case pencilFill``

``case person``

``case personFill``

``case personPlus``

``case personPlusFill``

``case persons``

``case personsFill``

``case phone``

``case phoneFill``

``case pin``

``case pinFill``

``case play``

``case plus``

``case plusThick``

``case presentation``

``case printer``

``case question``

``case quote``

``case refresh``

``case reset``

``case search``

``case searchThick``

``case send``

``case sendFill``

``case setting``

``case share``

``case shareIos``

``case sparkle``

``case sparkleFill``

``case square``

``case squareCaret``

``case squareCheck``

``case squareFill``

``case squareHan``

``case squareHangul``

``case squareKana``

``case squareLatin``

``case squareMore``

``case squarePlay``

``case squarePlus``

``case squarePlusFill``

``case star``

``case starFill``

``case strikethrough``

``case sun``

``case tag``

``case tagFill``

``case template``

``case templateFill``

``case textFormat``

``case textVariable``

``case thumbnail``

``case thunder``

``case thunderFill``

``case ticket``

``case ticketFill``

``case trash``

``case triangle``

``case triangleExclamation``

``case triangleExclamationFill``

``case triangleFill``

``case trophy``

``case trophyFill``

``case tune``

``case umbrella``

``case umbrellaFill``

``case underline``

``case upload``

``case verifiedCheck``

``case verifiedCheckFill``

``case verifiedStar``

``case verifiedStarFill``

``case video``

``case webinar``

``case write``

### Initializers


``init?(rawValue: String)``

### Instance Properties


``var name: String``

아이콘의 리소스 이름을 반환합니다.

### Default Implementations


[Equatable Implementations](/documentation/montage/icon/equatable-implementations.md)

[RawRepresentable Implementations](/documentation/montage/icon/rawrepresentable-implementations.md)

## Relationships

Conforms To

`Swift.CaseIterable`

`Swift.Equatable`

`Swift.Hashable`

`Swift.RawRepresentable`



