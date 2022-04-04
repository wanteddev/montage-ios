//
//  CTABaseView.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/21.
//

import SwiftUI

/// CTAButton의 Content 이외의 Gradient 등이 구현되어있는 Base View 입니다.
struct CTABaseView<ContentView: View>: View {
    let contentView: ContentView
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 0.0) {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [backgroundColor.opacity(0.0), backgroundColor]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    maxWidth: .infinity,
                    idealHeight: 30.0,
                    maxHeight: 30.0,
                    alignment: Alignment.center
                )
            contentView
                .padding(
                    EdgeInsets(
                        top: 0.0,
                        leading: 15.0,
                        bottom: 15.0,
                        trailing: 15.0
                    )
                )
                .background(backgroundColor)
        }
    }
}
