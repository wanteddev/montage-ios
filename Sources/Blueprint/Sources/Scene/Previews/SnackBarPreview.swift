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
    @State private var showTransparentChecker: Bool = false
    @State private var heading: String = "제목"
    @State private var description: String = "설명"
    @State private var snackBarModel: SnackBar.Model?
    @State private var showExtraContents: Bool = true
    @State private var locationOption: LocationOption = .bottom
    @State private var offset: Double = 0
    @State private var closeButtonEnabled: Bool = false

    enum LocationOption: String, CaseIterable {
        case top = "Top"
        case bottom = "Bottom"
    }

    var body: some View {
        ZStack {
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Options").bold()
                        Spacer()
                        Button(action: {
                            showTransparentChecker.toggle()
                        }) {
                            Image(systemName: "checkerboard.rectangle")
                                .foregroundColor(.semantic(.primaryNormal))
                        }
                    }
                    HStack {
                        Text("heading")
                        TextField(text: $heading)
                    }
                    HStack {
                        Text("description")
                        TextField(text: $description)
                    }
                    HStack {
                        Text("extraContents")
                        Switch(checked: showExtraContents) {
                            showExtraContents = $0
                        }
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
                    HStack {
                        Text("closeButton")
                        Switch(checked: closeButtonEnabled) { closeButtonEnabled = $0 }
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
            closeButtonEnabled: closeButtonEnabled,
            handler: {
                print("modify model nil to dismiss")
            }
        )
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

#Preview {
    SnackBarPreview()
}

