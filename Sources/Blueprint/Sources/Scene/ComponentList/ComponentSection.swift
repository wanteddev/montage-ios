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
    case theme, layout, actions, selectionAndInput, contents, loading, navigations, feedback,
         presentation, utility
}

enum Component: String, CaseIterable, Hashable, Identifiable {
    var id: String { rawValue }
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
                .contentBadge, .card, .listCard, .framedStyle, .divider:
            return .completed
        }
    }
    
    var category: ComponentCategory {
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
        case .pushBadge, .fallbackView, .snackbar, .toast:
            return .feedback
        case .modal, .tooltip:
            return .presentation
        case .framedStyle:
            return .utility
        }
    }
}

enum ComponentState: Int {
    case completed, previewNotReady, pending
}
