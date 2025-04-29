Enumeration

# Icon 

Montage 디자인 시스템의 아이콘 세트

```swift
enum Icon
```

## Overview 

Icon은 Montage 디자인 시스템에서 사용 가능한 모든 아이콘을 정의합니다. 각 아이콘은 전체 앱에서 일관된 방식으로 시각적 요소를 표현하기 위해 사용됩니다. 아이콘은 크기 및 색상을 조정할 수 있습니다.

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

> **Note**
>
> Fill로 끝나는 아이콘 이름은 채워진 스타일의 아이콘을 나타냅니다. 동일한 아이콘의 윤곽선 버전과 채워진 버전이 모두 제공되는 경우가 많습니다.

## Topics 

### Enumeration Cases 

- [case alignCenter](/documentation/montage/icon/aligncenter.md)

- [case alignJustify](/documentation/montage/icon/alignjustify.md)

- [case alignLeft](/documentation/montage/icon/alignleft.md)

- [case alignRight](/documentation/montage/icon/alignright.md)

- [case android](/documentation/montage/icon/android.md)

- [case apps](/documentation/montage/icon/apps.md)

- [case arrowDown](/documentation/montage/icon/arrowdown.md)

- [case arrowDownThick](/documentation/montage/icon/arrowdownthick.md)

- [case arrowLeft](/documentation/montage/icon/arrowleft.md)

- [case arrowLeftThick](/documentation/montage/icon/arrowleftthick.md)

- [case arrowRight](/documentation/montage/icon/arrowright.md)

- [case arrowRightThick](/documentation/montage/icon/arrowrightthick.md)

- [case arrowTurnDownLeft](/documentation/montage/icon/arrowturndownleft.md)

- [case arrowTurnDownRight](/documentation/montage/icon/arrowturndownright.md)

- [case arrowUp](/documentation/montage/icon/arrowup.md)

- [case arrowUpThick](/documentation/montage/icon/arrowupthick.md)

- [case attachment](/documentation/montage/icon/attachment.md)

- [case bell](/documentation/montage/icon/bell.md)

- [case bellFill](/documentation/montage/icon/bellfill.md)

- [case bellPlus](/documentation/montage/icon/bellplus.md)

- [case blank](/documentation/montage/icon/blank.md)

- [case blankColor](/documentation/montage/icon/blankcolor.md)

- [case bold](/documentation/montage/icon/bold.md)

- [case book](/documentation/montage/icon/book.md)

- [case bookFill](/documentation/montage/icon/bookfill.md)

- [case bookmark](/documentation/montage/icon/bookmark.md)

- [case bookmarkFill](/documentation/montage/icon/bookmarkfill.md)

- [case bubble](/documentation/montage/icon/bubble.md)

- [case bubbleFill](/documentation/montage/icon/bubblefill.md)

- [case bubblePlus](/documentation/montage/icon/bubbleplus.md)

- [case bubblePlusFill](/documentation/montage/icon/bubbleplusfill.md)

- [case bulb](/documentation/montage/icon/bulb.md)

- [case businessBag](/documentation/montage/icon/businessbag.md)

- [case businessBagFill](/documentation/montage/icon/businessbagfill.md)

- [case calendar](/documentation/montage/icon/calendar.md)

- [case calendarPerson](/documentation/montage/icon/calendarperson.md)

- [case camera](/documentation/montage/icon/camera.md)

- [case cameraFill](/documentation/montage/icon/camerafill.md)

- [case caretDown](/documentation/montage/icon/caretdown.md)

- [case caretUp](/documentation/montage/icon/caretup.md)

- [case certificate](/documentation/montage/icon/certificate.md)

- [case change](/documentation/montage/icon/change.md)

- [case chat](/documentation/montage/icon/chat.md)

- [case check](/documentation/montage/icon/check.md)

- [case checkThick](/documentation/montage/icon/checkthick.md)

- [case chevronDoubleLeft](/documentation/montage/icon/chevrondoubleleft.md)

