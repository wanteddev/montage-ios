//
//  Icon.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/20.
//

import Foundation

/// Montage 번들 내에 포함된 아이콘들의 이름들입니다.
public enum Icon: String, CaseIterable {
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
    case chevronDownTight
    case chevronDownTightThick
    case chevronDownSmall
    case chevronDownThickSmall
    case chevronDownTightSmall
    case chevronDownTightThickSmall
    case chevronLeft
    case chevronLeftThick
    case chevronLeftTight
    case chevronLeftTightThick
    case chevronLeftSmall
    case chevronLeftThickSmall
    case chevronLeftTightSmall
    case chevronLeftTightThickSmall
    case chevronRight
    case chevronRightThick
    case chevronRightTight
    case chevronRightTightThick
    case chevronRightSmall
    case chevronRightThickSmall
    case chevronRightTightSmall
    case chevronRightTightThickSmall
    case chevronUp
    case chevronUpThick
    case chevronUpTight
    case chevronUpTightThick
    case chevronUpSmall
    case chevronUpThickSmall
    case chevronUpTightSmall
    case chevronUpTightThickSmall
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
    
    // added on v0.3
    case compass
    
    // added on v0.6.x
    case add
    case bellTemp
    case bubbleTemp
    case heartFillTemp
    case heartTemp
    case keyboard
    case moreVerticalTight
    case shareTemp
    case viewCheck
    case change
    case pencilFill
    
    public var name: String { rawValue }
}
