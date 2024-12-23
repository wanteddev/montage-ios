//
//  PullToRefreshView.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI
import Lottie

public struct PullToRefreshModifier: ViewModifier {
    @Binding private var externalScrollYOffset: CGFloat
    private let refresh: () async -> Void
    private let isUsingInternalScrollView: Bool
    
    public init(scrollYOffset: Binding<CGFloat>, refresh: @escaping () async -> Void) {
        self._externalScrollYOffset = scrollYOffset
        self.refresh = refresh
        self.isUsingInternalScrollView = false
    }
    
    public init(refresh: @escaping () async -> Void) {
        self._externalScrollYOffset = Binding(get: { .zero }, set: { _ in })
        self.refresh = refresh
        self.isUsingInternalScrollView = true
    }
    
    @State private var internalScrollYOffset: CGFloat = .zero
    private var scrollYOffset: Binding<CGFloat> {
        Binding {
            isUsingInternalScrollView ? internalScrollYOffset : externalScrollYOffset
        } set: {
            if isUsingInternalScrollView {
                internalScrollYOffset = $0
            } else {
                externalScrollYOffset = $0
            }
        }
    }
    
    @State private var phase: AnimatingLogo.Phase = .idle
    @State private var task: Task<Void, Never>?
    
    // 리프레시를 트리거링 할 가능성이 있는 '트리거링 스크롤'이 진행중임을 의미하는 플래그
    @State private var isTriggeringScrollStarted: Bool = false
    // 스크롤 옵셋을 임의로 조정하기 위한 '투명뷰'의 필요 여부를 나타내는 플래그
    @State private var isClearRectNeeded: Bool = false
    
    // 로고 자체 높이(최초 셋팅 이후 고정값)
    @State private var logoHeight: CGFloat = .zero
    // 애니메이션이 시작되는 스크롤 옵셋 쓰레숄드(최초 셋팅 이후 고정값)
    private var animationThreshold: CGFloat { logoHeight / 2 }
    // 리프레시가 트리거되는 스크롤 옵셋 쓰레숄드(최초 셋팅 이후 고정값)
    private var refreshThreshold: CGFloat { logoHeight * 4 }
    
    // 로고와 패딩을 포함한 높이(최대: thresholdToRefresh)
    @State private var pullToRefreshViewHeight: CGFloat = .zero
    // 투명뷰 높이
    @State private var clearRectHeight: CGFloat = .zero
    