- [case chevronDoubleLeftSmall](/documentation/montage/icon/chevrondoubleleftsmall.md)

- [case chevronDoubleLeftThick](/documentation/montage/icon/chevrondoubleleftthick.md)

- [case chevronDoubleLeftThickSmall](/documentation/montage/icon/chevrondoubleleftthicksmall.md)

- [case chevronDoubleRight](/documentation/montage/icon/chevrondoubleright.md)

- [case chevronDoubleRightSmall](/documentation/montage/icon/chevrondoublerightsmall.md)

- [case chevronDoubleRightThick](/documentation/montage/icon/chevrondoublerightthick.md)

- [case chevronDoubleRightThickSmall](/documentation/montage/icon/chevrondoublerightthicksmall.md)

- [case chevronDown](/documentation/montage/icon/chevrondown.md)

- [case chevronDownSmall](/documentation/montage/icon/chevrondownsmall.md)

- [case chevronDownThick](/documentation/montage/icon/chevrondownthick.md)

- [case chevronDownThickSmall](/documentation/montage/icon/chevrondownthicksmall.md)

- [case chevronLeft](/documentation/montage/icon/chevronleft.md)

- [case chevronLeftSmall](/documentation/montage/icon/chevronleftsmall.md)

- [case chevronLeftThick](/documentation/montage/icon/chevronleftthick.md)

- [case chevronLeftThickSmall](/documentation/montage/icon/chevronleftthicksmall.md)

- [case chevronLeftTight](/documentation/montage/icon/chevronlefttight.md)

- [case chevronLeftTightSmall](/documentation/montage/icon/chevronlefttightsmall.md)

- [case chevronLeftTightThick](/documentation/montage/icon/chevronlefttightthick.md)

- [case chevronLeftTightThickSmall](/documentation/montage/icon/chevronlefttightthicksmall.md)

- [case chevronRight](/documentation/montage/icon/chevronright.md)

- [case chevronRightSmall](/documentation/montage/icon/chevronrightsmall.md)

- [case chevronRightThick](/documentation/montage/icon/chevronrightthick.md)

- [case chevronRightThickSmall](/documentation/montage/icon/chevronrightthicksmall.md)

- [case chevronRightTight](/documentation/montage/icon/chevronrighttight.md)

- [case chevronRightTightSmall](/documentation/montage/icon/chevronrighttightsmall.md)

- [case chevronRightTightThick](/documentation/montage/icon/chevronrighttightthick.md)

- [case chevronRightTightThickSmall](/documentation/montage/icon/chevronrighttightthicksmall.md)

- [case chevronUp](/documentation/montage/icon/chevronup.md)

- [case chevronUpSmall](/documentation/montage/icon/chevronupsmall.md)

- [case chevronUpThick](/documentation/montage/icon/chevronupthick.md)

- [case chevronUpThickSmall](/documentation/montage/icon/chevronupthicksmall.md)

- [case circle](/documentation/montage/icon/circle.md)

- [case circleBlock](/documentation/montage/icon/circleblock.md)

- [case circleCheck](/documentation/montage/icon/circlecheck.md)

- [case circleCheckFill](/documentation/montage/icon/circlecheckfill.md)

- [case circleClose](/documentation/montage/icon/circleclose.md)

- [case circleCloseFill](/documentation/montage/icon/circleclosefill.md)

- [case circleDot](/documentation/montage/icon/circledot.md)

- [case circleExclamation](/documentation/montage/icon/circleexclamation.md)

- [case circleExclamationFill](/documentation/montage/icon/circleexclamationfill.md)

- [case circleFill](/documentation/montage/icon/circlefill.md)

- [case circleInfo](/documentation/montage/icon/circleinfo.md)

- [case circleInfoFill](/documentation/montage/icon/circleinfofill.md)

- [case circlePlus](/documentation/montage/icon/circleplus.md)

- [case circlePlusFill](/documentation/montage/icon/circleplusfill.md)

