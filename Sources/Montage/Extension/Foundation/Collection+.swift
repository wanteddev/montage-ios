//
//  Collection+.swift
//  Montage
//
//  Created by 김삼열 on 11/21/24.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
