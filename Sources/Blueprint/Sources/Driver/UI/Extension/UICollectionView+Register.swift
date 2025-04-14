//
//  UICollectionView+Register.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/02.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit

protocol CodebaseCollectionCell {}
protocol CodebaseReusableView {}

extension UICollectionView {
    func register<T: UICollectionViewCell & CodebaseCollectionCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }

    func register<T: UICollectionReusableView & CodebaseReusableView>(_: T.Type, kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        kind: String,
        indexPath: IndexPath
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T
        else {
            fatalError("Could not dequeue header or footer view with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
}