- [case circlePoint](/documentation/montage/icon/circlepoint.md)

- [case circleQuestion](/documentation/montage/icon/circlequestion.md)

- [case circleQuestionFill](/documentation/montage/icon/circlequestionfill.md)

- [case clock](/documentation/montage/icon/clock.md)

- [case clockFill](/documentation/montage/icon/clockfill.md)

- [case close](/documentation/montage/icon/close.md)

- [case closeThick](/documentation/montage/icon/closethick.md)

- [case code](/documentation/montage/icon/code.md)

- [case coffee](/documentation/montage/icon/coffee.md)

- [case coffeeFill](/documentation/montage/icon/coffeefill.md)

- [case coins](/documentation/montage/icon/coins.md)

- [case coinsFill](/documentation/montage/icon/coinsfill.md)

- [case column](/documentation/montage/icon/column.md)

- [case company](/documentation/montage/icon/company.md)

- [case companyCheck](/documentation/montage/icon/companycheck.md)

- [case companyCheckFill](/documentation/montage/icon/companycheckfill.md)

- [case companyFill](/documentation/montage/icon/companyfill.md)

- [case companyPlus](/documentation/montage/icon/companyplus.md)

- [case companyPlusFill](/documentation/montage/icon/companyplusfill.md)

- [case compass](/documentation/montage/icon/compass.md)

- [case compassFill](/documentation/montage/icon/compassfill.md)

- [case component](/documentation/montage/icon/component.md)

- [case componentFill](/documentation/montage/icon/componentfill.md)

- [case copy](/documentation/montage/icon/copy.md)

- [case crown](/documentation/montage/icon/crown.md)

- [case crownFill](/documentation/montage/icon/crownfill.md)

- [case desktop](/documentation/montage/icon/desktop.md)

- [case desktopFill](/documentation/montage/icon/desktopfill.md)

- [case diamond](/documentation/montage/icon/diamond.md)

- [case diamondFill](/documentation/montage/icon/diamondfill.md)

- [case dislike](/documentation/montage/icon/dislike.md)

- [case dislikeFill](/documentation/montage/icon/dislikefill.md)

- [case document](/documentation/montage/icon/document.md)

- [case documentFill](/documentation/montage/icon/documentfill.md)

- [case documentPerson](/documentation/montage/icon/documentperson.md)

- [case documentPersonFill](/documentation/montage/icon/documentpersonfill.md)

- [case documentSearch](/documentation/montage/icon/documentsearch.md)

- [case documentText](/documentation/montage/icon/documenttext.md)

- [case documentTextFill](/documentation/montage/icon/documenttextfill.md)

- [case dot](/documentation/montage/icon/dot.md)

- [case download](/documentation/montage/icon/download.md)

- [case exclamation](/documentation/montage/icon/exclamation.md)

- [case externalLink](/documentation/montage/icon/externallink.md)

- [case eye](/documentation/montage/icon/eye.md)

- [case eyeFill](/documentation/montage/icon/eyefill.md)

- [case eyeSlash](/documentation/montage/icon/eyeslash.md)

- [case eyeSlashFill](/documentation/montage/icon/eyeslashfill.md)

- [case faceSmile](/documentation/montage/icon/facesmile.md)

- [case faceSmileFill](/documentation/montage/icon/facesmilefill.md)

- [case filter](/documentation/montage/icon/filter.md)

- [case filterFill](/documentation/montage/icon/filterfill.md)

- [case fire](/documentation/montage/icon/fire.md)

- [case fireFill](/documentation/montage/icon/firefill.md)

- [case flag](/documentation/montage/icon/flag.md)

- [case flipBackward](/documentation/montage/icon/flipbackward.md)

- [case folder](/documentation/montage/icon/folder.md)

- [case folderFill](/documentation/montage/icon/folderfill.md)

- [case folderJob](/documentation/montage/icon/folderjob.md)

- [case folderJobFill](/documentation/montage/icon/folderjobfill.md)

