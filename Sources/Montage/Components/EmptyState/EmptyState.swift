//
//  EmptyState.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

/// 콘텐츠가 빈 상태일 때 사용자의 이해를 돕기 위한 컴포넌트입니다.
///
/// > image, title과 button은 선택적으로 사용할 수 있습니다.
///
/// 컴포넌트가 기본적으로 화면 전체를 차지하므로 필요하다면
/// .frame modifier를 사용하여 크기를 조절하여 사용하시길 권장합니다.
public struct EmptyState<V: View, C: View>: View {
    private let image: (() -> V?)
    private let title: String?
    private let description: String
    private let button: (() -> C)
    
    public init(
        image: @escaping (() -> V?) = { nil as AnyView? },
        title: String? = nil,
        description: String,
        button: @escaping (() -> C) = { EmptyView() }
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.button = button
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Spacer()
            
            if let image = image() {
                image
                    .padding(.bottom, 8)
            }
            
            VStack(spacing: 12) {
                if let title {
                    HStack {
                        Spacer()
                        Text(title)
                            .montage(variant: .headline1, weight: .bold)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    Text(description)
                        .montage(variant: .body2, alias: .labelAlternative)
                        .paragraph(variant: .body2)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    Spacer()
                }
                
                button()
                    .padding(.top, 12)
            }
            .padding(.vertical, 12)
            
            if image() != nil {
                Spacer()
                    .frame(height: 20)
            }
            
            Spacer()
        }
    }
}

#Preview {
    EmptyState(
        title: "타이틀이 들어갈수도 있고, 안들어dasfasdasfasda갈 수 도 있어요.",
        description: "상황에 대한 설명이 들어fdsasdasfasdasfasdasf asdasfasdafasd가요.\n설명은 최대 두 줄로 작성해요."
    ) {
        Button.OutlinedButtonController(text: "텍스트")
            .fixedSize()
    }
}
