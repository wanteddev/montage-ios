//
//  Menu.swift
//  Montage
//
//  Created by Sanghoon Ahn on 8/19/24.
//

import SwiftUI

public struct Menu: View {
    public enum Variant {
        case normal
        case radio
        case checkbox
    }
    
    public typealias MenuData = (
        title: String,
        isOn: Bool,
        leftContent: Montage.Cell.LeftContent?,
        rightContent: Montage.Cell.RightContent?
    )
    public typealias MenuDataSource = [(title: String?, datas: [MenuModel])]

    private let dataSources: MenuDataSource
    private let variant: Variant
    private let scroll: Bool
    private let backgroundColor: SwiftUI.Color
    private let cell: (_ data: MenuModel, _ section: Int, _ index: Int) -> Cell

    public init(
        dataSources: MenuDataSource,
        variant: Variant = .normal,
        scroll: Bool = false,
        backgroundColor: SwiftUI.Color = .init(uiColor: .systemBackground),
        cell: @escaping (_ data: MenuModel, _ section: Int, _ index: Int) -> Cell
    ) {
        self.dataSources = dataSources
        self.variant = variant
        self.scroll = scroll
        self.backgroundColor = backgroundColor
        self.cell = cell
    }

    public var body: some View {
        if scroll {
            ScrollView {
                component(dataSources: dataSources)
            }
        } else {
            component(dataSources: dataSources)
        }
    }
    
    private func component(dataSources: MenuDataSource) -> some View {
        ForEach(dataSources.indices, id: \.self) { section in
            let dataSource = dataSources[section]
            LazyVStack(
                alignment: .leading,
                spacing: 4,
                pinnedViews: [.sectionHeaders]
            ) {
                Section {
                    ForEach(dataSource.datas.indices, id: \.self) { index in
                        let data = dataSource.datas[index]
                        cell(data, section, index)
                            .padding(.horizontal, 12)
                    }
                } header: {
                    if let title = dataSource.title {
                        Title(text: title)
                            .padding(.horizontal, 20)
                            .background(backgroundColor)
                    }
                }
            }
        }
    }
    
    private struct Title: View {
        var text: String
        
        var body: some View {
            Text(text)
                .montage(
                    variant: .caption1,
                    weight: .bold,
                    alias: .labelAlternative
                )
                .paragraph(variant: .caption1)
                .padding(.vertical, 4)
                .padding(.horizontal, 1)
                .frame(minWidth: .zero, maxWidth: .infinity, alignment: .leading)
        }
    }
}

extension Montage.Menu {
    public struct MenuModel {
        public let title: String
        public var isOn: Bool
        public var leftContent: Montage.Cell.LeftContent?
        public var rightContent: Montage.Cell.RightContent?
        
        public init(
            title: String,
            isOn: Bool,
            leftContent: Montage.Cell.LeftContent? = nil,
            rightContent: Montage.Cell.RightContent? = nil
        ) {
            self.title = title
            self.isOn = isOn
            self.leftContent = leftContent
            self.rightContent = rightContent
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        let data: [(String, [String])] = [
            ("제목", ["Test1", "Test2", "Test3"]),
            ("제목", ["Test1", "Test2", "Test3"]),
            ("제목", ["Test1", "Test2", "Test3"]),
        ]
        let menudata: Menu.MenuDataSource = data.map { section in
            (
                title: section.0,
                datas: section.1.map { row in
                    Montage.Menu.MenuModel(title: row, isOn: false, leftContent: nil, rightContent: nil)
                }
            )
        }
        return Menu(
            dataSources: menudata,
            variant: .normal,
            scroll: true,
            cell: { data, section, index in
                Cell(title: data.title) {
                    print("section: \(section), index: \(index)")
                }
                .padding(.pt12)
                .fillWidth(false)
                .divider(false)
                .bold(false)
                .disable(false)
            }
        )
    }
}
