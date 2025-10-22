//
//  ComponentListRouter+SwiftUI.swift
//  Blueprint
//
//  Created by AI Assistant on 2025/10/21.
//  Copyright (c) 2025 WantedLab Inc.. All rights reserved.
//

import SwiftUI
import Montage

final class ComponentListNavigationCoordinator: ObservableObject {
    @Published var path: [Component] = []
    
    func navigate(to componentType: Component) {
        path.append(componentType)
    }
    
    @ViewBuilder
    func destinationView(for componentType: Component) -> some View {
        switch componentType {
        case .typography: TypographyPreview()
        case .color: ColorPreview()
        case .icon: IconPreview()
        case .shadow: ShadowPreview()
        case .control: ControlPreview()
        case .button: ButtonPreview()
        case .textButton: TextButtonPreview()
        case .iconButton: IconButtonPreview()
        case .chip: ChipPreview()
        case .contentBadge: ContentBadgePreview()
        case .pushBadge: PushBadgePreview()
        case .thumbnail: ThumbnailPreview()
        case .topNavigation: TopNavigationPreview()
        case .loading: LoadingPreview()
        case .progressIndicator: ProgressIndicatorPreview()
        case .avatar: AvatarPreview()
        case .skeleton: SkeletonPreview()
        case .fallbackView: FallbackViewPreview()
        case .toast: ToastPreview()
        case .snackbar: SnackBarPreview()
        case .tooltip: TooltipPreview()
        case .actionArea: ActionAreaPreview()
        case .textArea: TextAreaPreview()
        case .textField: TextFieldPreview()
        case .select: SelectPreview()
        case .segmentedControl: SegmentedControlPreview()
        case .listCell: ListCellPreview()
        case .tab: TabPreview()
        case .slider: SliderPreview()
        case .pullToRefresh: PullToRefreshPreview()
        case .progressTracker: ProgressTrackerPreview()
        case .dateTimePicker: DateTimePickerPreview()
        case .pagination: PaginationPreview()
        case .accordion: AccordionPreview()
        case .category: CategoryPreview()
        case .playBadge: PlayBadgePreview()
        case .sectionHeader: SectionHeaderPreview()
        case .modal: ModalPreview()
        case .flowLayout: FlowLayoutPreview()
        case .card: CardPreview()
        case .listCard: ListCardPreview()
        case .framedStyle: FramedStylePreview()
        case .divider: DividerPreview()
        }
    }
}


