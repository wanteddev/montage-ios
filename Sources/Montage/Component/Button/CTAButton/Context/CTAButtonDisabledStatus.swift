//
//  CTAButtonDisabledStatus.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/21.
//

import Foundation

/// CTAButton에서 Button의 Disabled 상태를 관리하는 ObservableObject Model
public final class CTAButtonDisabledStatus: ObservableObject {
    @Published public var value: CTAButton.DisabledStatus

    public init(value: CTAButton.DisabledStatus) {
        self.value = value
    }
}

public extension CTAButton {
    /// CTAButton에서 Button의 Disabled 상태
    enum DisabledStatus: Int {
        case leading = 0
        case trailing
        case all
        case none

        public var index: Int { rawValue }
    }
}
