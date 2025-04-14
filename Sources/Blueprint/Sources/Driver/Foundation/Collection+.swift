//
//  Collection+.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/17.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
