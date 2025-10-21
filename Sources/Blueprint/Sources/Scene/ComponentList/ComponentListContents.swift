//
//  ComponentListContents.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/03.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import Foundation

protocol CapitalizedTitleFetchable: RawRepresentable<String> {}

enum ComponentState: Int, Comparable {
    case completed, previewNotReady, pending

    static func < (_ lhs: ComponentState, _ rhs: ComponentState) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

class ComponentListContents {
    var searchTerm: String?

    struct CategoryItemSet {
        let category: CategoryType
        let items: [ComponentType]
    }

    enum CategoryType: String, CapitalizedTitleFetchable, CaseIterable {
        case theme, layout, actions, selectionAndInput, contents, loading, navigations, feedback,
            presentation, utility
    }

    enum ComponentType: String, CapitalizedTitleFetchable, CaseIterable {
        case typography, color, icon, shadow
        case divider, flowLayout
        case actionArea, button, textButton, iconButton, chip
        case control, segmentedControl, select, slider, textField, textArea,
            dateTimePicker
        case avatar, card, listCard, listCell, thumbnail, accordion, playBadge, sectionHeader,
            contentBadge
        case loading, skeleton, pullToRefresh
        case topNavigation, progressIndicator, tab, pagination, progressTracker, category
        case pushBadge, fallbackView, snackbar, toast, tooltip
        case modal
        case framedStyle

        var state: ComponentState {
            switch self {
            case .typography, .color, .icon, .shadow, .control,
                .flowLayout,
                .button, .textButton, .iconButton, .thumbnail, .fallbackView, .pushBadge, .chip, .topNavigation,
                .progressIndicator, .avatar, .toast, .snackbar, .tooltip, .actionArea,
                .textArea, .textField, .select, .segmentedControl, .listCell, .tab, .slider,
                .pullToRefresh, .skeleton, .loading, .progressTracker, .dateTimePicker,
                .pagination, .accordion, .category, .playBadge, .sectionHeader, .modal,
                .contentBadge, .card, .listCard, .framedStyle:
                return .completed
            case .divider:
                return .previewNotReady
            }
        }

        var category: CategoryType {
            switch self {
            case .typography, .color, .icon, .shadow:
                return .theme
            case .divider, .flowLayout:
                return .layout
            case .actionArea, .button, .textButton, .iconButton, .chip:
                return .actions
            case .control, .segmentedControl, .select, .slider, .textField,
                .textArea, .dateTimePicker:
                return .selectionAndInput
            case .avatar, .card, .listCard, .listCell, .thumbnail, .accordion, .playBadge,
                .sectionHeader, .contentBadge:
                return .contents
            case .loading, .skeleton, .pullToRefresh:
                return .loading
            case .topNavigation, .progressIndicator, .tab, .pagination, .progressTracker, .category:
                return .navigations
            case .pushBadge, .fallbackView, .snackbar, .toast, .tooltip:
                return .feedback
            case .modal:
                return .presentation
            case .framedStyle:
                return .utility
            }
        }
    }

    var usableCategoryItems: [CategoryItemSet] {
        CategoryType.allCases
            .map { category in
                CategoryItemSet(
                    category: category,
                    items: ComponentType.allCases
                        .filter { $0.category == category }
                        .sorted {
                            $0.state < $1.state || $0.state == $1.state && $0.title < $1.title
                        }
                        .filter {
                            searchTerm?.isEmpty != false
                                || $0.category.rawValue.lowercased().contains(
                                    searchTerm?.lowercased() ?? "")
                                || $0.title.lowercased().contains(searchTerm?.lowercased() ?? "")
                        }
                )
            }
    }
}

extension CapitalizedTitleFetchable {
    var title: String {
        let firstLetter = rawValue.prefix(1).uppercased()
        let remainingLetters = rawValue.dropFirst().map { $0.isUppercase ? " \($0)" : "\($0)" }
            .joined()
        return firstLetter + remainingLetters
    }
}
