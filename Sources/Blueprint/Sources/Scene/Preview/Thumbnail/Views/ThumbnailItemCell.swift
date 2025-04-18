//
//  ThumbnailItemCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/05/12.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage
import SnapKit

final class ThumbnailItemCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private lazy var thumbnail = Thumbnail(ratio: .r1x1)
    
    private lazy var ratioLabel = UILabel()
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(thumbnail)
        contentView.addSubview(ratioLabel)
        
        thumbnail.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(CGFloat.spacing(.pt16))
            $0.bottom.equalToSuperview()
        }
        
        ratioLabel.snp.makeConstraints {
            $0.left.top.equalTo(thumbnail).inset(CGFloat.spacing(.pt08))
        }
    }
    
    func configure(with viewModel: ThumbnailPreview.ViewModel.Item) {
        thumbnail.ratio = viewModel.ratio
        thumbnail.portrait = viewModel.portrait
        thumbnail.image = viewModel.image
        ratioLabel.attributedText = .montage(
            ".\(String(describing: viewModel.ratio))",
            variant: .title2,
            weight: .bold,
            semantic: .labelAlternative
        )
        layoutIfNeeded()
    }
}
