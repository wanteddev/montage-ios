//
//  PrimaryButtonDisabledStatus.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/22.
//

import Foundation

/// PrimaryButton에서 Button의 Disabled 상태를 관리하는 ObservableObject Model
public final class PrimaryButtonDisabledStatus: ObservableObject {
    @Published public var value: Bool

    public init(value: Bool) {
        self.value = value
    }
}
