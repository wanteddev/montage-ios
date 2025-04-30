**ENUM**

# `Icon`

```swift
public enum Icon: String, CaseIterable
```

Montage 디자인 시스템의 아이콘 세트

Icon은 Montage 디자인 시스템에서 사용 가능한 모든 아이콘을 정의합니다.
각 아이콘은 전체 앱에서 일관된 방식으로 시각적 요소를 표현하기 위해 
사용됩니다. 아이콘은 크기 및 색상을 조정할 수 있습니다.

**사용 예시**:
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

- Note: Fill로 끝나는 아이콘 이름은 채워진 스타일의 아이콘을 나타냅니다.
동일한 아이콘의 윤곽선 버전과 채워진 버전이 모두 제공되는 경우가 많습니다.

## Cases
### `alignCenter`

```swift
case alignCenter
```

### `alignJustify`

```swift
case alignJustify
```

### `alignLeft`

```swift
case alignLeft
```

### `alignRight`

```swift
case alignRight
```

### `android`

```swift
case android
```

### `apps`

```swift
case apps
```

### `arrowDown`

```swift
case arrowDown
```

### `arrowDownThick`

```swift
case arrowDownThick
```

### `arrowLeft`

```swift
case arrowLeft
```

### `arrowLeftThick`

```swift
case arrowLeftThick
```

### `arrowRight`

```swift
case arrowRight
```

### `arrowRightThick`

```swift
case arrowRightThick
```

### `arrowTurnDownLeft`

```swift
case arrowTurnDownLeft
```

### `arrowTurnDownRight`

```swift
case arrowTurnDownRight
```

### `arrowUp`

```swift
case arrowUp
```

### `arrowUpThick`

```swift
case arrowUpThick
```

### `attachment`

```swift
case attachment
```

### `bell`

```swift
case bell
```

### `bellFill`

```swift
case bellFill
```

### `bellPlus`

```swift
case bellPlus
```

### `blank`

```swift
case blank
```

### `blankColor`

```swift
case blankColor
```

### `bold`

```swift
case bold
```

### `book`

```swift
case book
```

### `bookFill`

```swift
case bookFill
```

### `bookmark`

```swift
case bookmark
```

### `bookmarkFill`

```swift
case bookmarkFill
```

### `bubble`

```swift
case bubble
```

### `bubbleFill`

```swift
case bubbleFill
```

### `bubblePlus`

```swift
case bubblePlus
```

### `bubblePlusFill`

```swift
case bubblePlusFill
```

### `bulb`

```swift
case bulb
```

### `businessBag`

```swift
case businessBag
```

### `businessBagFill`

```swift
case businessBagFill
```

### `calendar`

```swift
case calendar
```

### `calendarPerson`

```swift
case calendarPerson
```

### `camera`

```swift
case camera
```

### `cameraFill`

```swift
case cameraFill
```

### `caretDown`

```swift
case caretDown
```

### `caretUp`

```swift
case caretUp
```

### `certificate`

```swift
case certificate
```

### `change`

```swift
case change
```

### `chat`

```swift
case chat
```

### `check`

```swift
case check
```

### `checkThick`

```swift
case checkThick
```

### `chevronDoubleLeft`

```swift
case chevronDoubleLeft
```

### `chevronDoubleLeftSmall`

```swift
case chevronDoubleLeftSmall
```

### `chevronDoubleLeftThick`

```swift
case chevronDoubleLeftThick
```

### `chevronDoubleLeftThickSmall`

```swift
case chevronDoubleLeftThickSmall
```

### `chevronDoubleRight`

```swift
case chevronDoubleRight
```

### `chevronDoubleRightSmall`

```swift
case chevronDoubleRightSmall
```

### `chevronDoubleRightThick`

```swift
case chevronDoubleRightThick
```

### `chevronDoubleRightThickSmall`

```swift
case chevronDoubleRightThickSmall
```

### `chevronDown`

```swift
case chevronDown
```

### `chevronDownSmall`

```swift
case chevronDownSmall
```

### `chevronDownThick`

```swift
case chevronDownThick
```

### `chevronDownThickSmall`

```swift
case chevronDownThickSmall
```

### `chevronLeft`

```swift
case chevronLeft
```

### `chevronLeftSmall`

```swift
case chevronLeftSmall
```

### `chevronLeftThick`

```swift
case chevronLeftThick
```

### `chevronLeftThickSmall`

```swift
case chevronLeftThickSmall
```

### `chevronLeftTight`