- [case folderStar](/documentation/montage/icon/folderstar.md)

- [case folderStarFill](/documentation/montage/icon/folderstarfill.md)

- [case full](/documentation/montage/icon/full.md)

- [case globe](/documentation/montage/icon/globe.md)

- [case graduation](/documentation/montage/icon/graduation.md)

- [case graduationFill](/documentation/montage/icon/graduationfill.md)

- [case handle](/documentation/montage/icon/handle.md)

- [case handleDesktop](/documentation/montage/icon/handledesktop.md)

- [case heart](/documentation/montage/icon/heart.md)

- [case heartFill](/documentation/montage/icon/heartfill.md)

- [case heartInHeart](/documentation/montage/icon/heartinheart.md)

- [case heartInHeartFill](/documentation/montage/icon/heartinheartfill.md)

- [case history](/documentation/montage/icon/history.md)

- [case home](/documentation/montage/icon/home.md)

- [case homeFill](/documentation/montage/icon/homefill.md)

- [case hourglass](/documentation/montage/icon/hourglass.md)

- [case image](/documentation/montage/icon/image.md)

- [case inbox](/documentation/montage/icon/inbox.md)

- [case instance](/documentation/montage/icon/instance.md)

- [case keyboard](/documentation/montage/icon/keyboard.md)

- [case like](/documentation/montage/icon/like.md)

- [case likeFill](/documentation/montage/icon/likefill.md)

- [case lineHorizontal](/documentation/montage/icon/linehorizontal.md)

- [case lineHorizontalThick](/documentation/montage/icon/linehorizontalthick.md)

- [case link](/documentation/montage/icon/link.md)

- [case list](/documentation/montage/icon/list.md)

- [case listCategory](/documentation/montage/icon/listcategory.md)

- [case listOrdered](/documentation/montage/icon/listordered.md)

- [case location](/documentation/montage/icon/location.md)

- [case locationFill](/documentation/montage/icon/locationfill.md)

- [case lock](/documentation/montage/icon/lock.md)

- [case lockFill](/documentation/montage/icon/lockfill.md)

- [case lockOpen](/documentation/montage/icon/lockopen.md)

- [case lockOpenFill](/documentation/montage/icon/lockopenfill.md)

- [case login](/documentation/montage/icon/login.md)

- [case logoApple](/documentation/montage/icon/logoapple.md)

- [case logoAppleColor](/documentation/montage/icon/logoapplecolor.md)

- [case logoBrunch](/documentation/montage/icon/logobrunch.md)

- [case logoFacebook](/documentation/montage/icon/logofacebook.md)

- [case logoFacebookColor](/documentation/montage/icon/logofacebookcolor.md)

- [case logoGoogleColor](/documentation/montage/icon/logogooglecolor.md)

- [case logoGooglePlay](/documentation/montage/icon/logogoogleplay.md)

- [case logoGooglePlayColor](/documentation/montage/icon/logogoogleplaycolor.md)

- [case logoInstagram](/documentation/montage/icon/logoinstagram.md)

- [case logoInstagramColor](/documentation/montage/icon/logoinstagramcolor.md)

- [case logoKakao](/documentation/montage/icon/logokakao.md)

- [case logoKakaoColor](/documentation/montage/icon/logokakaocolor.md)

- [case logoLinkedIn](/documentation/montage/icon/logolinkedin.md)

- [case logoLinkedInColor](/documentation/montage/icon/logolinkedincolor.md)

- [case logoMicrosoft](/documentation/montage/icon/logomicrosoft.md)

- [case logoMicrosoftColor](/documentation/montage/icon/logomicrosoftcolor.md)

- [case logoNaverBlog](/documentation/montage/icon/logonaverblog.md)

- [case logoNaverBlogColor](/documentation/montage/icon/logonaverblogcolor.md)

- [case logoX](/documentation/montage/icon/logox.md)

- [case logoYoutube](/documentation/montage/icon/logoyoutube.md)

