//
//  PrimaryButtonTitle.swift
//  Montage
//
//  Created by 정국희 on 2021/11/12.
//

import Foundation

public final class PrimaryButtonTitle: ObservableObject {
    @Published public var text: String

    public init(text: String) {
        self.text = text
    }
}
