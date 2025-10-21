//
//  ColorPreview.swift
//  Blueprint
//
//  Created by AI Assistant on 2024/12/19.
//

import SwiftUI
import Montage

/// SwiftUI로 구현된 모든 색상(Atomic + Semantic)을 보여주는 ColorPreview
struct ColorPreview: View {
    @State private var selectedColorType: ColorType = .atomic
    @State private var showTransparentChecker = false
    
    enum ColorType: String, CaseIterable {
        case atomic = "Atomic"
        case semantic = "Semantic"
        case all = "All"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 컨트롤
            HStack {
                // 색상 타입 선택
                Picker("Color Type", selection: $selectedColorType) {
                    ForEach(ColorType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Spacer()
                
                // 투명도 체커 토글
                Button(action: {
                    showTransparentChecker.toggle()
                }) {
                    Image(systemName: showTransparentChecker ? "cube.transparent.fill" : "cube.transparent")
                        .foregroundColor(.semantic(.primaryNormal))
                }
            }
            .padding()
            .background(Color.semantic(.backgroundNormal))
            
            // 색상 목록
            ScrollView {
                LazyVStack(spacing: 24) {
                    switch selectedColorType {
                    case .atomic:
                        AtomicColorSections(showTransparentChecker: showTransparentChecker)
                    case .semantic:
                        SemanticColorSections(showTransparentChecker: showTransparentChecker)
                    case .all:
                        AtomicColorSections(showTransparentChecker: showTransparentChecker)
                        SemanticColorSections(showTransparentChecker: showTransparentChecker)
                    }
                }
                .padding()
            }
        }
    }
}

// MARK: - Atomic Color Sections
struct AtomicColorSections: View {
    let showTransparentChecker: Bool
    
    private let atomicColorGroups: [(String, [Montage.Color.Atomic])] = [
        ("Common", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("common") }),
        ("Neutral", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("neutral") }),
        ("Cool Neutral", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("coolNeutral") }),
        ("Blue", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("blue") }),
        ("Red", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("red") && !$0.rawValue.hasPrefix("redOrange") }),
        ("Green", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("green") }),
        ("Orange", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("orange") }),
        ("Lime", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("lime") }),
        ("Cyan", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("cyan") }),
        ("Light Blue", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("lightBlue") }),
        ("Violet", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("violet") }),
        ("Purple", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("purple") }),
        ("Pink", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("pink") }),
        ("Red Orange", Color.Atomic.allCases.filter { $0.rawValue.hasPrefix("redOrange") })
    ]
    
    var body: some View {
        ForEach(atomicColorGroups, id: \.0) { groupName, colors in
            if !colors.isEmpty {
                ColorSectionView(
                    title: "Atomic - \(groupName)",
                    colors: colors.map { atomicColor in
                        ColorItem(
                            name: atomicColor.rawValue,
                            color: .atomic(atomicColor),
                            showTransparentChecker: showTransparentChecker
                        )
                    }
                )
            }
        }
    }
}

// MARK: - Semantic Color Sections
struct SemanticColorSections: View {
    let showTransparentChecker: Bool
    
    private let semanticColorGroups: [(String, [Montage.Color.Semantic])] = [
        ("Primary", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "primary") }),
        ("Label", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "label") }),
        ("Background", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "background") }),
        ("Interaction", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "interaction") }),
        ("Line", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "line") }),
        ("Status", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "status") }),
        ("Accent Foreground", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "accentForeground") }),
        ("Accent Background", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "accentBackground") }),
        ("Inverse", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "inverse") }),
        ("Fill", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "fill") }),
        ("Material", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "material") }),
        ("Static", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "static") })
    ]
    
    var body: some View {
        ForEach(semanticColorGroups, id: \.0) { groupName, colors in
            if !colors.isEmpty {
                ColorSectionView(
                    title: "Semantic - \(groupName)",
                    colors: colors.map { semanticColor in
                        ColorItem(
                            name: semanticColor.rawValue,
                            color: .semantic(semanticColor),
                            showTransparentChecker: showTransparentChecker
                        )
                    }
                )
            }
        }
    }
}

// MARK: - Color Section View
struct ColorSectionView: View {
    let title: String
    let colors: [ColorItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.semantic(.labelStrong))
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 120, maximum: 200), spacing: 12)
            ], spacing: 12) {
                ForEach(colors, id: \.name) { colorItem in
                    ColorChipView(colorItem: colorItem)
                }
            }
        }
    }
}

// MARK: - Color Chip View
struct ColorChipView: View {
    let colorItem: ColorItem
    
    var body: some View {
        VStack(spacing: 8) {
            // 색상 칩
            RoundedRectangle(cornerRadius: 8)
                .fill(colorItem.color)
                .frame(height: 60)
                .modifier(TransparentCheckerPatternModifier(isPresented: colorItem.showTransparentChecker))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.semantic(.lineNormal), lineWidth: 1)
                )
            
            // 색상 이름
            Text(colorItem.name)
                .font(.system(size: 10))
                .foregroundColor(.semantic(.labelNormal))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
}

// MARK: - Color Item Model
struct ColorItem {
    let name: String
    let color: SwiftUI.Color
    let showTransparentChecker: Bool
}

// MARK: - Preview
#Preview {
    ColorPreview()
}
