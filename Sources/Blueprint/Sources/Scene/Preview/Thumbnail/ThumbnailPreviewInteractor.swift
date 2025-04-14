//
//  ThumbnailPreviewInteractor.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/11.
//  Copyright (c) 2023 WantedLab Inc.. All rights reserved.
//

import Foundation

// MARK: - ThumbnailPreviewInteractor

final class ThumbnailPreviewInteractor {
    var presenter: ThumbnailPreviewPresentationLogic?
    private var contents: ThumbnailPreviewContents

    init(contents: ThumbnailPreviewContents = .init()) {
        self.contents = contents
    }
}

// MARK: - ThumbnailPreviewRequestLogic

extension ThumbnailPreviewInteractor: ThumbnailPreviewRequestLogic {
    func process(_ request: ThumbnailPreview.Request.OnLoad) {
        presenter?.present(.contents(contents))
    }
    
    func process(_ request: ThumbnailPreview.Request.OnExecuteUserAction) {
        switch request.action {
        case .touchedPortraitButton:
            contents.isPortrait.toggle()
            presenter?.present(.contents(contents))
        case .touchedSelectImageButton:
            presenter?.present(.imagePicker)
        case .touchedDeleteImageButton:
            contents.selectedImage = nil
            presenter?.present(.contents(contents))
        case .selectedImage(let image):
            contents.selectedImage = image
            presenter?.present(.contents(contents))
        default:
            break
        }
    }
}

// MARK: - ThumbnailPreviewRequestLogic definition

protocol ThumbnailPreviewRequestLogic {
    /// 외부매개변수는 제외하기
    func process(_ request: ThumbnailPreview.Request.OnLoad)
    func process(_ request: ThumbnailPreview.Request.OnExecuteUserAction)
}

// MARK: - ThumbnailPreviewPresentationLogic definition

protocol ThumbnailPreviewPresentationLogic {
    /// 외부매개변수는 제외하기
    func present(_ response: ThumbnailPreview.Response)
}

