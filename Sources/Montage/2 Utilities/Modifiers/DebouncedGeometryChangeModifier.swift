//
//  DebouncedGeometryChangeModifier.swift
//  Views
//
//  Created by 김삼열 on 2/27/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

struct DebouncedGeometryChangeModifier<T: Equatable>: ViewModifier {
    @State private var resizingTask: Task<(), Never>?
    
    private let type: T.Type
    private let transform: (GeometryProxy) -> T
    private let dueTime: ContinuousClock.Instant.Duration
    private let action: (_ newValue: T) -> Void

    init(
        for type: T.Type,
        of transform: @escaping (GeometryProxy) -> T,
        for dueTime: ContinuousClock.Instant.Duration,
        action: @escaping (_ newValue: T) -> Void
    ) {
        self.type = type
        self.transform = transform
        self.dueTime = dueTime
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onGeometryChange(for: type, of: transform) { newValue in
            resizingTask?.cancel()
            resizingTask = Task {
                do {
                    try await Task.sleep(for: dueTime)
                    try Task.checkCancellation()
                    action(newValue)
                } catch {
                }
            }
        }
    }
}