- [case logoYoutubeColor](/documentation/montage/icon/logoyoutubecolor.md)

- [case logout](/documentation/montage/icon/logout.md)

- [case magicWand](/documentation/montage/icon/magicwand.md)

- [case mail](/documentation/montage/icon/mail.md)

- [case mailOpen](/documentation/montage/icon/mailopen.md)

- [case medal](/documentation/montage/icon/medal.md)

- [case megaphone](/documentation/montage/icon/megaphone.md)

- [case megaphoneFill](/documentation/montage/icon/megaphonefill.md)

- [case menu](/documentation/montage/icon/menu.md)

- [case menuThick](/documentation/montage/icon/menuthick.md)

- [case message](/documentation/montage/icon/message.md)

- [case messageFill](/documentation/montage/icon/messagefill.md)

- [case microphone](/documentation/montage/icon/microphone.md)

- [case microphoneFill](/documentation/montage/icon/microphonefill.md)

- [case microphoneSlash](/documentation/montage/icon/microphoneslash.md)

- [case microphoneSlashFill](/documentation/montage/icon/microphoneslashfill.md)

- [case minus](/documentation/montage/icon/minus.md)

- [case minusThick](/documentation/montage/icon/minusthick.md)

- [case mobile](/documentation/montage/icon/mobile.md)

- [case mobileFill](/documentation/montage/icon/mobilefill.md)

- [case moon](/documentation/montage/icon/moon.md)

- [case moreHorizontal](/documentation/montage/icon/morehorizontal.md)

- [case moreVertical](/documentation/montage/icon/morevertical.md)

- [case moreVerticalTight](/documentation/montage/icon/moreverticaltight.md)

- [case musicMicrophone](/documentation/montage/icon/musicmicrophone.md)

- [case navigationCareer](/documentation/montage/icon/navigationcareer.md)

- [case navigationMenu](/documentation/montage/icon/navigationmenu.md)

- [case navigationMypage](/documentation/montage/icon/navigationmypage.md)

- [case navigationRecruit](/documentation/montage/icon/navigationrecruit.md)

- [case navigationSocial](/documentation/montage/icon/navigationsocial.md)

- [case pause](/documentation/montage/icon/pause.md)

- [case pencil](/documentation/montage/icon/pencil.md)

- [case pencilFill](/documentation/montage/icon/pencilfill.md)

- [case person](/documentation/montage/icon/person.md)

- [case personFill](/documentation/montage/icon/personfill.md)

- [case personPlus](/documentation/montage/icon/personplus.md)

- [case personPlusFill](/documentation/montage/icon/personplusfill.md)

- [case persons](/documentation/montage/icon/persons.md)

- [case personsFill](/documentation/montage/icon/personsfill.md)

- [case phone](/documentation/montage/icon/phone.md)

- [case phoneFill](/documentation/montage/icon/phonefill.md)

- [case pin](/documentation/montage/icon/pin.md)

- [case pinFill](/documentation/montage/icon/pinfill.md)

- [case play](/documentation/montage/icon/play.md)

- [case plus](/documentation/montage/icon/plus.md)

- [case plusThick](/documentation/montage/icon/plusthick.md)

- [case presentation](/documentation/montage/icon/presentation.md)

- [case printer](/documentation/montage/icon/printer.md)

- [case question](/documentation/montage/icon/question.md)

- [case quote](/documentation/montage/icon/quote.md)

- [case refresh](/documentation/montage/icon/refresh.md)

- [case reset](/documentation/montage/icon/reset.md)

- [case search](/documentation/montage/icon/search.md)

- [case searchThick](/documentation/montage/icon/searchthick.md)

- [case send](/documentation/montage/icon/send.md)

- [case sendFill](/documentation/montage/icon/sendfill.md)

- [case setting](/documentation/montage/icon/setting.md)

- [case share](/documentation/montage/icon/share.md)

- [case shareIos](/documentation/montage/icon/shareios.md)

