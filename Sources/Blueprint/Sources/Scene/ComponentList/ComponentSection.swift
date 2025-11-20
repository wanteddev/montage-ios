//
//  ComponentSection.swift
//  Blueprint
//
//  Created by AI Assistant on 2025/10/21.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI
import Montage

struct ComponentSection: Identifiable {
    let category: ComponentCategory
    let items: [Component]
    
    var id: ComponentCategory { category }
}

enum ComponentCategory: String, CaseIterable, Hashable {
    case actions, selectionAndInput, contents, loading, navigations, feedback,
         presentation, utilities
}

enum Component: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
    case actionArea, chip, button, iconButton, textButton
    case control, filterButton, segmentedControl, select, slider, textArea, textField, dateTimePicker, framedStyle
    case accordion, avatar, card, contentBadge, listCard, listCell, playBadge, sectionHeader, thumbnail
    case loading, pullToRefresh, skeleton
    case category, pagination, progressIndicator, progressTracker, tab, topNavigation
    case fallbackView, pushBadge, snackbar, toast
    case bottomSheet, popup, popover, tooltip
    case color, flowLayout, icon, modalNavigation, shadow, typography
    
    var state: ComponentState {
        .completed
    }
    
    var category: ComponentCategory {
        switch self {
        case .actionArea, .chip, .button, .iconButton, .textButton:
            return .actions
        case .control, .filterButton, .segmentedControl, .select, .slider, .textArea, .textField, .dateTimePicker, .framedStyle:
            return .selectionAndInput
        case .accordion, .avatar, .card, .contentBadge, .listCard, .listCell, .playBadge, .sectionHeader, .thumbnail:
            return .contents
        case .loading, .pullToRefresh, .skeleton:
            return .loading
        case .category, .pagination, .progressIndicator, .progressTracker, .tab, .topNavigation:
            return .navigations
        case .fallbackView, .pushBadge, .snackbar, .toast:
            return .feedback
        case .bottomSheet, .popup, .popover, .tooltip:
            return .presentation
        case .color, .flowLayout, .icon, .modalNavigation, .shadow, .typography:
            return .utilities
        }
    }
}

enum ComponentState: Int {
    case completed, previewNotReady, pending
}
