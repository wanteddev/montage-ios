//
//  GroupAvatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

extension Avatar {
    /// Avatar를 묶는 컴포넌트로 여러 Avatar를 표시해야 하는 경우에 사용합니다.
    ///
    /// Avatar/Group이 위치한 배경색이 backgroundNormal이 아니라면
    /// 아바타의 구분선을 위해 배경색을 backgroundColor에 전달해야합니다.
    /// 기본값은 backgroundNormal 입니다.
    public struct Group: View {
        public enum Variant {
            case person([Avatar.Variant])
            case company([Avatar.Variant])
            case academic([Avatar.Variant])
        }
        
        public enum Size {
            case xsmall
            case small
            
            var space: CGFloat {
                switch self {
                case .xsmall: 6
                case .small: 8
                }
            }
        }
        
        private let variant: Variant
        private let size: Size
        /// Avatar들의 구분을 위한 구분선의 색
        private let separateBorderColor: SwiftUI.Color?
        
        @State private var width: CGFloat = .zero
        @State private var height: CGFloat = .zero
        
        public init(
            variant: Variant,
            size: Size,
            backgroundColor: SwiftUI.Color? = nil
        ) {
            self.variant = variant
            self.size = size
            separateBorderColor = backgroundColor
        }
        
        public var body: some View {
            ZStack {
                switch variant {
                case .person(let array):
                    ForEach(Array(array.indices).reversed(), id: \.self) { index in
                        let v: Avatar.Variant = array[index]
                        let s: Avatar.Size = {
                            size == .xsmall ? .xsmall : .small
                        }()
                        Avatar.Person(
                            variant: v,
                            size: s
                        )
                        .offset(x: s.componentSize.width * CGFloat(index) - (size.space * CGFloat(index)))
                        .background {
                            Circle()
                                .foregroundStyle(
                                    separateBorderColor ?? SwiftUI.Color
                                        .alias(.backgroundNormal)
                                )
                                .scaleEffect(1.1)
                                .offset(
                                    x: s.componentSize
                                        .width * CGFloat(index) - (size.space * CGFloat(index))
                                )
                        }
                        .task {
                            let count = CGFloat(array.count)
                            width = (s.componentSize.width * count) - (size.space * (count - 1))
                            height = s.componentSize.height
                        }
                    }
                case .company(let array):
                    ForEach(Array(array.indices).reversed(), id: \.self) { index in
                        let v: Avatar.Variant = array[index]
                        let s: Avatar.Size = {
                            size == .xsmall ? .xsmall : .small
                        }()
                        Avatar.Company(
                            variant: v,
                            size: s
                        )
                        .offset(x: s.componentSize.width * CGFloat(index) - (size.space * CGFloat(index)))
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(
                                    separateBorderColor ?? SwiftUI.Color
                                        .alias(.backgroundNormal)
                                )
                                .scaleEffect(1.1)
                                .offset(
                                    x: s.componentSize
                                        .width * CGFloat(index) - (size.space * CGFloat(index))
                                )
                        }
                        .task {
                            let count = CGFloat(array.count)
                            width = (s.componentSize.width * count) - (size.space * (count - 1))
                            height = s.componentSize.height
                        }
                    }
                case .academic(let array):
                    ForEach(Array(array.indices).reversed(), id: \.self) { index in
                        let v: Avatar.Variant = array[index]
                        let s: Avatar.Size = {
                            size == .xsmall ? .xsmall : .small
                        }()
                        Avatar.Academic(
                            variant: v,
                            size: s
                        )
                        .offset(x: s.componentSize.width * CGFloat(index) - (size.space * CGFloat(index)))
                        .background {
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(
                                    separateBorderColor ?? SwiftUI.Color
                                        .alias(.backgroundNormal)
                                )
                                .scaleEffect(1.1)
                                .offset(
                                    x: s.componentSize
                                        .width * CGFloat(index) - (size.space * CGFloat(index))
                                )
                        }
                        .task {
                            let count = CGFloat(array.count)
                            width = (s.componentSize.width * count) - (size.space * (count - 1))
                            height = s.componentSize.height
                        }
                    }
                }
            }
            .frame(width: width, height: height, alignment: .leading)
        }
    }
}

#Preview {
    Avatar.Group(variant: .academic([.icon, .icon, .icon]), size: .small)
}
