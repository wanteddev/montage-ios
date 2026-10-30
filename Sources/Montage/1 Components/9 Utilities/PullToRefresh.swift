//
//  PullToRefresh.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI
import UIKit

/// SwiftUI 스크롤 뷰에 ``PullToRefreshControl``을 붙이는 당겨서 새로고침입니다.
///
/// SwiftUI `ScrollView` 밑에 깔린 `UIScrollView`를 찾아 `refreshControl`에 ``PullToRefreshControl``을 붙입니다.
/// UIKit 화면과 같은 컨트롤을 쓰므로 로고 모션과 트리거 거리, 갱신 중 높이가 같습니다.
public enum PullToRefresh {
    struct Modifier: ViewModifier {
        let refresh: () async -> Void

        func body(content: Content) -> some View {
            content.background(Installer(refresh: refresh))
        }
    }

    /// 수정자를 붙인 뷰의 배경에 깔려 그 영역의 `UIScrollView`를 찾고 컨트롤을 붙인다.
    private struct Installer: UIViewRepresentable {
        let refresh: () async -> Void

        func makeCoordinator() -> Coordinator {
            Coordinator(refresh: refresh)
        }

        func makeUIView(context: Context) -> ProbeView {
            let view = ProbeView()
            view.isUserInteractionEnabled = false
            view.onHierarchyChange = { [weak coordinator = context.coordinator] in
                coordinator?.attach(from: $0)
            }
            return view
        }

        func updateUIView(_: ProbeView, context: Context) {
            context.coordinator.refresh = refresh
        }

        static func dismantleUIView(_: ProbeView, coordinator: Coordinator) {
            coordinator.detach()
        }
    }

    private final class ProbeView: UIView {
        var onHierarchyChange: ((ProbeView) -> Void)?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            guard window != nil else { return }
            // 스크롤 뷰가 아직 계층에 붙기 전일 수 있어 다음 런루프에서 찾는다.
            DispatchQueue.main.async { [weak self] in
                guard let self, self.window != nil else { return }
                self.onHierarchyChange?(self)
            }
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            onHierarchyChange?(self)
        }
    }

    private final class Coordinator {
        var refresh: () async -> Void
        private let control = PullToRefreshControl()
        private weak var scrollView: UIScrollView?
        private var refreshControlObservation: NSKeyValueObservation?
        private var task: Task<Void, Never>?

        init(refresh: @escaping () async -> Void) {
            self.refresh = refresh
            control.addAction(UIAction { [weak self] _ in
                self?.startRefresh()
            }, for: .valueChanged)
        }

        func attach(from probe: UIView) {
            guard scrollView == nil, let found = Self.scrollView(around: probe) else { return }
            scrollView = found
            found.refreshControl = control
            // SwiftUI가 업데이트 중에 refreshControl을 nil로 비우는 경우가 있어 다시 붙인다.
            refreshControlObservation = found.observe(\.refreshControl) { [weak self] scrollView, _ in
                MainActor.assumeIsolated {
                    guard let self, scrollView.refreshControl !== self.control else { return }
                    scrollView.refreshControl = self.control
                }
            }
        }

        func detach() {
            task?.cancel()
            refreshControlObservation = nil
            if scrollView?.refreshControl === control {
                scrollView?.refreshControl = nil
            }
            scrollView = nil
        }

        private func startRefresh() {
            task?.cancel()
            task = Task { @MainActor [weak self] in
                guard let self else { return }
                await self.refresh()
                self.control.endRefreshing()
            }
        }

        /// 수정자는 스크롤 뷰 바깥(배경)에 깔리므로 조상을 거슬러 오르며 그 아래에서 찾는다.
        ///
        /// - 스크롤 뷰는 safe area까지 덮어 수정자 영역보다 크게 잡히므로, 그 영역을 감싸는 스크롤 뷰를 고른다.
        ///   콘텐츠 안의 가로 캐러셀처럼 안쪽에 겹친 스크롤 뷰는 영역을 다 감싸지 못해 걸리지 않는다.
        /// - 배경은 받치는 뷰 바로 앞에 놓이므로 뒤쪽 형제부터 본다. 스크롤 뷰가 교체되는 순간에는 사라질 이전
        ///   스크롤 뷰가 앞쪽에 함께 남아 있다.
        /// - 다른 스크롤 뷰 안에 들어 있어도 가까운 이쪽이 먼저 걸리도록 조상 자신은 하위를 다 훑은 뒤에 본다.
        private static func scrollView(around probe: UIView) -> UIScrollView? {
            let area = probe.convert(probe.bounds, to: nil)
            func covers(_ scrollView: UIScrollView) -> Bool {
                scrollView.convert(scrollView.bounds, to: nil).insetBy(dx: -1, dy: -1).contains(area)
            }
            var branch: UIView = probe
            while let current = branch.superview {
                let siblings = current.subviews
                let index = siblings.firstIndex(of: branch) ?? 0
                var queue = Array(siblings[(index + 1)...] + siblings[..<index])
                while !queue.isEmpty {
                    let view = queue.removeFirst()
                    if let scrollView = view as? UIScrollView, covers(scrollView) {
                        return scrollView
                    }
                    queue.append(contentsOf: view.subviews)
                }
                if let scrollView = current as? UIScrollView, covers(scrollView) {
                    return scrollView
                }
                // 뷰 컨트롤러 경계를 넘으면 전환 중인 이전 화면의 스크롤 뷰가 걸릴 수 있다.
                if current.next is UIViewController {
                    return nil
                }
                branch = current
            }
            return nil
        }
    }
}

// MARK: - View Extension

extension View {
    /// 스크롤 뷰에 당겨서 새로고침(Pull-to-Refresh)을 추가합니다.
    ///
    /// 당기면 로고가 그려지고, 놓으면 `refresh`가 끝날 때까지 로고가 돕니다.
    /// ``PullToRefreshControl``을 쓰므로 UIKit 화면과 동작이 같습니다.
    ///
    /// ``ScrollView``는 ``ScrollView/onRefresh(_:)``가 이 수정자를 대신 붙여 주므로,
    /// 직접 붙이는 건 `SwiftUI.ScrollView`를 쓰는 경우입니다. 스크롤 뷰에 바로 붙입니다.
    ///
    /// ```swift
    /// SwiftUI.ScrollView {
    ///     content
    /// }
    /// .pullToRefresh {
    ///     await loadData()
    /// }
    /// ```
    ///
    /// - Parameter refresh: 갱신할 때 실행할 비동기 작업
    /// - Returns: 당겨서 새로고침이 추가된 뷰
    public func pullToRefresh(refresh: @escaping () async -> Void) -> some View {
        modifier(PullToRefresh.Modifier(refresh: refresh))
    }

    /// 스크롤 뷰에 당겨서 새로고침(Pull-to-Refresh)을 추가합니다.
    ///
    /// - Parameters:
    ///   - scrollYOffset: 쓰지 않습니다. 컨트롤이 스크롤 위치를 직접 읽습니다
    ///   - refresh: 갱신할 때 실행할 비동기 작업
    /// - Returns: 당겨서 새로고침이 추가된 뷰
    @available(*, deprecated, renamed: "pullToRefresh(refresh:)", message: "scrollYOffset을 쓰지 않습니다. pullToRefresh(refresh:)를 쓰세요.")
    public func pullToRefresh(
        scrollYOffset: Binding<CGFloat>,
        refresh: @escaping () async -> Void
    ) -> some View {
        pullToRefresh(refresh: refresh)
    }
}