```swift
case chevronLeftTight
```

### `chevronLeftTightSmall`

```swift
case chevronLeftTightSmall
```

### `chevronLeftTightThick`

```swift
case chevronLeftTightThick
```

### `chevronLeftTightThickSmall`

```swift
case chevronLeftTightThickSmall
```

### `chevronRight`

```swift
case chevronRight
```

### `chevronRightSmall`

```swift
case chevronRightSmall
```

### `chevronRightThick`

```swift
case chevronRightThick
```

### `chevronRightThickSmall`

```swift
case chevronRightThickSmall
```

### `chevronRightTight`

```swift
case chevronRightTight
```

### `chevronRightTightSmall`

```swift
case chevronRightTightSmall
```

### `chevronRightTightThick`

```swift
case chevronRightTightThick
```

### `chevronRightTightThickSmall`

```swift
case chevronRightTightThickSmall
```

### `chevronUp`

```swift
case chevronUp
```

### `chevronUpSmall`

```swift
case chevronUpSmall
```

### `chevronUpThick`

```swift
case chevronUpThick
```

### `chevronUpThickSmall`

```swift
case chevronUpThickSmall
```

### `circle`

```swift
case circle
```

### `circleBlock`

```swift
case circleBlock
```

### `circleCheck`

```swift
case circleCheck
```

### `circleCheckFill`

```swift
case circleCheckFill
```

### `circleClose`

```swift
case circleClose
```

### `circleCloseFill`

```swift
case circleCloseFill
```

### `circleDot`

```swift
case circleDot
```

### `circleExclamation`

```swift
case circleExclamation
```

### `circleExclamationFill`

```swift
case circleExclamationFill
```

### `circleFill`

```swift
case circleFill
```

### `circleInfo`

```swift
case circleInfo
```

### `circleInfoFill`

```swift
case circleInfoFill
```

### `circlePlus`

```swift
case circlePlus
```

### `circlePlusFill`

```swift
case circlePlusFill
```

### `circlePoint`

```swift
case circlePoint
```

### `circleQuestion`

```swift
case circleQuestion
```

### `circleQuestionFill`

```swift
case circleQuestionFill
```

### `clock`

```swift
case clock
```

### `clockFill`

```swift
case clockFill
```

### `close`

```swift
case close
```

### `closeThick`

```swift
case closeThick
```

### `code`

```swift
case code
```

### `coffee`

```swift
case coffee
```

### `coffeeFill`

```swift
case coffeeFill
```

### `coins`

```swift
case coins
```

### `coinsFill`

```swift
case coinsFill
```

### `column`

```swift
case column
```

### `company`

```swift
case company
```

### `companyCheck`

```swift
case companyCheck
```

### `companyCheckFill`

```swift
case companyCheckFill
```

### `companyFill`

```swift
case companyFill
```

### `companyPlus`

```swift
case companyPlus
```

### `companyPlusFill`

```swift
case companyPlusFill
```

### `compass`

```swift
case compass
```

### `compassFill`

```swift
case compassFill
```

### `component`

```swift
case component
```

### `componentFill`

```swift
case componentFill
```

### `copy`

```swift
case copy
```

### `crown`

```swift
case crown
```

### `crownFill`

```swift
case crownFill
```

### `desktop`

```swift
case desktop
```

### `desktopFill`

```swift
case desktopFill
```

### `diamond`

```swift
case diamond
```

### `diamondFill`

```swift
case diamondFill
```

### `dislike`

```swift
case dislike
```

### `dislikeFill`

```swift
case dislikeFill
```

### `document`

```swift
case document
```

### `documentFill`

```swift
case documentFill
```

### `documentPerson`

```swift
case documentPerson
```

### `documentPersonFill`

```swift
case documentPersonFill
```

### `documentSearch`

```swift
case documentSearch
```

### `documentText`

```swift
case documentText
```

### `documentTextFill`

```swift
case documentTextFill
```

### `dot`

```swift
case dot
```

### `download`

```swift
case download
```

### `exclamation`

```swift
case exclamation
```

### `externalLink`

```swift
case externalLink
```

### `eye`

```swift
case eye
```

### `eyeFill`

```swift
case eyeFill
```

### `eyeSlash`

```swift
case eyeSlash
```

### `eyeSlashFill`

```swift
case eyeSlashFill
```

### `faceSmile`

```swift
case faceSmile
```

### `faceSmileFill`

```swift
case faceSmileFill
```

### `filter`

```swift
case filter
```

### `filterFill`

