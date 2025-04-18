//
//  ThumbnailPreviewPresenter.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/11.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//

import UIKit

// MARK: - ThumbnailPreviewPresenter

final class ThumbnailPreviewPresenter {
    weak var viewController: ThumbnailPreviewDisplayLogic?
}

// MARK: - ThumbnailPreviewPresentationLogic

extension ThumbnailPreviewPresenter: ThumbnailPreviewPresentationLogic {
    func present(_ response: ThumbnailPreview.Response) {
        switch response {
        case .contents(let contents):
            viewController?.display(
                ThumbnailPreview.ViewModel.List(
                    items: contents.ratios.map {
                        .init(ratio: $0, portrait: contents.isPortrait, image: contents.selectedImage)
                    }
                )
            )
            viewController?.display(
                ThumbnailPreview.ViewModel.ButtonGroup(
                    buttons: [
                        .init(
                            imageName: "rectangle.portrait.arrowtriangle.2.inward",
                            selected: contents.isPortrait,
                            userAction: .touchedPortraitButton,
                            submenus: nil
                        ),
                        .init(
                            imageName: "photo.on.rectangle.angled",
                            selected: false,
                            userAction: .touchedImageButton,
                            submenus: [
                                .init(
                                    imageName: "photo",
                                    text: "이미지 선택",
                                    enabled: true,
                                    userAction: .touchedSelectImageButton
                                ),
                                .init(
                                    imageName: "minus.circle",
                                    text: "선택한 이미지 삭제",
                                    enabled: contents.selectedImage != nil,
                                    userAction: .touchedDeleteImageButton
                                )
                            ]
                        )
                    ]
                )
            )
        case .imagePicker:
            viewController?.display(ThumbnailPreview.ViewModel.ImagePicker())
        }
    }
}

// MARK: - ThumbnailPreviewDisplayLogic definition

protocol ThumbnailPreviewDisplayLogic: AnyObject {
    func display(_ viewModel: ThumbnailPreview.ViewModel.List)
    func display(_ viewModel: ThumbnailPreview.ViewModel.ButtonGroup)
    func display(_ viewModel: ThumbnailPreview.ViewModel.ImagePicker)
}
