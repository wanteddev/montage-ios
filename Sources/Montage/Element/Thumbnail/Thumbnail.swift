//
//  Thumbnail.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/05/09.
//

import UIKit

public class Thumbnail: UIView {
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
            updateImage(image)
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private var viewContraints: [NSLayoutConstraint] = []
    private var imageRatioContraint: NSLayoutConstraint?
    
    public init(ratio: Ratio, portrait: Bool = false) {
        self.ratio = ratio
        self.portrait = portrait
        self.image = nil
        
        super.init(frame: .zero)
        
        setupViews()
        updateImage(nil)
    }
    
    public required init?(coder: NSCoder) {
        self.ratio = .r1x1
        self.portrait = false
        self.image = nil
        
        super.init(coder: coder)
        
        setupViews()
        updateImage(nil)
    }
}

extension Thumbnail {
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
                widthAnchor.constraint(equalTo: heightAnchor, multiplier: calculatedThumbnailRatio())
            ])
        } else {
            constraints.append(contentsOf: [
                imageView.topAnchor.constraint(lessThanOrEqualTo: topAnchor),
                imageView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                heightAnchor.constraint(equalTo: widthAnchor, multiplier: calculatedThumbnailRatio())
            ])
        }
        
        NSLayoutConstraint.activate(constraints)
        
        viewContraints = constraints
    }
    
    private func updateImage(_ image: UIImage?) {
        guard
            let image = image ?? UIImage(
                named: Const.defaultImageName,
                in: Bundle.module,
                with: nil
            )
        else {
            return
        }
        
        imageRatioContraint?.isActive = false
        imageView.image = image
        
        let imageRatio = image.size.height / image.size.width
        
        if portrait {
            imageRatioContraint = imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: imageRatio
            )
        } else {
            imageRatioContraint = imageView.heightAnchor.constraint(
                equalTo: imageView.widthAnchor,
                multiplier: imageRatio
            )
        }
        
        imageRatioContraint?.isActive = true
    }
    
    private func calculatedThumbnailRatio() -> CGFloat {
        ratio.size.height / ratio.size.width
    }
}
