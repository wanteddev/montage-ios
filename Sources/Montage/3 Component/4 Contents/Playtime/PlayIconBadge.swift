//
//  Playtime.swift
//  Montage
//
//  Created by 김삼열 on 1/14/25.
//

import SwiftUI

public struct PlayIconBadge: View {
    // MARK: - Types
    public enum Size: String, CaseIterable {
        case small, medium, large
    }
    
    // MARK: - Initiailizer
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        Image.montage(.play)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(SwiftUI.Color.alias(.staticWhite))
            .frame(width: playIconSize.width, height: playIconSize.height)
            .background {
                Group {
                    if alternative {
                        Circle()
                            .fill(SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.61))
                    } else {
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
                .frame(width: circleDiameter, height: circleDiameter)
            }
    }
    
    // MARK: - Modifiers
    private var size: Size = .medium
    private var alternative = false
    
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        return zelf
    }
    
    public func alternative(_ alternative: Bool = true) -> Self {
        var zelf = self
        zelf.alternative = alternative
        return zelf
    }
    
    // MARK: - private
    private var circleDiameter: CGFloat {
        switch size {
        case .small: 36
        case .medium: 60
        case .large: 80
        }
    }
    
    private var playIconSize: CGSize {
        switch size {
        case .small: CGSize(width: 24, height: 24)
        case .medium: CGSize(width: 40, height: 40)
        case .large: CGSize(width: 56, height: 56)
        }
    }
}
