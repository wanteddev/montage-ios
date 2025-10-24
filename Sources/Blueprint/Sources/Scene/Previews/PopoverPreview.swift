//
//  PopoverPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 10/22/25.
//

import SwiftUI
import Montage

struct PopoverPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var isPresented: Bool = false
    @State private var variantIndex: Int = 0
    @State private var text: String = "메시지에 마침표를 찍어요."
    @State private var heading: String = ""
    @State private var closeButton: Bool = true
    @State private var action: Bool = true
    @State private var subAction: Bool = false
    @State private var page: Int = 1
    
    let variants = ["normal", "custom"]
    let imageUrls = [
        "https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y3V0ZSUyMGNhdHxlbnwwfHwwfHx8MA%3D%3D&fm=jpg&q=60&w=3000",
        "https://media.4-paws.org/d/2/5/f/d25ff020556e4b5eae747c55576f3b50886c0b90/cut%20cat%20serhio%2002-1813x1811-720x719.jpg",
        "https://i.pinimg.com/736x/c3/bc/9b/c3bc9be28c74848841256c867da9fb43.jpg"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                
                VStack(spacing: 24) {
                    Button(color: .primary, size: .medium, text: "Show") {
                        isPresented = true
                    }
                    .modifying {
                        if variantIndex == 0 {
                            $0.popoverNormal(
                                isPresented: $isPresented,
                                heading: heading,
                                text: text,
                                closeButton: closeButton,
                                action: action ? (title: "행동", action: {
                                    print("Action tapped")
                                    isPresented = false
                                }) : nil,
                                subAction: subAction ? (title: "보조행동", action: {
                                    print("SubAction tapped")
                                    isPresented = false
                                }) : nil
                            )
                        } else {
                            $0.popoverCustom(isPresented: $isPresented) {
                                popoverContent
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                optionSheet
                    .padding(.horizontal)
            }
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 201, checkerColor: .red)
    }
    
    @ViewBuilder
    private var popoverContent: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Thumbnail(
                    urlString: imageUrls[safe: page - 1] ?? imageUrls[0],
                    ratio: .r3x2
                )
                IconButton(variant: .background(size: 20), icon: .closeThick) {
                    isPresented = false
                }
                    .padding(.all, 14)
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("인재의 추가 정보를 확인하세요.")
                        .paragraph(variant: .headline2, weight: .bold, semantic: .labelNormal)
                    Text("적극적으로 구직 중인, 다른 회사가 주목하는, 우리 회사에 관심있는 인재를 알 수 있어요.")
                        .paragraph(variant: .body2Reading, weight: .medium, semantic: .labelNeutral)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                HStack(alignment: .bottom) {
                    DotPagination(selectedPage: $page, totalPages: imageUrls.count)
                        .size(.small)
                    Spacer()
                    Button(variant: .outlined, color: .assistive, size: .medium, text: "확인")
                }
            }
            .padding(20)
        }
        .frame(width: 300)
        .background(.ultraThinMaterial)
        .background(SwiftUI.Color.semantic(.backgroundElevated).opacity(0.88))
    }
    
    private var optionSheet: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Options").bold()
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("variant")
                    SegmentedControl(
                        selectedIndex: $variantIndex,
                        labels: variants
                    )
                    .size(.small)
                }
                if variantIndex == 0 {
                    HStack {
                        Text("heading")
                        TextField(text: $heading)
                    }
                    
                    HStack {
                        Text("text")
                        TextArea(text: $text)
                    }
                    
                    HStack {
                        Text("closeButton")
                        Control.switch(checked: closeButton) { closeButton = $0 }
                        Text("action")
                        Control.switch(checked: action) { action = $0 }
                        Text("subAction")
                        Control.switch(checked: subAction) { subAction = $0 }
                    }
                }
            }
            .font(.caption)
        }
    }
}

#Preview {
    PopoverPreview()
}

