//
//  View+Montage.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/02/17.
//

import SwiftUI

// MARK: - Internal

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func `if`(_ condition: Bool) -> some View {
        if condition {
            self
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.windows?.first?.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension View {
    public func elevation(_ elevation: Elevation) -> Self {
        let currentView = self

        guard elevation != .none else {
            return currentView
        }

        let descriptor = elevation.descriptor

        guard let color = descriptor.color else {
            return currentView
        }

        let _ = currentView.shadow(
            color: SwiftUI.Color(color.withAlphaComponent(descriptor.alpha)),
            radius: descriptor.blur,
            x: descriptor.offset.width,
            y: descriptor.offset.height
        )

        return currentView
    }

    public func paragraph(variant: Typography.Variant) -> some View {
        lineSpacing(variant.lineSpacing).padding(.vertical, variant.padding)
    }
}

// MARK: - Component

// MARK: Toast

extension View {
    public func toast(
        _ model: Binding<Toast.Model?>,
        location: Toast.Location = .bottom(offset: 0),
        duration: Toast.Duration = .short
    ) -> some View {
        modifier(Toast.ToastModifier(model: model, location: location, duration: duration))
    }
}

// MARK: snackBar

extension View {
    public func snackBar(_ model: Binding<SnackBar.Model?>, handler: @escaping () -> Void) -> some View {
        modifier(SnackBar.SnackBarModifier(model: model, handler: handler))
    }
}

// MARK: Tooltip

extension View {
    public func tooltip(
        config: TooltipConfigurable,
        show: Binding<Bool>,
        content: String
    ) -> some View {
        modifier(
            Tooltip.TooltipModifier(
                config: config,
                show: show,
                content: content
            )
        )
    }

    public func tooltip(
        variant: Tooltip.Variant = .extended(),
        position: Tooltip.Position,
        show: Binding<Bool>,
        inverse: Bool = false,
        showCloseButton: Bool = false,
        content: String
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(
                variant: variant,
                position: position,
                inverse: inverse,
                showCloseButton: showCloseButton
            ),
            show: show,
            content: content
        )
    }

    public func tooltip(
        position: Tooltip.Position,
        show: Binding<Bool>,
        content: String
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(position: position),
            show: show,
            content: content
        )
    }

    public func tooltip(
        show: Binding<Bool>,
        content: String
    ) -> some View {
        tooltip(
            config: Tooltip.DefaultTooltipConfig(),
            show: show,
            content: content
        )
    }
}

// MARK: TopNavigation

extension View {
    public func topNavigation(
        variant: Bar.TopNavigation.Variant = .normal,
        title: String,
        left: Bar.TopNavigation.Resource.Left? = nil,
        backgroundColorResolvable: ColorResolvable? = nil,
        actions: [Bar.TopNavigation.Resource.Action] = []
    ) -> some View {
        modifier(
            Bar.TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                left: left,
                backgroundColorResolvable: backgroundColorResolvable,
                actions: actions
            )
        )
    }

    public func topNavigation(
        variant: Bar.TopNavigation.Variant = .normal,
        title: String,
        left: Bar.TopNavigation.Resource.Left? = nil,
        backgroundColorResolvable: ColorResolvable? = nil,
        actions: [Bar.TopNavigation.Resource.Action] = [],
        withBottom model: ActionArea.Bottom.Model
    ) -> some View {
        modifier(
            Bar.TopNavigation.TopNavigationModifier(
                variant: variant,
                title: title,
                left: left,
                backgroundColorResolvable: backgroundColorResolvable,
                actions: actions,
                model: model
            )
        )
    }
}

// MARK: Skeleton

extension View {
    public func skeleton<V: View>(
        isPresented: Bool,
        @ViewBuilder skeletonView: @escaping () -> V
    ) -> some View {
        modifier(Skeleton.SkeletonModifier(isPresented: isPresented, skeletonView: skeletonView))
    }

    public func skeleton(
        isPresented: Bool,
        kind: Skeleton.Kind,
        color: SwiftUI.Color? = nil,
        opacity: CGFloat? = nil
    ) -> some View {
        modifier(
            Skeleton.PredefinedSkeletonModifier(
                isPresented: isPresented,
                kind: kind,
                color: color,
                opacity: opacity
            )
        )
    }
}

// MARK: Loading

extension View {
    public func loading(
        _ isLoading: Binding<Bool>,
        type: Loading.Kind,
        dimmedColor: SwiftUI.Color = .clear
    ) -> some View {
        modifier(Loading.LoadingViewModifier(isLoading, type: type, dimmedColor: dimmedColor))
    }
}

// MARK: Interaction Disabling

extension View {
    public func interactionDisabled(_ disabled: Bool) -> some View {
        ZStack {
            modifier(InteractionDisablingViewModifier(disabled: disabled))
        }
    }
}

// MARK: Disable SwipeBack

extension View {
    public func disableSwipeBack(_ disabled: Bool) -> some View {
        background(
            DisableSwipeBackView(disabled: disabled)
        )
    }
}

// MARK: Auto Scroll

extension View {
    public func scrollable(_ axis: Axis.Set, contentOffset: Binding<CGPoint>) -> some View {
        modifier(AutoScrollModifier(axis: axis, contentOffset: contentOffset))
    }
}

// MARK: Pull To Refresh

extension View {
    public func pullToRefresh(
        scrollYOffset: Binding<CGFloat>,
        refresh: @escaping () async -> Void
    ) -> some View {
        modifier(PullToRefreshModifier(scrollYOffset: scrollYOffset, refresh: refresh))
    }
}

// MARK: DatePicker, TimePicker

extension View {
    public func datePicker(
        selectedDate: Binding<Date>,
        in range: ClosedRange<Date> = Date.distantPast ... Date.distantFuture
    ) -> some View {
        overlay {
            DatePicker(selection: selectedDate, in: range, displayedComponents: .date) {}
                .labelsHidden()
                .contentShape(Rectangle())
                .colorMultiply(.clear)
        }
    }

    public func timePicker(
        selectedDate: Binding<Date>,
        in range: ClosedRange<Date> = Date.distantPast ... Date.distantFuture
    ) -> some View {
        overlay {
            DatePicker(selection: selectedDate, in: range, displayedComponents: .hourAndMinute) {}
                .labelsHidden()
                .contentShape(Rectangle())
                .colorMultiply(.clear)
        }
    }
}

// MARK: Float

extension View {
    public func float<V: Equatable, F: View>(
        presentationPolicy: FloatModifier<V, F>.PresentationPolicy,
        presentingAnimation: Animation = .default,
        dismissingAnimation: Animation = .default,
        dismissPolicy: FloatModifier<V, F>.DismissPolicy = .onDisappear,
        onDismiss: (() -> Void)? = nil,
        floatView: @escaping () -> F
    ) -> some View {
        modifier(
            FloatModifier(
                presentationPolicy: presentationPolicy,
                presentingAnimation: presentingAnimation,
                dismissingAnimation: dismissingAnimation,
                dismissPolicy: dismissPolicy,
                onDismiss: onDismiss,
                floatView: floatView
            )
        )
    }
}