```swift
case filterFill
```

### `fire`

```swift
case fire
```

### `fireFill`

```swift
case fireFill
```

### `flag`

```swift
case flag
```

### `flipBackward`

```swift
case flipBackward
```

### `folder`

```swift
case folder
```

### `folderFill`

```swift
case folderFill
```

### `folderJob`

```swift
case folderJob
```

### `folderJobFill`

```swift
case folderJobFill
```

### `folderStar`

```swift
case folderStar
```

### `folderStarFill`

```swift
case folderStarFill
```

### `full`

```swift
case full
```

### `globe`

```swift
case globe
```

### `graduation`

```swift
case graduation
```

### `graduationFill`

```swift
case graduationFill
```

### `handle`

```swift
case handle
```

### `handleDesktop`

```swift
case handleDesktop
```

### `heart`

```swift
case heart
```

### `heartFill`

```swift
case heartFill
```

### `heartInHeart`

```swift
case heartInHeart
```

### `heartInHeartFill`

```swift
case heartInHeartFill
```

### `history`

```swift
case history
```

### `home`

```swift
case home
```

### `homeFill`

```swift
case homeFill
```

### `hourglass`

```swift
case hourglass
```

### `image`

```swift
case image
```

### `inbox`

```swift
case inbox
```

### `instance`

```swift
case instance
```

### `keyboard`

```swift
case keyboard
```

### `like`

```swift
case like
```

### `likeFill`

```swift
case likeFill
```

### `lineHorizontal`

```swift
case lineHorizontal
```

### `lineHorizontalThick`

```swift
case lineHorizontalThick
```

### `link`

```swift
case link
```

### `list`

```swift
case list
```

### `listCategory`

```swift
case listCategory
```

### `listOrdered`

```swift
case listOrdered
```

### `location`

```swift
case location
```

### `locationFill`

```swift
case locationFill
```

### `lock`

```swift
case lock
```

### `lockFill`

```swift
case lockFill
```

### `lockOpen`

```swift
case lockOpen
```

### `lockOpenFill`

```swift
case lockOpenFill
```

### `login`

```swift
case login
```

### `logoApple`

```swift
case logoApple
```

### `logoAppleColor`

```swift
case logoAppleColor
```

### `logoBrunch`

```swift
case logoBrunch
```

### `logoFacebook`

```swift
case logoFacebook
```

### `logoFacebookColor`

```swift
case logoFacebookColor
```

### `logoGoogleColor`

```swift
case logoGoogleColor
```

### `logoGooglePlay`

```swift
case logoGooglePlay
```

### `logoGooglePlayColor`

```swift
case logoGooglePlayColor
```

### `logoInstagram`

```swift
case logoInstagram
```

### `logoInstagramColor`

```swift
case logoInstagramColor
```

### `logoKakao`

```swift
case logoKakao
```

### `logoKakaoColor`

```swift
case logoKakaoColor
```

### `logoLinkedIn`

```swift
case logoLinkedIn
```

### `logoLinkedInColor`

```swift
case logoLinkedInColor
```

### `logoMicrosoft`

```swift
case logoMicrosoft
```

### `logoMicrosoftColor`

```swift
case logoMicrosoftColor
```

### `logoNaverBlog`

```swift
case logoNaverBlog
```

### `logoNaverBlogColor`

```swift
case logoNaverBlogColor
```

### `logoX`

```swift
case logoX
```

### `logoYoutube`

```swift
case logoYoutube
```

### `logoYoutubeColor`

```swift
case logoYoutubeColor
```

### `logout`

```swift
case logout
```

### `magicWand`

```swift
case magicWand
```

### `mail`

```swift
case mail
```

### `mailOpen`

```swift
case mailOpen
```

### `medal`

```swift
case medal
```

### `megaphone`

```swift
case megaphone
```

### `megaphoneFill`

```swift
case megaphoneFill
```

### `menu`

```swift
case menu
```

### `menuThick`

```swift
case menuThick
```

### `message`

```swift
case message
```

### `messageFill`

```swift
case messageFill
```

### `microphone`

```swift
case microphone
```

### `microphoneFill`

```swift
case microphoneFill
```

### `microphoneSlash`

```swift
case microphoneSlash
```

### `microphoneSlashFill`

```swift
case microphoneSlashFill
```

### `minus`

```swift
case minus
```

### `minusThick`

```swift
case minusThick
```

### `mobile`

```swift
case mobile
```

### `mobileFill`

```swift
case mobileFill
```

### `moon`

