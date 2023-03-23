//
//  Icon.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import Foundation

public extension Montage {
    /// Montage 번들 내에 포함된 아이콘들의 이름들입니다.
    enum Icon: String, CaseIterable {
        case apps
        case arrowUp
        case bell
        case bellPlus
        case block
        case bookmark
        case bookmarkFill
        case bubble
        case bubbleFill
        case businessBag
        case businessBagFill
        case calendar
        case camera
        case cameraFill
        case caretDown
        case caretUp
        case check
        case checkThick
        case chevronDown
        case chevronDownThick
        case chevronLeft
        case chevronLeftThick
        case chevronLeftTight
        case chevronLeftTightThick
        case chevronRight
        case chevronRightThick
        case chevronRightTight
        case chevronRightTightThick
        case chevronUp
        case chevronUpThick
        case circleCheck
        case circleClose
        case circleExclamation
        case circleInfo
        case circlePlus
        case circleQuestion
        case close
        case closeThick
        case company
        case copy
        case document
        case documentPerson
        case documentPersonFill
        case download
        case exclamation
        case externalLink
        case faceSmile
        case faceSmileFill
        case filter
        case filterFill
        case full
        case globe
        case handle
        case heart
        case heartFill
        case history
        case home
        case homeFill
        case image
        case like
        case likeFill
        case link
        case location
        case lock
        case lockOpen
        case mail
        case menu
        case menuStar
        case message
        case messageFill
        case messageText
        case messageTextFill
        case moreHorizontal
        case moreVertical
        case pause
        case pencil
        case person
        case personFill
        case personPlus
        case pin
        case play
        case plus
        case plusThick
        case question
        case refresh
        case search
        case searchThick
        case send
        case sendFill
        case setting
        case share
        case squareHangul
        case squareHan
        case squareKana
        case squareLatin
        case squareMore
        case star
        case starFill
        case thunder
        case thunderFill
        case trash
        case triangleExclamation
        case tune
        case upload
        case verifiedCheck
        case verifiedCheckFill
        case verifiedStar
        case verifiedStarFill
        
        // added on v0.1.2
        case dot
        case lineHorizontalThick
        case lineHorizontal
        
        public var name: String { rawValue }
    }
}
