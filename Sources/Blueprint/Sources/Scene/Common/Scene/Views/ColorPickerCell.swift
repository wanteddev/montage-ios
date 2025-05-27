//
//  ColorPickerCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/03/15.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import SnapKit
import Montage

final class ColorPickerCell: BaseCollectionViewCell, CodebaseCollectionCell {
    private enum Const {
        static let colorChipSize: CGSize = .init(width: 24, height: 24)
        static let contentsInset: CGFloat = .spacing(.pt16)
        static let contentsSpacing: CGFloat = .spacing(.pt08)
    }
    
    private lazy var colorChipView = UIView()
    
    private lazy var textLabel = UILabel()
    
    override func setup() {
        contentView.addSubview(colorChipView)
        contentView.addSubview(textLabel)
        
        colorChipView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(Const.contentsInset)
            $0.size.equalTo(Const.colorChipSize)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalTo(colorChipView)
            $0.left.equalTo(colorChipView.snp.right).offset(Const.contentsSpacing)
            $0.right.equalToSuperview().inset(Const.contentsInset)
        }
        
        colorChipView.layer.cornerRadius = Const.colorChipSize.width / 2
    }
    
    func configure(from viewModel: ColorPicker.ViewModel.Item) {
        colorChipView.backgroundColor = viewModel.color
        textLabel.attributedText = .attributedString(viewModel.name)
    }
}
