//
//  CaseDescribable.swift
//  Views
//
//  Created by 김삼열 on 3/4/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import Foundation

public protocol CaseDescribable {
    var description: String { get }
}

extension CaseDescribable {
    public var description: String {
        String("\(self)".split(separator: "(").first?.split(separator: ".").last ?? "")
    }
}
