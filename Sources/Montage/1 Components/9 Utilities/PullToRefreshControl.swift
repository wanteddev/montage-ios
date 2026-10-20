//
//  PullToRefreshControl.swift
//  Montage
//
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import Lottie
import UIKit

/// ``PullToRefresh``의 로고 모션을 입힌 UIKit용 `UIRefreshControl`입니다.
///
/// ``PullToRefresh``는 SwiftUI `ScrollView` 전용이라 `UIScrollView`나 `WKWebView`에는 붙일 수 없습니다.
/// 트리거와 inset 관리는 `UIRefreshControl`에 그대로 맡기고 시스템 스피너만 로고로 바꿉니다.
/// 사용법은 `UIRefreshControl`과 같습니다.
///
/// ```swift
/// let control = PullToRefreshControl()
/// control.addAction(UIAction { _ in reload() }, for: .valueChanged)
/// scrollView.refreshControl = control
/// // 갱신이 끝나면
/// control.endRefreshing()
/// ```
///
/// - Note: `tintColor`는 시스템 스피너를 숨기는 데 쓰므로 바꾸지 않습니다.
public final class PullToRefreshControl: UIRefreshControl {
    private enum Phase {
        case pulling, refreshing, ending
    }

    private static let logoSize = CGSize(width: 48, height: 36)
    // PullToRefresh와 같은 비율: 로고 높이의 절반에서 애니메이션을 시작해 4배에서 꽉 찬다.
    private static let animationStart = logoSize.height / 2
    private static let animationEnd = logoSize.height * 4

    private let logoView = LottieAnimationView()
    private var phase = Phase.pulling
    private var offsetObservation: NSKeyValueObservation?

    override public init() {
        super.init()
        tintColor = .clear
        logoView.contentMode = .scaleAspectFill
        logoView.backgroundBehavior = .pauseAndRestore
        addSubview(logoView)
        loadAnimation()
        addAction(UIAction { [weak self] _ in self?.startRefreshingAnimation() }, for: .valueChanged)
        if #available(iOS 17, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
                self.loadAnimation()
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // iOS 16 경로. 17부터는 init의 registerForTraitChanges가 대신한다.
    @available(iOS, deprecated: 17)
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #unavailable(iOS 17),
           traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle
        {
            loadAnimation()
        }
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        offsetObservation = (superview as? UIScrollView)?
            .observe(\.contentOffset) { [weak self] scrollView, _ in
                MainActor.assumeIsolated {
                    self?.updatePullProgress(in: scrollView)
                }
            }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        logoView.bounds = CGRect(origin: .zero, size: Self.logoSize)
        logoView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override public func endRefreshing() {
        super.endRefreshing()
        guard phase == .refreshing else { return }
        phase = .ending
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.logoView.alpha = 0
        } completion: { _ in
            // 사라지는 도중 다시 당겨 갱신이 시작됐으면 그쪽 상태를 덮어쓰지 않는다.
            guard self.phase == .ending else { return }
            self.resetToPulling()
        }
    }

    private func updatePullProgress(in scrollView: UIScrollView) {
        guard phase == .pulling else { return }
        let pulled = -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top)
        let ratio = (pulled - Self.animationStart) / (Self.animationEnd - Self.animationStart)
        logoView.currentProgress = min(max(ratio, 0), 1)
    }

    private func startRefreshingAnimation() {
        // 사라지는 중(.ending)에 다시 당겨도 로고가 보이게 한다.
        guard phase != .refreshing else { return }
        phase = .refreshing
        logoView.layer.removeAllAnimations()
        logoView.alpha = 1
        loadAnimation()
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
            self.logoView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) {
                self.logoView.transform = .identity
            } completion: { _ in
                guard self.phase == .refreshing else { return }
                self.logoView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
            }
        }
    }

    private func resetToPulling() {
        phase = .pulling
        logoView.stop()
        loadAnimation()
        logoView.currentProgress = 0
        logoView.alpha = 1
    }

    private func loadAnimation() {
        let motion = phase == .pulling ? "pull" : "pulse"
        let style = traitCollection.userInterfaceStyle == .dark ? "dark" : "light"
        logoView.animation = .named("pullToRefresh-\(motion)-\(style)", bundle: .module)
        // 갱신 중 다크 모드가 바뀌면 애니메이션 교체로 재생이 멈춘다. 확대 모션이 끝난 뒤라면 다시 돌린다.
        if phase == .refreshing, logoView.transform == .identity {
            logoView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
        }
    }
}
