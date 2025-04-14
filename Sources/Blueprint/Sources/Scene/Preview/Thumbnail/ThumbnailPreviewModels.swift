//
//  ThumbnailPreviewModels.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/11.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//

import UIKit

import Montage

enum ThumbnailPreview {

    enum Request {
        struct OnLoad {}
        
        struct OnExecuteUserAction {
            let action: UserAction
        }
    }
    
    enum Response {
        case contents(ThumbnailPreviewContents)
        case imagePicker
    }
    
    enum UserAction {
        case touchedPortraitButton
        case touchedImageButton
        case touchedSelectImageButton
        case touchedDeleteImageButton
        case selectedImage(UIImage)
    }
    
    enum ViewModel {
        struct List {
            let items: [Item]
        }
        
        struct Item: Hashable {
            let id = UUID()
            let ratio: Ratio
            let portrait: Bool
            let image: UIImage?
        }
        
        struct ButtonGroup {
            let buttons: [Button]
        }
        
        struct Button {
            let imageName: String
            let selected: Bool
            let userAction: UserAction
            let submenus: [Menu]?
        }
        
        struct Menu {
            let imageName: String
            let text: String
            let enabled: Bool
            let userAction: UserAction
        }
        
        struct ImagePicker {}
    }
}
