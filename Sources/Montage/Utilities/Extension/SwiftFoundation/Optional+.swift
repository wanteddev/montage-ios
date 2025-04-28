//
//  Optional+.swift
//  Montage
//
//  Created by 김삼열 on 3/18/25.
//

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        switch self {
        case .none: return true
        case .some(let value):
            return value.isEmpty
        }
    }
}
