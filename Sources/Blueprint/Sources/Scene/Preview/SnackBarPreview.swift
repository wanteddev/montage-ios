//
//  SnackBarPreview.swift
//  Blueprint
//
//  Created by Ahn Sang Hoon on 6/27/24.
//  Copyright © 2024 WantedLab Inc. All rights reserved.
//

import Montage
import SwiftUI

struct SnackBarPreview: View {
    @State private var heading: String = "제목"
    @State private var description: String = "설명"
    @State private var snackBarModel: SnackBar.Model?
    @State private var showExtraContents: Bool = true
    @State private var showBackgroundImage: Bool = false
    @State private var locationOption: LocationOption = .bottom
    @State private var offset: Double = 0

    enum LocationOption: String, CaseIterable {
        case top = "Top"
        case bottom = "Bottom"
    }

    var body: some View {
        ZStack {
            if showBackgroundImage {
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
                        Text("extraContents")
                    }
                    Toggle(isOn: $showBackgroundImage) {
                        Text("show Background Image (for test)")
                    }
                    HStack {
                        Text("location")
                        Picker("Location", selection: $locationOption) {
                            ForEach(LocationOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    VStack(alignment: .leading) {
                        Text("offset: \(Int(offset))")
                        Slider(value: $offset, in: 0...200, step: 10)
                    }
                    Button(
                        variant: .outlined,
                        text: "스낵바 노출"
                    ) {
                        snackBarModel = .init(
                            heading: heading.isEmpty ? nil : heading,
                            description: description.isEmpty ? nil : description,
                            extraContents: {
                                if showExtraContents {
                                    Image.icon(.company)
                                        .foregroundColor(SwiftUI.Color.white)
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
            location: locationOption == .top ? .top(offset: offset) : .bottom(offset: offset),
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
