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
    @State private var selectedColorTypeIndex: Int = 0
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
                SegmentedIndexRow(index: $selectedColorTypeIndex, labels: ColorType.allCases.map(\.rawValue))
                
                Spacer()
                
                // 투명도 체커 토글
                Button(action: {
                    showTransparentChecker.toggle()
                }) {
                    Image(systemName: "checkerboard.rectangle")
                }
                .disabled(ColorType.allCases[selectedColorTypeIndex] == .atomic)
            }
            .padding()
            .background(Color.semantic(.backgroundNeutralPrimary))
            
            // 색상 목록
            ScrollView {
                // NOTE: ScrollView 안에서 LazyVStack(지연) + LazyVGrid(.adaptive, 지연)를
                // 이중 중첩하면 스크롤 시 adaptive 열 수 재계산이 상위 레이아웃으로 되먹임되어
                // AttributeGraph 사이클/행(hang)이 발생한다. 그룹 헤더는 소수이므로 바깥은
                // 비지연 VStack으로 두고, 칩 단위 지연은 안쪽 LazyVGrid가 담당한다.
                VStack(spacing: 24) {
                    switch ColorType.allCases[selectedColorTypeIndex] {
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
        ("Foreground", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "foreground") }),
        ("Background", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "background") }),
        ("Surface", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "surface") }),
        ("Line", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "line") }),
        ("Effect", Color.Semantic.allCases.filter { $0.rawValue.starts(with: "effect") }),
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
                .foregroundColor(.semantic(.foregroundNeutralStrong))
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
                .modifier(TransparentCheckerPatternModifier(isPresented: colorItem.showTransparentChecker))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.semantic(.lineNeutralPrimary), lineWidth: 1)
                )
            
            // 색상 이름
            Text(colorItem.name)
                .font(.system(size: 10))
                .foregroundColor(.semantic(.foregroundNeutralPrimary))
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
