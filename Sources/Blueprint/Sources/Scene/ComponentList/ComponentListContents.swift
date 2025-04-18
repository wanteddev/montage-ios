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
        case theme, layout, actions, selectionAndInput, contents, loading, navigations, feedback, presentation
    }
    
    enum ComponentType: String, CapitalizedTitleFetchable, CaseIterable {
        case typography, color, icon, grid, elevation
        case divider, flowLayout
        case actionArea, button, iconButton, chip
        case control, `switch`, input, segmentedControl, select, slider, textField, textArea, dateTimePicker
        case avatar, card, cell, thumbnail, accordion, playBadge, sectionHeader, contentBadge
        case loading, skeleton, pullToRefresh
        case topNavigation, progressIndicator, tab, pagination, progressTracker, category
        case pushBadge, emptyState, snackbar, toast, tooltip
        case modal, menu
        
        var state: ComponentState {
            switch self {
            case .typography, .color, .icon, .grid, .elevation, .switch, .input, .control, .flowLayout,
                    .button, .iconButton, .thumbnail, .emptyState, .pushBadge, .chip, .topNavigation,
                    .progressIndicator, .avatar, .toast, .snackbar, .tooltip, .actionArea,
                    .textArea, .textField, .select, .segmentedControl, .cell, .tab, .slider,
                    .pullToRefresh, .skeleton, .loading, .progressTracker, .dateTimePicker,
                    .pagination, .accordion, .category, .playBadge, .sectionHeader, .menu, .modal, .contentBadge:
                return .completed
            case .divider, .card:
                return .previewNotReady
            }
        }
        
        var category: CategoryType {
            switch self {
            case .typography, .color, .icon, .grid, .elevation:
                return .theme
            case .divider, .flowLayout:
                return .layout
            case .actionArea, .button, .iconButton, .chip:
                return .actions
            case .control, .switch, .input, .segmentedControl, .select, .slider, .textField, .textArea, .dateTimePicker:
                return .selectionAndInput
            case .avatar, .card, .cell, .thumbnail, .accordion, .playBadge, .sectionHeader, .contentBadge:
                return .contents
            case .loading, .skeleton, .pullToRefresh:
                return .loading
            case .topNavigation, .progressIndicator, .tab, .pagination, .progressTracker, .category:
                return .navigations
            case .pushBadge, .emptyState, .snackbar, .toast, .tooltip:
                return .feedback
            case .modal, .menu:
                return .presentation
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
                        .sorted { $0.state < $1.state || $0.state == $1.state && $0.title < $1.title }
                        .filter {
                            searchTerm?.isEmpty != false ||
                            $0.category.rawValue.lowercased().contains(searchTerm?.lowercased() ?? "") ||
                            $0.title.lowercased().contains(searchTerm?.lowercased() ?? "") }
                )
            }
    }
}

extension CapitalizedTitleFetchable {
    var title: String {
        let firstLetter = rawValue.prefix(1).uppercased()
        let remainingLetters = rawValue.dropFirst().map { $0.isUppercase ? " \($0)" : "\($0)" }.joined()
        return firstLetter + remainingLetters
    }
}
