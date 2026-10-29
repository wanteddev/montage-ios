//
//  PullToRefreshControl.swift
//  Montage
//
//  Copyright © 2026 WantedLab Inc. All rights reserved.
//

import Lottie
import UIKit

/// Montage 로고 모션을 입힌 UIKit용 `UIRefreshControl`입니다.
///
/// 트리거와 inset 관리는 `UIRefreshControl`에 그대로 맡기고 시스템 스피너만 로고로 바꿉니다.
/// 사용법은 `UIRefreshControl`과 같습니다. SwiftUI 스크롤 뷰에는
/// ``SwiftUI/View/pullToRefresh(refresh:)``가 이 컨트롤을 붙여 줍니다.
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
        // waitingToEnd: 손가락을 대고 있는 동안 갱신이 끝난 상태. 놓을 때까지 로고를 유지한다.
        // settling: 로고가 사라진 뒤에도 아직 당겨져 있는 상태. 스크롤이 제자리로 돌아올 때까지 다시 그리지 않는다.
        case pulling, refreshing, waitingToEnd, ending, settling
    }

    private static let logoSize = CGSize(width: 48, height: 36)
    // 로고 높이의 절반에서 애니메이션을 시작해 4배에서 꽉 찬다.
    private static let animationStart = logoSize.height / 2
    private static let animationEnd = logoSize.height * 4

    private let logoView = LottieAnimationView()
    private var phase = Phase.pulling
    private var offsetObservation: NSKeyValueObservation?
    private weak var observedScrollView: UIScrollView?

    override public init() {
        super.init()
        tintColor = .clear
        logoView.contentMode = .scaleAspectFill
        logoView.backgroundBehavior = .pauseAndRestore
        addSubview(logoView)
        loadAnimation()
        // 사용자가 당겨 갱신할 때만 햅틱을 낸다. UIRefreshControl은 자체 햅틱이 없다.
        addAction(UIAction { [weak self] _ in
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            self?.startRefreshingAnimation()
        }, for: .valueChanged)
        if #available(iOS 17, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
                self.reloadForStyleChange()
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
            reloadForStyleChange()
        }
    }

    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        observedScrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handlePan(_:)))
        let scrollView = superview as? UIScrollView
        observedScrollView = scrollView
        scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        offsetObservation = scrollView?
            .observe(\.contentOffset) { [weak self] scrollView, _ in
                MainActor.assumeIsolated {
                    self?.updatePullProgress(in: scrollView)
                }
            }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard phase == .waitingToEnd,
              gesture.state == .ended || gesture.state == .cancelled || gesture.state == .failed
        else { return }
        finishRefreshing()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        logoView.bounds = CGRect(origin: .zero, size: Self.logoSize)
        logoView.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    // 코드로 시작한 갱신은 .valueChanged가 오지 않으므로 여기서 로고를 돌린다.
    override public func beginRefreshing() {
        super.beginRefreshing()
        startRefreshingAnimation()
    }

    override public func endRefreshing() {
        // 손가락을 대고 있으면 놓을 때 끝낸다. 지금 끝내면 놓기 전에 로고가 사라진다.
        if phase == .refreshing || phase == .waitingToEnd, observedScrollView?.isTracking == true {
            phase = .waitingToEnd
            return
        }
        finishRefreshing()
    }

    private func finishRefreshing() {
        super.endRefreshing()
        guard phase == .refreshing || phase == .waitingToEnd else { return }
        phase = .ending
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut]) {
            self.logoView.alpha = 0
        } completion: { _ in
            // 사라지는 도중 다시 당겨 갱신이 시작됐으면 그쪽 상태를 덮어쓰지 않는다.
            guard self.phase == .ending else { return }
            // 아직 당긴 상태면 바로 당김 모션으로 돌아가지 않는다. 남은 거리만큼 로고가 다시 그려졌다가 지워지기 때문이다.
            if let scrollView = self.superview as? UIScrollView, Self.pulledDistance(in: scrollView) > 0 {
                self.phase = .settling
            } else {
                self.resetToPulling()
            }
        }
    }

    private static func pulledDistance(in scrollView: UIScrollView) -> CGFloat {
        -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top)
    }

    private func updatePullProgress(in scrollView: UIScrollView) {
        let pulled = Self.pulledDistance(in: scrollView)
        if phase == .settling, pulled <= 0 {
            resetToPulling()
        }
        guard phase == .pulling else { return }
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
                guard self.phase == .refreshing || self.phase == .waitingToEnd else { return }
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
    }

    private func reloadForStyleChange() {
        // 애니메이션을 교체하면 진행도가 0으로 돌아간다. 당기는 중이면 그 위치를 유지한다.
        let progress = logoView.currentProgress
        loadAnimation()
        if phase == .pulling {
            logoView.currentProgress = progress
        }
        // 갱신 중 다크 모드가 바뀌면 애니메이션 교체로 재생이 멈춘다. 확대 모션이 끝난 뒤라면 다시 돌린다.
        if phase == .refreshing || phase == .waitingToEnd, logoView.transform == .identity {
            logoView.play(fromProgress: 0, toProgress: 1, loopMode: .loop)
        }
    }
}
