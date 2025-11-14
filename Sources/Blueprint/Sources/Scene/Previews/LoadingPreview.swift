//
//  LoadingPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 11/14/24.
//

import SwiftUI
import Montage

struct LoadingPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State var alertPresented: Bool = false
    @State var isLoading: Bool = false
    @State var loadingType: Loading.Kind = .circular()
    @State var color: SwiftUI.Color = .clear
    @State var dimmer: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
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
                .padding(.horizontal)
                
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
            .loading($isLoading, type: loadingType, dimmedColor: dimmer ? .semantic(.materialDimmer) : .clear)
            
            VStack(alignment: .leading) {
                Text("Options").bold()
                HStack {
                    Text("type")
                    Control.radio(checked: loadingType.isCircular) { _ in
                        loadingType = .circular(color: color == .clear ? nil : color)
                    }
                    .label("circular")
                    Control.radio(checked: !loadingType.isCircular) { _ in
                        loadingType = .wanted
                    }
                    .label("wanted")
                }
                if loadingType.isCircular {
                    ColorPicker("color", selection: $color)
                        .onChange(of: color) { newValue in
                            if loadingType.isCircular {
                                loadingType = .circular(color: color)
                            }
                        }
                }
                HStack {
                    Text("dimmer")
                    Control.switch(checked: dimmer) { newValue in
                        dimmer = newValue
                    }
                }
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
            .padding(.horizontal)
        }
        .alert(isLoading ? "😅지금은 얼럿이 뜨면 안되는데..??" : "👌지금은 얼럿 뜨는게 정상!ㅋㅋ", isPresented: $alertPresented) {
            
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

extension Loading.Kind {
    var isCircular: Bool {
        if case .circular = self {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    LoadingPreview()
}
