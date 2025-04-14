//
//  ThumbnailPreviewBuilder.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/11.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//

import UIKit

// MARK: - ThumbnailPreviewBuilder

final class ThumbnailPreviewBuilder {}

// MARK: - ThumbnailPreviewBuildingLogic

extension ThumbnailPreviewBuilder: ThumbnailPreviewBuildingLogic {
    
    func build() -> Destination {
        let viewController = ThumbnailPreviewController()
        let interactor = ThumbnailPreviewInteractor()
        let presenter = ThumbnailPreviewPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController

        return viewController
    }

}

// MARK: - ThumbnailPreviewBuildingLogic definition

protocol ThumbnailPreviewBuildingLogic {
    typealias Destination = ThumbnailPreviewController
    /// 자유롭게 매개변수 추가하기 (Add parameters freely)
    func build() -> Destination
}
