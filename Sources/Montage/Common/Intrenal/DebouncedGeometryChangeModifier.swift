//
//  DebouncedGeometryChangeModifier.swift
//  Views
//
//  Created by 김삼열 on 2/27/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import Combine
import SwiftUI

struct DebouncedGeometryChangeModifier<T: Equatable>: ViewModifier {
    private let size: PassthroughSubject<T, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    private let type: T.Type
    private let transform: (GeometryProxy) -> T

    init(
        for type: T.Type,
        of transform: @escaping (GeometryProxy) -> T,
        for dueTime: RunLoop.SchedulerTimeType.Stride,
        action: @escaping (_ newValue: T) -> Void
    ) {
        self.type = type
        self.transform = transform
        size.debounce(for: dueTime, scheduler: RunLoop.main)
            .sink {
                action($0)
            }
            .store(in: &cancellables)
    }

    func body(content: Content) -> some View {
        content.onGeometryChange(for: type, of: transform) { newValue in
            size.send(newValue)
        }
    }
}
