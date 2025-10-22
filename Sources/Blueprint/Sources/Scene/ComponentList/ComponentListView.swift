//
//  ComponentListView.swift
//  Blueprint
//
//  Created by AI Assistant on 2025/10/21.
//  Copyright (c) 2025 WantedLab Inc.. All rights reserved.
//

import SwiftUI
import Montage

struct ComponentListView: View {
    @StateObject private var coordinator = ComponentListNavigationCoordinator()
    @State var searchText: String = ""
    
    var categoryItemSections: [ComponentSection] {
        ComponentCategory.allCases
            .map { category in
                ComponentSection(
                    category: category,
                    items: Component.allCases
                        .filter { $0.category == category }
                        .sorted {
                            $0.state < $1.state || $0.state == $1.state && $0.displayName < $1.displayName
                        }
                        .filter {
                            searchText.isEmpty
                            || $0.category.rawValue.lowercased().contains(searchText.lowercased())
                            || $0.displayName.lowercased().contains(searchText.lowercased())
                        }
                )
            }
    }
    
    @FocusState private var searchFocused
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if #available(iOS 18.0, *) {
                    list.searchFocused($searchFocused)
                } else {
                    list
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Blueprint")
            .toolbar(content: {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        (Text("powered by the Wanted Design System, ") + Text("Montage™").bold())
                            .typography(variant: .caption2, weight: .regular)
                    }
                }
            })
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Component.self) { componentType in
                coordinator.destinationView(for: componentType)
                    .navigationTitle(componentType.displayName)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                    searchFocused = true
                }
            }
        }
    }
    
    private var list: some View {
        List {
            ForEach(categoryItemSections) { categorySet in
                if !categorySet.items.isEmpty {
                    Section {
                        ForEach(categorySet.items) { componentType in
                            Button {
                                coordinator.navigate(to: componentType)
                            } label: {
                                ComponentItemRow(componentType: componentType)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.semantic(.backgroundNormal))
                        }
                    } header: {
                        Text(categorySet.category.displayName)
                            .font(.font(variant: .body1, weight: .bold))
                            .foregroundStyle(Color.semantic(.labelNormal))
                            .textCase(nil)
                    }
                }
            }
        }
        .listStyle(.plain)
        .background(Color.semantic(.backgroundNormal))
        .scrollContentBackground(.hidden)
    }
}

// MARK: - Component Item Row

extension ComponentListView {
    struct ComponentItemRow: View {
        let componentType: Component
        
        var body: some View {
            Text(componentType.displayName)
                .font(componentType.state.font ?? .body)
                .foregroundStyle(componentType.state.color)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.semantic(.backgroundNormal))
        }
    }
}

// MARK: - Model extensions

extension ComponentCategory {
    var displayName: String {
        let firstLetter = rawValue.prefix(1).uppercased()
        let remainingLetters = rawValue.dropFirst().map { $0.isUppercase ? " \($0)" : "\($0)" }
            .joined()
        return firstLetter + remainingLetters
    }
}

extension Component {
    var displayName: String {
        rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }
}

extension ComponentState: Comparable {
    static func < (_ lhs: ComponentState, _ rhs: ComponentState) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var color: SwiftUI.Color {
        switch self {
        case .pending:
            return SwiftUI.Color.semantic(.labelDisable)
        case .previewNotReady:
            return SwiftUI.Color.semantic(.statusCautionary)
        case .completed:
            return SwiftUI.Color.semantic(.statusPositive)
        }
    }
    
    var font: Font? {
        switch self {
        case .pending:
            return .font(variant: .body2, weight: .regular)
        case .previewNotReady:
            return .font(variant: .body1, weight: .regular)
        case .completed:
            return .font(variant: .body1, weight: .bold)
        }
    }
}

// MARK: - Previews
#Preview {
    ComponentListView()
}
