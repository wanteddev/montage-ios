//
//  Bundle+Montage.swift
//  Views
//
//  Created by 김삼열 on 12/5/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

#if !SWIFT_PACKAGE
// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
import Foundation
private class BundleFinder {}
extension Foundation.Bundle {
static let module = Bundle(for: BundleFinder.self)
}// swiftlint:enable all
// swiftformat:enable all
#endif
