//
//  FallbackViewPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/25/24.
//

import SwiftUI
import Montage

struct FallbackViewPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var showImage: Bool = true
    @State private var showTitle: Bool = true
    @State private var showButton: Bool = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                
                FallbackView(
                    image: showImage ? {
                        AsyncImage(url: URL(string: "https://static.wanted.co.kr/images/error/lighthouse.png")) {
                            $0.image?.resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.horizontal, 20)
                        }
                        .frame(height: 320)
                    } : nil,
                    title: showTitle ? "타이틀이 들어갈수도 있고, 안들어갈 수도 있어요." : nil,
                    description: "상황에 대한 설명이 들어가요.\n설명은 최대 두 줄로 작성해요."
                ) {
                    Group {
                        if showButton {
                            Button(variant: .outlined, text: "텍스트")
                        }
                    }
                }
                
                Text("Options").bold()
                
                HStack {
                    Text("Image")
                    Switch(checked: showImage) { showImage = $0 }
                    Text("Title")
                    Switch(checked: showTitle) { showTitle = $0 }
                    Text("Button")
                    Switch(checked: showButton) { showButton = $0 }
                }
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    FallbackViewPreview()
}
