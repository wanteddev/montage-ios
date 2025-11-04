//
//  PullToRefreshView.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import Lottie
import SwiftUI

@available(iOS 18, *)
struct PullToRefreshModifier: ViewModifier {
    @Binding private var scrollYOffset: CGFloat
    private let refresh: () async -> Void
    
    init(scrollYOffset: Binding<CGFloat>, refresh: @escaping () async -> Void) {
        _scrollYOffset = scrollYOffset
        self.refresh = refresh
    }
    
    @State private var phase: AnimatingLogo.Phase = .idle
    @State private var task: Task<Void, Never>?
    
    @State private var isScrolling = false
    // 리프레시를 트리거링 할 가능성이 있는 '트리거스크롤'이 진행중임을 의미하는 플래그
    @State private var isTriggerScrolling = false
    // 스크롤 옵셋을 임의로 조정하기 위한 '투명뷰'의 필요 여부를 나타내는 플래그
    @State private var isClearRectNeeded = false
    
    // 로고 자체 높이(최초 셋팅 이후 고정값)
    @State private var logoHeight: CGFloat = .zero
    // 애니메이션이 시작되는 스크롤 옵셋 쓰레숄드(최초 셋팅 이후 고정값)
    private var animationThreshold: CGFloat { logoHeight / 2 }
    // 리프레시가 트리거되는 스크롤 옵셋 쓰레숄드(최초 셋팅 이후 고정값)
    private var refreshThreshold: CGFloat { logoHeight * 4 }
    // 리프레시 중에 스크롤이 멈춰있는 높이
    private var hangingHeight: CGFloat { logoHeight * 2 }
    
    // 로고와 패딩을 포함한 높이(최대: thresholdToRefresh)
    @State private var pullToRefreshViewHeight: CGFloat = .zero
    // 투명뷰 높이
    @State private var clearRectHeight: CGFloat = .zero
    
    // 스크롤뷰가 얼마나 당겨졌는지 0에서 시작해서 thresholdToRefresh까지를 1로 계산한 비율값
    private var pullDownRatio: CGFloat {
        max(0, scrollYOffset - animationThreshold) / max(1, refreshThreshold - animationThreshold)
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            AnimatingLogo(phase: $phase)
                .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                    logoHeight = $0
                })
                .fixedSize()
                .frame(height: max(pullToRefreshViewHeight, 0))
                .frame(maxWidth: .infinity)
                .clipped()
            
            VStack(spacing: 0) {
                if isClearRectNeeded {
                    SwiftUI.Color.clear
                        .frame(height: clearRectHeight)
                }
                
                content
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { _ in
                        isScrolling = true
                        
                        if phase.beforeRefreshing {
                            // 현재 스크롤이 트리거스크롤임
                            isTriggerScrolling = true
                        }
                    }
                    .onEnded { value in
                        // 리프레시가 시작된 후 스크롤이 끝났을 때
                        if phase.isRefreshing {
                            // 투명뷰를 추가한다.
                            isClearRectNeeded = true
                            // 스크롤 옵셋이 천천히 되돌아가도록 하기 위한 애니메이션
                            withAnimation(.easeInOut(duration: 0.2)) {
                                // 로고와 패딩 영역이 천천히 줄어들도록 하기 위함
                                pullToRefreshViewHeight = hangingHeight
                                clearRectHeight = hangingHeight
                            }
                        }
                        
                        // 리프레시가 끝나기 전에 스크롤을 드래그하여 위로 던지는 경우
                        if phase
                            .isRefreshing && (value.predictedEndTranslation.height < 0 || scrollYOffset < 0) {
                            task?.cancel()
                        }
                        
                        // 리프레시가 끝난 후 스크롤이 끝났을 때
                        if phase.isWaitingToEnd {
                            // 스크롤 옵셋 복귀 애니메이션 시작점 설정
                            clearRectHeight = hangingHeight + value.translation.height / 2
                            // 엔딩 애니메이션 수행
                            phase = .ending
                        }
                        
                        isTriggerScrolling = false
                        isScrolling = false
                    }
            )
        }
        .onChange(of: scrollYOffset) { scrollPosition in
            // 트리거스크롤이 끝날때까지
            if isTriggerScrolling {
                // 스크롤 옵셋 복귀 애니메이션 시작점을 업데이트
                clearRectHeight = scrollPosition
                // 트리거스크롤 중에 리프레시 시작되었는데 스크롤 포지션이 다시 쓰레숄드 아래로 내려가는 경우
                if phase.isRefreshing && scrollPosition < refreshThreshold {
                    task?.cancel()
                }
            }
            
            // 리프레시 시작전까지만
            if phase.beforeRefreshing {
                // 로고와 패딩 영역의 높이를 증가시키고 pullDownRatio를 계산한다.
                pullToRefreshViewHeight = scrollPosition
                phase = .pulledDown(ratio: pullDownRatio)
            }
        }
        .onChange(of: phase) { phase in
            switch phase {
            case .idle:
                break
            case .pulledDown(let ratio):
                if ratio > 1 && isScrolling {
                    self.phase = .refreshing
                }
            case .refreshing:
                if !isScrolling {
                    isClearRectNeeded = true
                    pullToRefreshViewHeight = hangingHeight
                    clearRectHeight = hangingHeight
                }
                task?.cancel()
                task = Task {
                    await refresh()
                    do {
                        try Task.checkCancellation()
                    } catch {
                        if error is CancellationError {
                            if isTriggerScrolling {
                                self.phase = .pulledDown(ratio: pullDownRatio)
                                return
                            }
                        }
                    }
                    if isScrolling {
                        // 스크롤 끝나는 시점에 엔딩 애니메이션을 수행하기 위해 대기시킨다.
                        self.phase = .waitingToEnd
                    } else {
                        self.phase = .ending
                    }
                }
            case .waitingToEnd: break
            case .ending:
                withAnimation(.easeInOut(duration: 0.2)) {
                    isClearRectNeeded = false
                    pullToRefreshViewHeight = 0
                    clearRectHeight = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.phase = .idle
                }
            }
        }
    }
}

