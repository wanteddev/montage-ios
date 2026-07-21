//
//  TextFieldTests.swift
//  MontageTests
//

import SwiftUI
import XCTest

@testable import Montage

/// 이번 PR은 `TextField`의 `fieldBackground`에서 drop shadow를 제거했습니다.
/// `fieldBackground`는 `private` 계산 속성이라 직접 단언할 수 없으므로,
/// disable/활성 두 분기를 모두 거치도록 `body`를 강제 평가해
/// 리팩터링 이후에도 크래시 없이 뷰 그래프가 구성되는지 검증하는 스모크 테스트입니다.
final class TextFieldTests: XCTestCase {
    // MARK: - Helpers

    private func makeTextBinding(_ initial: String) -> Binding<String> {
        var storage = initial
        return Binding(
            get: { storage },
            set: { storage = $0 }
        )
    }

    private func evaluateBody(_ textField: TextField) {
        _ = textField.body
    }

    // MARK: - fieldBackground (disable / enabled) smoke tests

    func test_body_enabled_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .disable(false)

        evaluateBody(textField)
    }

    func test_body_disabled_doesNotCrash() {
        let textField = TextField(text: makeTextBinding("입력값"))
            .disable(true)

        evaluateBody(textField)
    }

    func test_body_disabled_withNegativeStatus_doesNotCrash() {
        // disable 상태에서는 status와 무관하게 동일한 배경/테두리를 사용해야 하며,
        // 두 분기를 함께 지나가도 크래시가 없어야 한다.
        let textField = TextField(text: makeTextBinding(""))
            .status(.negative)
            .disable(true)

        evaluateBody(textField)
    }

    // MARK: - Status variants

    func test_body_status_normal_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .status(.normal)

        evaluateBody(textField)
    }

    func test_body_status_positive_doesNotCrash() {
        let textField = TextField(text: makeTextBinding("값"))
            .status(.positive)

        evaluateBody(textField)
    }

    func test_body_status_negative_doesNotCrash() {
        let textField = TextField(text: makeTextBinding("값"))
            .status(.negative)

        evaluateBody(textField)
    }

    // MARK: - Size variants

    func test_body_size_large_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .size(.large)

        evaluateBody(textField)
    }

    func test_body_size_medium_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .size(.medium)

        evaluateBody(textField)
    }

    // MARK: - Combined with icon / placeholder / trailingButton

    func test_body_withIconAndPlaceholder_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .icon(.person)
            .placeholder("이메일을 입력하세요")

        evaluateBody(textField)
    }

    func test_body_withTrailingButton_disabledField_doesNotCrash() {
        let textField = TextField(text: makeTextBinding(""))
            .disable(true)
            .trailingButton(.init(title: "인증", handler: {}))

        evaluateBody(textField)
    }
}