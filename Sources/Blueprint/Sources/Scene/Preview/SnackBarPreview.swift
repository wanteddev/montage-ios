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
    @State private var heading: String = ""
    @State private var description: String = ""
    @State private var snackBarModel: SnackBar.Model?
    @State private var showExtraContents: Bool = false
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
                    TextField(text: $heading)
                    TextField(text: $description)
                    Toggle(isOn: $showExtraContents) {
                        Text("extral contents(icon)")
                            .typographyNew(semantic: .labelAssistive)
                    }
                    Toggle(isOn: $showPlaceholder) {
                        Text("show snackBar placeholder")
                            .typographyNew(semantic: .labelAssistive)
                    }
                }
                .padding(.horizontal, 20)
                Button.outlined(
                    text: "스낵바 노출"
                ) {
                    snackBarModel = .init(
                        heading: heading.isEmpty ? nil : heading,
                        description: description.isEmpty ? nil : description,
                        extraContents: {
                            showExtraContents ? Image.icon(.company) : nil
                        },
                        action: "액션"
                    )
                }
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
