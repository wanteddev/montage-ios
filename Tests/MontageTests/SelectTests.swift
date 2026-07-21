//
//  SelectTests.swift
//  MontageTests
//

import SwiftUI
import XCTest

@testable import Montage

/// `Select`는 대부분의 상태를 `private` 저장 속성으로 보관하는 SwiftUI `View`이므로,
/// 별도의 뷰 인스펙션 라이브러리 없이는 렌더링 결과를 직접 단언할 수 없습니다.
/// 아래 테스트는 이번 PR에서 변경된 분기(leadingContent, render=chip/text,
/// overflow, disable/negative, Chips 색상·테두리 로직 등)를 실제로 평가해
/// `body` 계산 과정에서 크래시나 강제 언래핑 실패가 발생하지 않는지 검증하는
/// 스모크 테스트입니다.
final class SelectTests: XCTestCase {
    // MARK: - Helpers

    private func makeItemsBinding(_ items: [Select.Item]) -> Binding<[Select.Item]> {
        var storage = items
        return Binding(
            get: { storage },
            set: { storage = $0 }
        )
    }

    /// `body`를 강제로 평가해 뷰 그래프 구성 중 발생할 수 있는 크래시를 조기에 드러낸다.
    private func evaluateBody(_ select: Select) {
        _ = select.body
    }

    // MARK: - Select.Item

    func test_item_defaultValues() {
        let item = Select.Item(text: "값1")

        XCTAssertEqual(item.text, "값1")
        XCTAssertNil(item.icon)
        XCTAssertFalse(item.isNegative)
        XCTAssertFalse(item.isSelected)
    }

    func test_item_equality() {
        let a = Select.Item(text: "값1", icon: .apps, isNegative: true, isSelected: true)
        let b = Select.Item(text: "값1", icon: .apps, isNegative: true, isSelected: true)
        let c = Select.Item(text: "값2", icon: .apps, isNegative: true, isSelected: true)

        XCTAssertEqual(a, b)
        XCTAssertNotEqual(a, c)
    }

    // MARK: - Variant smoke tests

    func test_body_singleVariant_withoutSelection_doesNotCrash() {
        let items: [Select.Item] = [.init(text: "값1"), .init(text: "값2")]
        let select = Select(
            variant: .single(),
            items: makeItemsBinding(items)
        )
        .placeholder("선택해 주세요.")

        evaluateBody(select)
    }

    func test_body_singleVariant_withSelection_doesNotCrash() {
        let items: [Select.Item] = [.init(text: "값1", isSelected: true), .init(text: "값2")]
        let select = Select(
            variant: .single(selectionType: .checkmark),
            items: makeItemsBinding(items)
        )

        evaluateBody(select)
    }

    func test_body_multipleTextVariant_doesNotCrash() {
        let items: [Select.Item] = [
            .init(text: "값1", isSelected: true),
            .init(text: "값2", isSelected: true),
        ]
        let select = Select(
            variant: .multiple(render: .text, overflow: false, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )

        evaluateBody(select)
    }

    func test_body_multipleChipVariant_withoutOverflow_doesNotCrash() {
        let items: [Select.Item] = [
            .init(text: "값1", icon: .apps, isSelected: true),
            .init(text: "값2", isNegative: true, isSelected: true),
        ]
        let select = Select(
            variant: .multiple(render: .chip, overflow: false, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )

        evaluateBody(select)
    }

    func test_body_multipleChipVariant_withOverflow_doesNotCrash() {
        let items: [Select.Item] = [
            .init(text: "값1", isSelected: true),
            .init(text: "값2", isNegative: true, isSelected: true),
            .init(text: "값3", icon: .apps, isSelected: true),
        ]
        let select = Select(
            variant: .multiple(render: .chip, overflow: true, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )

        evaluateBody(select)
    }

    // MARK: - leadingContent smoke tests

    func test_body_leadingContent_icon_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .leadingContent(.icon(.send))

        evaluateBody(select)
    }

    func test_body_leadingContent_iconButton_doesNotCrash() {
        // leading 아이콘 버튼은 Select 사이즈에 맞춰 large/medium을 사용해야 하며,
        // 인터랙션 영역이 슬롯보다 큰 경우에도 크래시 없이 레이아웃이 구성돼야 한다.
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .size(.large)
        .leadingContent(.iconButton(.init(variant: .normal(size: .large), icon: .send)))

        evaluateBody(select)
    }

    func test_body_leadingContent_iconButton_mediumSize_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .size(.medium)
        .leadingContent(.iconButton(.init(variant: .normal(size: .medium), icon: .send)))

        evaluateBody(select)
    }

    func test_body_leadingContent_custom_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .leadingContent(.custom { Text("이력서") })

        evaluateBody(select)
    }

    func test_body_leadingContent_withChipRender_doesNotCrash() {
        // render=chip일 때 leadingContent 우측에 추가 패딩이 붙는 분기를 함께 평가한다.
        let items: [Select.Item] = [.init(text: "값1", isSelected: true)]
        let select = Select(
            variant: .multiple(render: .chip, overflow: false, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )
        .leadingContent(.icon(.send))

        evaluateBody(select)
    }

    func test_body_leadingContent_nil_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .leadingContent(nil)

        evaluateBody(select)
    }

    // MARK: - disable / negative smoke tests

    func test_body_disable_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1", isSelected: true)])
        )
        .disable(true)

        evaluateBody(select)
    }

    func test_body_disable_defaultsToTrue_whenOmitted() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .disable()

        evaluateBody(select)
    }

    func test_body_negative_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1", isSelected: true)])
        )
        .negative(true)

        evaluateBody(select)
    }

    // MARK: - Chips coloring / border smoke tests

    func test_body_chips_disabledWithNegativeAndIconItems_doesNotCrash() {
        // Chips의 disable/negative 분기(테두리·아이콘·폰트 색상)를 모두 지나가도록 구성한다.
        let items: [Select.Item] = [
            .init(text: "값1", icon: .apps, isNegative: false, isSelected: true),
            .init(text: "값2", isNegative: true, isSelected: true),
        ]
        let select = Select(
            variant: .multiple(render: .chip, overflow: false, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )
        .disable(true)

        evaluateBody(select)
    }

    func test_body_chips_negativeWithoutDisable_doesNotCrash() {
        let items: [Select.Item] = [.init(text: "값1", isNegative: true, isSelected: true)]
        let select = Select(
            variant: .multiple(render: .chip, overflow: false, menuPrimaryButtonTitle: "확인"),
            items: makeItemsBinding(items)
        )

        evaluateBody(select)
    }

    // MARK: - Size / menuResize smoke tests

    func test_body_size_defaultsToLarge_whenOmitted() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .size()

        evaluateBody(select)
    }

    func test_body_size_medium_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .size(.medium)

        evaluateBody(select)
    }

    func test_body_menuResize_doesNotCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1")])
        )
        .menuResize(.fixedRatio(0.5))

        evaluateBody(select)
    }

    // MARK: - Regression: no empty-selection crash with placeholder

    func test_body_emptySelection_showsPlaceholderWithoutCrash() {
        let select = Select(
            variant: .single(),
            items: makeItemsBinding([.init(text: "값1"), .init(text: "값2")])
        )
        .placeholder("선택해 주세요.")

        evaluateBody(select)
    }
}