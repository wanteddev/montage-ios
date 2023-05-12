//
//  ThumbnailView.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import UIKit

public class ThumbnailView: UIView {
    private enum Const {
        static var defaultImageName: String = "placeholder"
    }
    
    public var ratio: Ratio {
        didSet {
            setupUpdateableConstraints()
        }
    }
    
    public var portrait: Bool = false {
        didSet {
            setupUpdateableConstraints()
        }
    }
    
    public var image: UIImage? {
        didSet {
            imageView.image = image ?? UIImage(named: Const.defaultImageName, in: Bundle.module, with: nil)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Const.defaultImageName, in: Bundle.module, with: nil)
        return view
    }()
    
    private var viewContraints: [NSLayoutConstraint] = []
    
    public init(ratio: Ratio, portrait: Bool = false) {
        self.ratio = ratio
        self.portrait = portrait
        self.image = nil
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        self.ratio = .r1x1
        self.portrait = false
        self.image = nil
        
        super.init(coder: coder)
        
        setupViews()
    }
}

extension ThumbnailView {
    private func setupViews() {
        layer.masksToBounds = true
        
        addSubview(imageView)
        
        setupUpdateableConstraints()
    }
    
    private func setupUpdateableConstraints() {
        setupImageViewConstraint()
        
        updateConstraints()
    }
    
    private func setupImageViewConstraint() {
        NSLayoutConstraint.deactivate(viewContraints)
        
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if portrait {
            constraints.append(contentsOf: [
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leftAnchor.constraint(lessThanOrEqualTo: leftAnchor),
                imageView.rightAnchor.constraint(greaterThanOrEqualTo: rightAnchor),
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                widthAnchor.constraint(equalTo: heightAnchor, multiplier: calculatedThumbnailRatio())
            ])
        } else {
            constraints.append(contentsOf: [
                imageView.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
                imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: calculatedThumbnailRatio())
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
        viewContraints = constraints
    }
    
    private func calculatedThumbnailRatio() -> CGFloat {
        ratio.size.height / ratio.size.width
    }
}