    // 스크롤뷰가 얼마나 당겨졌는지 0에서 시작해서 thresholdToRefresh까지를 1로 계산한 비율값
    private var pullDownRatio: CGFloat {
        max(0, scrollYOffset.wrappedValue - animationThreshold) / max(1, refreshThreshold - animationThreshold)
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            AnimatingLogo(phase: $phase)
                .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                    logoHeight = $0
                })
                .fixedSize()
                .frame(height: max(pullToRefreshViewHeight, 0))
                .frame(maxWidth: .infinity)
                .clipped()
            
            Group {
                let scrollView: some View = {
                    Group {
                        if isUsingInternalScrollView {
                            OffsettableScrollView(onOffsetChanged: { offset in
                                scrollYOffset.wrappedValue = offset.y
                            }) {
                                content
                            }
                        } else {
                            content
                        }
                    }
                }()
                VStack(spacing: 0) {
                    if isClearRectNeeded {
                        SwiftUI.Color.clear
                            .frame(height: clearRectHeight)
                    }
                    
                    scrollView
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
                    .onChanged({ state in
                        if phase.beforeRefreshing {
                            // 현재 스크롤이 트리거링 스크롤임
                            isTriggeringScrollStarted = true
                        }
                        // 리프레시가 끝나기 전에 다시 스크롤 하는 경우
                        if !isTriggeringScrollStarted {
                            // 스크롤 옵셋 복귀 애니메이션 시작점을 업데이트
                            clearRectHeight = logoHeight + state.translation.height / 2
                        }
                        // 리프레시 중에 위로 스크롤 하는 경우
                        if phase.isRefreshing && state.translation.height < 0 {
                            // 리프레시를 취소
                            phase = .ending
                        }
                    })
                    .onEnded({ value in
                        // 리프레시를 트리거한 후 트리거링 스크롤이 끝났을 때
                        if isTriggeringScrollStarted && !phase.beforeRefreshing {
                            isTriggeringScrollStarted = false
                            
                            if !phase.isEnding {
                                // 리프레시 시작과 트리거링 스크롤 종료, 두가지 조건 중 하나라도 만족되지 않았을때 투명뷰를 추가하면 스크롤 옵셋이 튀어버린다.
                                // 또, 트리거링 스크롤이 끝난 시점에 이미 엔딩 단계라면 (엔딩처리시 플래그를 끄고 있기 때문에) 다시 켜지 않아야 한다.
                                isClearRectNeeded = true
                            }
                            
                            // 스크롤 옵셋이 천천히 되돌아가도록 하기 위한 애니메이션
                            withAnimation(.easeInOut(duration: 0.5)) {
                                clearRectHeight = phase.isEnding ? 0 : logoHeight
                            }
                            
                            // 스크롤 애니메이션 종료 시점에 이미 엔딩 단계라면 idle단계로 변경한다.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if phase.isEnding {
                                    phase = .idle
                                }
                            }
                        }
                        
                        // 리프레시 중에 스크롤이 끝났을 때
                        if phase.isRefreshing {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                // 로고와 패딩 영역이 천천히 줄어들도록 하기 위함
                                pullToRefreshViewHeight = logoHeight
                                // 스크롤 옵셋이 천천히 되돌아가도록 하기 위함
                                clearRectHeight = logoHeight
                            }
                        }
                    })
            )
        }
        .onChange(of: scrollYOffset.wrappedValue) { scrollPosition in
            // 트리거링 스크롤이 끝날때까지
            if isTriggeringScrollStarted {
                // 스크롤 옵셋 복귀 애니메이션 시작점을 업데이트
                clearRectHeight = scrollPosition
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
                if ratio > 1 {
                    self.phase = .refreshing
                }
            case .refreshing:
                task?.cancel()
                task = Task {
                    await refresh()
                    self.phase = .ending
                }
            case .ending:
                task?.cancel()
                withAnimation(.easeInOut(duration: 0.5)) {
                    isClearRectNeeded = false
                    pullToRefreshViewHeight = 0
                    clearRectHeight = 0
                }
                if !isTriggeringScrollStarted {
                    // 엔딩 애니메이션이 끝날 때까지 트리거링 스크롤이 끝나지 않은 경우는 트리거링 스크롤이 끝나는 시점에 제어하기 위해 엔딩 단계로 남겨둔다.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.phase = .idle
                    }
                }
            }
        }
    }
}

private struct AnimatingLogo: View {
    enum Phase: Equatable {
        case idle, pulledDown(ratio: CGFloat), refreshing, ending
        
        var beforeRefreshing: Bool {
            switch self {
            case .idle, .pulledDown: return true
            default: return false
            }
        }
        
        var isRefreshing: Bool {
            switch self {
            case .refreshing: return true
            default: return false
            }
        }
        
        var isEnding: Bool {
            switch self {
            case .ending: return true
            default: return false
            }
        }
    }
    
    @Binding private var phase: Phase
    
    init(phase: Binding<Phase>) {
        self._phase = phase
    }
    
    @State private var playbackMode: LottiePlaybackMode = .playing(.toMarker("Loop", loopMode: .playOnce))
    @State private var scale: CGSize = CGSize(width: 1, height: 1)
    @State private var opacity: Double = 1
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LottieView(animation: .named(jsonName, bundle: .module))
            .playbackMode(playbackMode)
            .configure({
                $0.contentMode = .scaleAspectFit
            })
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
                        self.scale = CGSize(width: 1.1, height: 1.1)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 0.25)) {
                            self.scale = CGSize(width: 1, height: 1)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        playbackMode = .playing(.fromProgress(0, toProgress: 1, loopMode: .loop))
                    }
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
