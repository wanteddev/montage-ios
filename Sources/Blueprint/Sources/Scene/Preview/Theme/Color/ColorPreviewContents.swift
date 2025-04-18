//
//  ColorPreviewContents.swift
//  Blueprint
//
//  Created by Euigyom Kim on 2023/01/18.
//  Copyright © 2023 WantedLab Inc. All rights reserved.
//

import UIKit
import Montage

final class ColorPreviewContents {
    private struct AtomicColorGroup {
        let groupName: String
        let colorSets: [Color.Atomic]
    }
    
    private struct SemanticColorGroup {
        let groupName: String
        let colorSets: [Color.Semantic]
    }
    
    private let atomicColorSet: [AtomicColorGroup] = [
        .init(
            groupName: "Common",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "common") }
        ),
        .init(
            groupName: "Netural",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "neutral") }
        ),
        .init(
            groupName: "Cool Neutral",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "coolNeutral") }
        ),
        .init(
            groupName: "Red",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "red") }
        ),
        .init(
            groupName: "Red Orange",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "redOrange") }
        ),
        .init(
            groupName: "Orange",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "orange") }
        ),
        .init(
            groupName: "Lime",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "lime") }
        ),
        .init(
            groupName: "Green",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "green") }
        ),
        .init(
            groupName: "Cyan",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "cyan") }
        ),
        .init(
            groupName: "Light Blue",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "lightBlue") }
        ),
        .init(
            groupName: "Blue",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "blue") }
        ),
        .init(
            groupName: "Violet",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "violet") }
        ),
        .init(
            groupName: "Purple",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "purple") }
        ),
        .init(
            groupName: "Pink",
            colorSets: Color.Atomic.allCases.filter { $0.name.starts(with: "pink") }
        )
    ]
    
    private let sementicColorSet: [SemanticColorGroup] = [
        .init(
            groupName: "Primary",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "primary") }
        ),
        .init(
            groupName: "Label",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "label") }
        ),
        .init(
            groupName: "Background",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "background") }
        ),
        .init(
            groupName: "Interaction",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "interaction") }
        ),
        .init(
            groupName: "Line",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "line") }

        ),
        .init(
            groupName: "Status",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "status") }
        ),
        .init(
            groupName: "Accent",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "accent") }
        ),
        .init(
            groupName: "Inverse",
            colorSets: Color.Semantic.allCases.filter { $0.name.starts(with: "inverse") }
        )
    ]
    
    enum ColorType: String, CaseIterable {
        case atomic, sementic
    }
    
    var currentColorType: ColorType = .atomic
    var usingTransparentCheck: Bool = false
    
    var colorTypeNames: [String] {
        ColorType.allCases.map(\.rawValue.capitalized)
    }
    
    func fetchColorSets() -> [ColorPreview.ColorPreviewSet] {
        switch currentColorType {
        case .atomic:
            return atomicColorSet.map { colorGroup in
                .init(
                    name: colorGroup.groupName,
                    colors: colorGroup.colorSets.map { colorSet in
                        .init(
                            name: colorSet.name.trimmingCharacters(in: .letters),
                            color: .atomic(colorSet),
                            axis: .vertical
                        )
                    },
                    axis: .horizontal
                )
            }
        case .sementic:
            return sementicColorSet.map { colorGroup in
                .init(
                    name: colorGroup.groupName,
                    colors: colorGroup.colorSets.map { colorSet in
                        .init(
                            name: colorSet.name,
                            color: .semantic(colorSet),
                            axis: .horizontal
                        )
                    },
                    axis: .vertical
                )
            }
        }
    }
}