```swift
case moon
```

### `moreHorizontal`

```swift
case moreHorizontal
```

### `moreVertical`

```swift
case moreVertical
```

### `moreVerticalTight`

```swift
case moreVerticalTight
```

### `musicMicrophone`

```swift
case musicMicrophone
```

### `navigationCareer`

```swift
case navigationCareer
```

### `navigationMenu`

```swift
case navigationMenu
```

### `navigationMypage`

```swift
case navigationMypage
```

### `navigationRecruit`

```swift
case navigationRecruit
```

### `navigationSocial`

```swift
case navigationSocial
```

### `pause`

```swift
case pause
```

### `pencil`

```swift
case pencil
```

### `pencilFill`

```swift
case pencilFill
```

### `person`

```swift
case person
```

### `personFill`

```swift
case personFill
```

### `personPlus`

```swift
case personPlus
```

### `personPlusFill`

```swift
case personPlusFill
```

### `persons`

```swift
case persons
```

### `personsFill`

```swift
case personsFill
```

### `phone`

```swift
case phone
```

### `phoneFill`

```swift
case phoneFill
```

### `pin`

```swift
case pin
```

### `pinFill`

```swift
case pinFill
```

### `play`

```swift
case play
```

### `plus`

```swift
case plus
```

### `plusThick`

```swift
case plusThick
```

### `presentation`

```swift
case presentation
```

### `printer`

```swift
case printer
```

### `question`

```swift
case question
```

### `quote`

```swift
case quote
```

### `refresh`

```swift
case refresh
```

### `reset`

```swift
case reset
```

### `search`

```swift
case search
```

### `searchThick`

```swift
case searchThick
```

### `send`

```swift
case send
```

### `sendFill`

```swift
case sendFill
```

### `setting`

```swift
case setting
```

### `share`

```swift
case share
```

### `shareIos`

```swift
case shareIos
```

### `sparkle`

```swift
case sparkle
```

### `sparkleFill`

```swift
case sparkleFill
```

### `square`

```swift
case square
```

### `squareCaret`

```swift
case squareCaret
```

### `squareCheck`

```swift
case squareCheck
```

### `squareFill`

```swift
case squareFill
```

### `squareHan`

```swift
case squareHan
```

### `squareHangul`

```swift
case squareHangul
```

### `squareKana`

```swift
case squareKana
```

### `squareLatin`

```swift
case squareLatin
```

### `squareMore`

```swift
case squareMore
```

### `squarePlay`

```swift
case squarePlay
```

### `squarePlus`

```swift
case squarePlus
```

### `squarePlusFill`

```swift
case squarePlusFill
```

### `star`

```swift
case star
```

### `starFill`

```swift
case starFill
```

### `strikethrough`

```swift
case strikethrough
```

### `sun`

```swift
case sun
```

### `tag`

```swift
case tag
```

### `tagFill`

```swift
case tagFill
```

### `template`

```swift
case template
```

### `templateFill`

```swift
case templateFill
```

### `textFormat`

```swift
case textFormat
```

### `textVariable`

```swift
case textVariable
```

### `thumbnail`

```swift
case thumbnail
```

### `thunder`

```swift
case thunder
```

### `thunderFill`

```swift
case thunderFill
```

### `ticket`

```swift
case ticket
```

### `ticketFill`

```swift
case ticketFill
```

### `trash`

```swift
case trash
```

### `triangle`

```swift
case triangle
```

### `triangleExclamation`

```swift
case triangleExclamation
```

### `triangleExclamationFill`

```swift
case triangleExclamationFill
```

### `triangleFill`

```swift
case triangleFill
```

### `trophy`

```swift
case trophy
```

### `trophyFill`

```swift
case trophyFill
```

### `tune`

```swift
case tune
```

### `umbrella`

```swift
case umbrella
```

### `umbrellaFill`

```swift
case umbrellaFill
```

### `underline`

```swift
case underline
```

### `upload`

```swift
case upload
```

### `verifiedCheck`

```swift
case verifiedCheck
```

### `verifiedCheckFill`

```swift
case verifiedCheckFill
```

### `verifiedStar`

```swift
case verifiedStar
```

### `verifiedStarFill`

```swift
case verifiedStarFill
```

### `video`

```swift
case video
```

### `webinar`

```swift
case webinar
```

### `write`

```swift
case write
```

## Properties
<details><summary markdown="span"><code>name</code></summary>

```swift
public var name: String
```

아이콘의 리소스 이름을 반환합니다.

</details>
