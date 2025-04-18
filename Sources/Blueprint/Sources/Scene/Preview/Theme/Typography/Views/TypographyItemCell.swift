//
//  TypographyItemCell.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/17.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage
import SnapKit

final class TypographyItemCell: BaseCollectionViewCell, CodebaseCollectionCell {
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .montage(variant: .heading2, weight: .bold)
        view.textColor = .semantic(.labelAlternative)
        return view
    }()
    
    private lazy var engLabel = UILabel()
    private lazy var korLabel = UILabel()
    private lazy var jpnLabel = UILabel()
    
    private lazy var labels = [engLabel, korLabel, jpnLabel]
    
    private lazy var divider1: UIView = {
        let view = UIView()
        view.backgroundColor = .semantic(.lineNormal)
        return view
    }()
    
    private lazy var divider2: UIView = {
        let view = UIView()
        view.backgroundColor = .semantic(.lineNormal)
        return view
    }()
    
    override func setup() {
        contentView.addSubview(labelStackView)
        
        labelStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        divider1.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        divider2.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.setCustomSpacing(12, after: nameLabel)
        labelStackView.addArrangedSubview(engLabel)
        labelStackView.addArrangedSubview(divider1)
        labelStackView.addArrangedSubview(korLabel)
        labelStackView.addArrangedSubview(divider2)
        labelStackView.addArrangedSubview(jpnLabel)
    }
    
    func configure(with viewModel: TypographyPreview.ViewModel.Item) {
        nameLabel.text = viewModel.title
        
        engLabel.attributedText = viewModel.engString
        korLabel.attributedText = viewModel.korString
        jpnLabel.attributedText = viewModel.jpnString
        
        labels.forEach {
            $0.numberOfLines = viewModel.showMultiline ? 0 : 1
            $0.backgroundColor = viewModel.showBounds ? .semantic(.accentBackgroundPink).withAlphaComponent(0.15) : .clear
            $0.layer.borderColor = viewModel.showBounds ? UIColor.semantic(.accentBackgroundPink).cgColor : nil
            $0.layer.borderWidth = viewModel.showBounds ? 1 : 0
        }
        
        invalidateIntrinsicContentSize()
    }
}
