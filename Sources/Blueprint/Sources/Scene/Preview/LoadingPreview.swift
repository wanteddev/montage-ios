//
//  LoadingPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/14/24.
//

import SwiftUI
import Montage

struct LoadingPreview: View {
    @State var alertPresented: Bool = false
    @State var isLoading: Bool = false
    @State var loadingType: Loading.Kind = .circular
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("'로딩 시작'버튼을 눌러보세요.")
                
                Spacer()
                
                Rectangle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.clear)
                
                Button {
                    alertPresented.toggle()
                } label: {
                    Text("로딩 중에는 안눌려야 함")
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke()
                        .foregroundStyle(.gray)
                }
                
                Spacer()
            }
            .loading($isLoading, type: loadingType, dimmedColor: .semantic(.materialDimmer))
            
            VStack {
                VStack {
                    Control.radio(checked: loadingType == .circular) { _ in
                        loadingType = .circular
                    }
                    .label("circular")
                    Control.radio(checked: loadingType == .wanted) { _ in
                        loadingType = .wanted
                    }
                    .label("wanted")
                }
                .padding(28)
                Button {
                    isLoading.toggle()
                } label: {
                    Text(isLoading ? "로딩 종료" : "로딩 시작")
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke()
                        .foregroundStyle(.gray)
                }
            }
        }
        .alert(isLoading ? "😅지금은 얼럿이 뜨면 안되는데..??" : "👌지금은 얼럿 뜨는게 정상!ㅋㅋ", isPresented: $alertPresented) {
            
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    LoadingPreview()
}
