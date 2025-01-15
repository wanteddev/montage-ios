//
//  CounterPagination.swift
//  Montage
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI

extension Pagination {
    public struct Counter: View {
        public enum Size: String, CaseIterable {
            case normal, small
        }
        
        @Binding private var selectedPage: Int
        private let totalPages: Int
        public init(selectedPage: Binding<Int>, totalPages: Int) {
            _selectedPage = selectedPage
            self.totalPages = totalPages
        }
        
        public var body: some View {
            HStack(spacing: 4) {
                Text("\(selectedPage)")
                    .montage(
                        variant: typography,
                        weight: .bold,
                        color: .alias(.staticWhite).opacity(alternative ? 88 : 74)
                    )
                    .paragraph(variant: typography)
                Text("/")
                    .montage(
                        variant: typography,
                        weight: .regular,
                        color: .alias(.staticWhite).opacity(alternative ? 52 : 28)
                    )
                    .paragraph(variant: typography)
                Text("\(totalPages)")
                    .montage(
                        variant: typography,
                        weight: .bold,
                        color: .alias(.staticWhite).opacity(alternative ? 88 : 74)
                    )
                    .paragraph(variant: typography)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background {
                if alternative {
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.61))
                } else {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: height / 2))
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(SwiftUI.Color.atomic(.globalCoolNeutral30).opacity(0.43))
                    }
                }
            }
        }
        
        private var size: Size = .normal
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
        
        private var typography: Typography.Variant {
            switch size {
            case .normal: .body2
            case .small: .label2
            }
        }
        
        private var width: CGFloat {
            switch size {
            case .normal: 62
            case .small: 52
            }
        }
        
        private var height: CGFloat {
            switch size {
            case .normal: 34
            case .small: 26
            }
        }
        
        private var horizontalPadding: CGFloat {
            switch size {
            case .normal: 12
            case .small: 10
            }
        }
        
        private var verticalPadding: CGFloat {
            switch size {
            case .normal: 6
            case .small: 4
            }
        }
    }
}
