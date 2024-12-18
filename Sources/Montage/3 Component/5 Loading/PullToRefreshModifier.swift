//
//  PullToRefreshView.swift
//  Montage
//
//  Created by 김삼열 on 12/18/24.
//

import SwiftUI
import Lottie

public struct PullToRefreshModifier: ViewModifier {
    @State private var scrollViewOffset: CGFloat = 0
    @State private var isScrolling: Bool = false
    @State private var phase: WantedProgressView.Phase = .pulledDown(ratio: 0)
    
    @State private var progressViewHeight: CGFloat = .zero
    @State private var pullToRefreshViewHeight: CGFloat = .zero
    @State private var scale: CGSize = CGSize(width: 1, height: 1)
    @State private var opacity: Double = 1
    @State private var task: Task<Void, Never>?
    
    private var thresholdToStartAnimating: CGFloat { progressViewHeight / 2 }
    private let thresholdToShowCompletely: CGFloat = 40
    private var thresholdToRefresh: CGFloat { progressViewHeight * 4 }
    
    private var pullDownRatio: CGFloat {
        max(0, scrollViewOffset - thresholdToStartAnimating) / max(1, thresholdToRefresh - thresholdToStartAnimating)
    }
    
    private let refreshData: () async -> Void
    public init(refreshData: @escaping () async -> Void) {
        self.refreshData = refreshData
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) { //(spacing: 0) {
            WantedProgressView(phase: $phase)
                .opacity(opacity)
                .scaleEffect(scale)
                .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: {
                    progressViewHeight = $0
                })
                .fixedSize()
                .frame(height: max(pullToRefreshViewHeight, 0))
                .clipped()
            
            OffsettableScrollView(onOffsetChanged: { offset in
                scrollViewOffset = offset.y
            }) {
                VStack(spacing: 0) {
                    if phase.refreshInProgress && !isScrolling {
                        SwiftUI.Color.clear
                            .frame(height: pullToRefreshViewHeight)
                    }
                    
                    content
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: .local)
                    .onChanged({ _ in
                        isScrolling = true
                    })
                    .onEnded({ value in
                        isScrolling = false
                        withAnimation {
                            pullToRefreshViewHeight = progressViewHeight
                        }
                    })
            )
        }
        .onChange(of: scrollViewOffset) { scrollPosition in
            if !phase.refreshInProgress {
                print(scrollPosition)
                pullToRefreshViewHeight = scrollPosition
                phase = .pulledDown(ratio: pullDownRatio)
            }
        }
        .onChange(of: phase) { phase in
            switch phase {
            case .idle:
                opacity = 1
            case .pulledDown(let ratio):
                if ratio > 1 {
                    self.phase = .refreshing
                }
            case .refreshing:
                task?.cancel()
                task = Task {
                    await refreshData()
                    self.phase = .ending
                }
            default: break
            }
        }
    }
}

struct WantedProgressView: View {
    enum Phase: Equatable {
        case idle, pulledDown(ratio: CGFloat), refreshing, ending
        
        var refreshInProgress: Bool {
            switch self {
            case .idle, .pulledDown: return false
            default: return true
            }
        }
        
        var nowRefreshing: Bool {
            switch self {
            case .refreshing: return true
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
    
    var body: some View {
        LottieView(animation: .named(jsonName, bundle: .module))
            .playbackMode(playbackMode)
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
                        self.scale = CGSize(width: 1.025, height: 1.025)
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
                    playbackMode = .playing(.fromProgress(1, toProgress: 1, loopMode: .playOnce))
                    withAnimation(.timingCurve(0.25, 0.1, 0.25, 1, duration: 0.5)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            self.phase = .idle
                        }
                    }
                }
            }
    }
    
    private var jsonName: String {
        if phase.refreshInProgress {
            "pullToRefresh-pulse"
        } else {
            "pullToRefresh-pull"
        }
    }
}
