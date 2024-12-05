//
//  Bundle+Montage.swift
//  Views
//
//  Created by 김삼열 on 12/5/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
import Foundation// MARK: - Swift Bundle Accessor for Frameworks
private class BundleFinder {}
extension Foundation.Bundle {
/// Since Lottie is a dynamic framework, the bundle for classes within this module can be used directly.
static let module = Bundle(for: BundleFinder.self)
}// swiftlint:enable all
// swiftformat:enable all
