//
//  SnackBarPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 6/27/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

struct SnackBarPreview: View {
    @State private var heading: String = "제목"
    @State private var description: String = "설명"
    @State private var snackBarModel: SnackBar.Model?
    @State private var showExtraContents: Bool = true
    @State private var showPlaceholder: Bool = false
    
    var body: some View {
        ZStack {
            if showPlaceholder {
                VStack {
                    Spacer()
                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                }
            }
            VStack(spacing: 25) {
                VStack {
                    Text("Options").bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("heading")
                        TextField(text: $heading)
                    }
                    HStack {
                        Text("description")
                        TextField(text: $description)
                    }
                    Toggle(isOn: $showExtraContents) {
                        Text("extral contents(icon)")
                    }
                    Toggle(isOn: $showPlaceholder) {
                        Text("show snackBar placeholder")
                    }
                    Button.outlined(
                        text: "스낵바 노출"
                    ) {
                        snackBarModel = .init(
                            heading: heading.isEmpty ? nil : heading,
                            description: description.isEmpty ? nil : description,
                            extraContents: {
                                Group {
                                    if showExtraContents {
                                        Image.icon(.company)
                                            .foregroundColor(SwiftUI.Color.white)
                                    }
                                }
                            },
                            action: "액션"
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .snackBar(
            $snackBarModel,
            handler: {
                print("modify model nil to dismiss")
            }
        )
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    SnackBarPreview()
}
