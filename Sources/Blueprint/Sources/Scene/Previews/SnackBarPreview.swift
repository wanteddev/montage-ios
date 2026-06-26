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
    @State private var locationOption: LocationOption = .bottom
    @State private var offset: Double = 0
    @State private var closeButtonEnabled: Bool = false
    @State private var durationOption: DurationOption = .short

    enum LocationOption: String, CaseIterable, PreviewSegment {
        case top = "Top"
        case bottom = "Bottom"

        var selectableTitle: String { rawValue }
    }

    enum DurationOption: String, CaseIterable, PreviewSegment {
        case short = "Short"
        case long = "Long"
        case infinity = "Infinity"

        var selectableTitle: String { rawValue }

        var duration: SnackBar.Duration {
            switch self {
            case .short: return .short
            case .long: return .long
            case .infinity: return .infinity
            }
        }
    }

    var body: some View {
        PreviewLayout {
            Button(
                variant: .outlined,
                text: "Show Preview"
            ) {
                snackBarModel = .init(
                    duration: durationOption.duration,
                    heading: heading.isEmpty ? nil : heading,
                    description: description.isEmpty ? nil : description,
                    extraContents: {
                        if showExtraContents {
                            Image.icon(.company)
                                .foregroundColor(SwiftUI.Color.white)
                        }
                    },
                    action: "텍스트"
                )
            }
        } options: {
            TextFieldOptionRow("heading", text: $heading)
            TextFieldOptionRow("description", text: $description)
            ToggleOptionRow("extraContents", isOn: $showExtraContents)
            SegmentedOptionRow("location", selection: $locationOption)
            SliderOptionRow("offset", value: $offset, in: 0...200, step: 10)
            SegmentedOptionRow("duration", selection: $durationOption)
            ToggleOptionRow("closeButton", isOn: $closeButtonEnabled)
        }
        .snackBar(
            $snackBarModel,
            location: locationOption == .top ? .top(offset: offset) : .bottom(offset: offset),
            closeButtonEnabled: closeButtonEnabled,
            handler: {
                print("modify model nil to dismiss")
            }
        )
    }
}

#Preview {
    SnackBarPreview()
}

