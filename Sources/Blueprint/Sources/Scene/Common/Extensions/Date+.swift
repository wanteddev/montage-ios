//
//  Date+.swift
//  Montage
//
//  Created by 김삼열 on 12/27/24.
//

import Foundation

extension Date {
    func formatted(_ formatString: String, locale: Locale? = Locale.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        dateFormatter.locale = locale
        return dateFormatter.string(from: self)
    }
}
