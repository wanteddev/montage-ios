//
//  SectionHeader.swift
//  Montage
//
//  Created by 김삼열 on 1/17/25.
//

import SwiftUI

public struct SectionHeader: View {
    // MARK: - Types
    
    /// 사이즈를 나타내는 열거형입니다.
    public enum Size: String, CaseIterable {
        case xsmall, small, medium, large
    }
    
    // MARK: - Initializer
    
    private let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    // MARK: - Body
    @State private var contentSize: CGSize = .zero
    
    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 16) {
                    Text(title)
                        .montage(variant: variant, weight: .bold, color: titleColor)
                        .paragraph(variant: variant)
                        .multilineTextAlignment(.leading)
                        .layoutPriority(1)
                    
                    if let headingContent {
                        AnyView(headingContent())
                    }
                }
                    
                if let trailingContent {
                    Spacer(minLength: 16)
                    
                    AnyView(trailingContent())
                } else {
                    Spacer(minLength: 0)
                }
            }
            .frame(minHeight: height)
        }
    }
    
    // MARK: - Modifiers
    
    private var size: Size = .medium
    private var titleColor: SwiftUI.Color = .semantic(.labelStrong)
    private var headingContent: (() -> any View)? = nil
    private var trailingContent: (() -> any View)? = nil
    
    /// 사이즈를 조정합니다.
    public func size(_ size: Size) -> Self {
        var zelf = self
        zelf.size = size
        if size == .xsmall {
            zelf.titleColor = .semantic(.labelAlternative)
        }
        return zelf
    }
    
    /// 타이틀 텍스트의 색상을 조정합니다. 기본값은 `.semantic(.labelNormal)`입니다.
    public func titleColor(_ color: SwiftUI.Color) -> Self {
        var zelf = self
        zelf.titleColor = color
        return zelf
    }
    
    public func headingContent(_ content: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.headingContent = content
        return zelf
    }

    public func trailingContent(_ content: (() -> any View)? = nil) -> Self {
        var zelf = self
        zelf.trailingContent = content
        return zelf
    }

    // MARK: - private
    private var variant: Typography.Variant {
        switch size {
        case .xsmall:
            .label1
        case .small:
            .headline2
        case .medium:
            .heading2
        case .large:
            .title3
        }
    }
    
    private var height: CGFloat {
        switch size {
        case .xsmall:
            20
        case .small:
            24
        case .medium:
            28
        case .large:
            32
        }
    }
}