- [case sparkle](/documentation/montage/icon/sparkle.md)

- [case sparkleFill](/documentation/montage/icon/sparklefill.md)

- [case square](/documentation/montage/icon/square.md)

- [case squareCaret](/documentation/montage/icon/squarecaret.md)

- [case squareCheck](/documentation/montage/icon/squarecheck.md)

- [case squareFill](/documentation/montage/icon/squarefill.md)

- [case squareHan](/documentation/montage/icon/squarehan.md)

- [case squareHangul](/documentation/montage/icon/squarehangul.md)

- [case squareKana](/documentation/montage/icon/squarekana.md)

- [case squareLatin](/documentation/montage/icon/squarelatin.md)

- [case squareMore](/documentation/montage/icon/squaremore.md)

- [case squarePlay](/documentation/montage/icon/squareplay.md)

- [case squarePlus](/documentation/montage/icon/squareplus.md)

- [case squarePlusFill](/documentation/montage/icon/squareplusfill.md)

- [case star](/documentation/montage/icon/star.md)

- [case starFill](/documentation/montage/icon/starfill.md)

- [case strikethrough](/documentation/montage/icon/strikethrough.md)

- [case sun](/documentation/montage/icon/sun.md)

- [case tag](/documentation/montage/icon/tag.md)

- [case tagFill](/documentation/montage/icon/tagfill.md)

- [case template](/documentation/montage/icon/template.md)

- [case templateFill](/documentation/montage/icon/templatefill.md)

- [case textFormat](/documentation/montage/icon/textformat.md)

- [case textVariable](/documentation/montage/icon/textvariable.md)

- [case thumbnail](/documentation/montage/icon/thumbnail.md)

- [case thunder](/documentation/montage/icon/thunder.md)

- [case thunderFill](/documentation/montage/icon/thunderfill.md)

- [case ticket](/documentation/montage/icon/ticket.md)

- [case ticketFill](/documentation/montage/icon/ticketfill.md)

- [case trash](/documentation/montage/icon/trash.md)

- [case triangle](/documentation/montage/icon/triangle.md)

- [case triangleExclamation](/documentation/montage/icon/triangleexclamation.md)

- [case triangleExclamationFill](/documentation/montage/icon/triangleexclamationfill.md)

- [case triangleFill](/documentation/montage/icon/trianglefill.md)

- [case trophy](/documentation/montage/icon/trophy.md)

- [case trophyFill](/documentation/montage/icon/trophyfill.md)

- [case tune](/documentation/montage/icon/tune.md)

- [case umbrella](/documentation/montage/icon/umbrella.md)

- [case umbrellaFill](/documentation/montage/icon/umbrellafill.md)

- [case underline](/documentation/montage/icon/underline.md)

- [case upload](/documentation/montage/icon/upload.md)

- [case verifiedCheck](/documentation/montage/icon/verifiedcheck.md)

- [case verifiedCheckFill](/documentation/montage/icon/verifiedcheckfill.md)

- [case verifiedStar](/documentation/montage/icon/verifiedstar.md)

- [case verifiedStarFill](/documentation/montage/icon/verifiedstarfill.md)

- [case video](/documentation/montage/icon/video.md)

- [case webinar](/documentation/montage/icon/webinar.md)

- [case write](/documentation/montage/icon/write.md)

### Initializers 

- [init?(rawValue: String)](/documentation/montage/icon/init(rawvalue:).md)

### Instance Properties 

- [var name: String](/documentation/montage/icon/name.md)

  아이콘의 리소스 이름을 반환합니다.

### Default Implementations 

- [API ReferenceEquatable Implementations](/documentation/montage/icon/equatable-implementations.md)

- [API ReferenceRawRepresentable Implementations](/documentation/montage/icon/rawrepresentable-implementations.md)

## Relationships 

### Conforms To 

- Swift.CaseIterable
- Swift.Equatable
- Swift.Hashable
- Swift.RawRepresentable