private struct AnimatingLogo: View {
    enum Phase: Equatable {
        case idle, pulledDown(ratio: CGFloat), refreshing, waitingToEnd, ending
        
        var beforeRefreshing: Bool {
            switch self {
            case .idle, .pulledDown: true
            default: false
            }
        }
        
        var isRefreshing: Bool {
            switch self {
            case .refreshing: true
            default: false
            }
        }
        
        var isWaitingToEnd: Bool {
            switch self {
            case .waitingToEnd: true
            default: false
            }
        }
        
        var isEnding: Bool {
            switch self {
            case .ending: true
            default: false
            }
        }
    }
    
    @Binding private var phase: Phase
    
    init(phase: Binding<Phase>) {
        _phase = phase
    }
    
    @State private var playbackMode: LottiePlaybackMode = .playing(.toMarker("Loop", loopMode: .playOnce))
    @State private var scale = CGSize(width: 1, height: 1)
    @State private var opacity: Double = 1
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LottieView(animation: .named(jsonName, bundle: .module))
            .playbackMode(playbackMode)
            .configure {
                $0.contentMode = .scaleAspectFit
            }
            .configuration(LottieConfiguration(renderingEngine: .automatic))
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 36)
            .opacity(opacity)
            .scaleEffect(scale)
            .onChange(of: phase) { phase in
                switch phase {
                case .idle:
                    opacity = 1
                    playbackMode = .paused(at: .progress(0))
                case .pulledDown(let ratio):
                    playbackMode = .paused(at: .progress(ratio))
                case .refreshing:
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.25)) {
                        scale = CGSize(width: 1.1, height: 1.1)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.25)) {
                            scale = CGSize(width: 1, height: 1)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
                    }
                case .waitingToEnd: break
                case .ending:
                    withAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.5)) {
                        opacity = 0
                    }
                }
            }
    }
    
    private var jsonName: String {
        if phase.beforeRefreshing {
            "pullToRefresh-pull-\(colorScheme)"
        } else {
            "pullToRefresh-pulse-\(colorScheme)"
        }
    }
}

// MARK: - View Extension

@available(iOS 18, *)
extension View {
    /// 스크롤 뷰에 풀-투-리프레시(Pull-to-Refresh) 기능을 추가합니다.
    ///
    /// 사용자가 스크롤 뷰를 아래로 당기면 애니메이션과 함께 리프레시 기능을 제공합니다.
    /// iOS 18 이상에서 사용 가능하며, 로딩 애니메이션과 함께 당김 정도에 따른 시각적 피드백을 제공합니다.
    ///
    /// - Parameters:
    ///   - scrollYOffset: 스크롤 뷰의 Y축 오프셋 바인딩. 당김 정도를 감지하는 데 사용됩니다.
    ///   - refresh: 리프레시가 트리거될 때 실행될 비동기 클로저입니다.
    /// - Returns: 풀-투-리프레시 기능이, 추가된 뷰
    ///
    /// - Note: 이 모디파이어는 스크롤 뷰의 오프셋을 감지하고, 특정 임계값 이상으로 당겨질 때 리프레시 동작을 트리거합니다.
    /// - Important: 사용하기 위해서는 스크롤 뷰의 Y축 오프셋을 추적해야 합니다.
    /// ```swift
    /// @State private var scrollStatus = ScrollView.ScrollStatus()
    ///
    /// ScrollView(scrollStatus: $scrollStatus) {
    ///     content
    /// }
    /// .pullToRefresh(scrollYOffset: $scrollStatus.contentOffset.y) {
    ///     await loadData()
    /// }
    /// ```
    public func pullToRefresh(
        scrollYOffset: Binding<CGFloat>,
        refresh: @escaping () async -> Void
    ) -> some View {
        modifier(PullToRefreshModifier(scrollYOffset: scrollYOffset, refresh: refresh))
    }
}
