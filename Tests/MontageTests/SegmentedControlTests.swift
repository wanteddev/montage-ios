//
//  SegmentedControlTests.swift
//  MontageTests
//

import SwiftUI
import XCTest
@testable import Montage

/// `SegmentedControl.buttonIconSize`의 크기별/모드별 계산 로직을 검증합니다.
final class SegmentedControlTests: XCTestCase {
    // MARK: - Helpers
    private func makeControl(
        size: SegmentedControl.Size,
        iconOnly: Bool
    ) -> SegmentedControl {
        SegmentedControl(
            selectedIndex: .constant(0),
            items: [
                .init(image: Image(systemName: "house"), title: "A"),
                .init(image: Image(systemName: "gear"), title: "B"),
            ]
        )
        .size(size)
        .iconOnly(iconOnly)
    }

    // MARK: - Text mode (iconOnly = false)
    func test_buttonIconSize_textMode_large() {
        let sut = makeControl(size: .large, iconOnly: false)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 18, height: 18))
    }

    func test_buttonIconSize_textMode_medium() {
        let sut = makeControl(size: .medium, iconOnly: false)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 16, height: 16))
    }

    func test_buttonIconSize_textMode_small() {
        let sut = makeControl(size: .small, iconOnly: false)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 14, height: 14))
    }

    // MARK: - Icon-only mode (iconOnly = true)
    func test_buttonIconSize_iconOnly_large() {
        let sut = makeControl(size: .large, iconOnly: true)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 20, height: 20))
    }

    func test_buttonIconSize_iconOnly_medium() {
        let sut = makeControl(size: .medium, iconOnly: true)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 18, height: 18))
    }

    func test_buttonIconSize_iconOnly_small() {
        let sut = makeControl(size: .small, iconOnly: true)

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 16, height: 16))
    }

    // MARK: - Defaults
    func test_buttonIconSize_defaultsToLargeTextMode_whenNoModifiersApplied() {
        let sut = SegmentedControl(selectedIndex: .constant(0), labels: ["A", "B"])

        XCTAssertEqual(sut.buttonIconSize, CGSize(width: 18, height: 18))
    }

    // MARK: - Regression: iconOnly icons are exactly 2pt larger than text-mode icons
    func test_buttonIconSize_iconOnlyIsAlwaysTwoPointsLargerThanTextMode() {
        let sizes: [SegmentedControl.Size] = [.large, .medium, .small]

        for size in sizes {
            let textModeSize = makeControl(size: size, iconOnly: false).buttonIconSize
            let iconOnlySize = makeControl(size: size, iconOnly: true).buttonIconSize

            XCTAssertEqual(
                iconOnlySize.width - textModeSize.width, 2,
                "iconOnly width should be exactly 2pt larger than text mode width for size \(size)"
            )
            XCTAssertEqual(
                iconOnlySize.height - textModeSize.height, 2,
                "iconOnly height should be exactly 2pt larger than text mode height for size \(size)"
            )
        }
    }

    // MARK: - Invariant: icon size is always square
    func test_buttonIconSize_isAlwaysSquare() {
        let sizes: [SegmentedControl.Size] = [.large, .medium, .small]

        for size in sizes {
            for iconOnly in [true, false] {
                let iconSize = makeControl(size: size, iconOnly: iconOnly).buttonIconSize

                XCTAssertEqual(
                    iconSize.width, iconSize.height,
                    "Icon size should be square for size \(size), iconOnly \(iconOnly)"
                )
            }
        }
    }

    // MARK: - Monotonic ordering across sizes
    func test_buttonIconSize_increasesWithSize_inTextMode() {
        let small = makeControl(size: .small, iconOnly: false).buttonIconSize.width
        let medium = makeControl(size: .medium, iconOnly: false).buttonIconSize.width
        let large = makeControl(size: .large, iconOnly: false).buttonIconSize.width

        XCTAssertLessThan(small, medium)
        XCTAssertLessThan(medium, large)
    }

    func test_buttonIconSize_increasesWithSize_inIconOnlyMode() {
        let small = makeControl(size: .small, iconOnly: true).buttonIconSize.width
        let medium = makeControl(size: .medium, iconOnly: true).buttonIconSize.width
        let large = makeControl(size: .large, iconOnly: true).buttonIconSize.width

        XCTAssertLessThan(small, medium)
        XCTAssertLessThan(medium, large)
    }
}