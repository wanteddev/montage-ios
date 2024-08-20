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
        leftContent: Montage.List.Element.LeftContent?,
        rightContent: Montage.List.Element.RightContent?
    )
    public typealias MenuDataSource = [(title: String?, datas: [MenuModel])]

    private let dataSources: MenuDataSource
    private let variant: Variant
    private let scroll: Bool
    private let backgroundColor: SwiftUI.Color
    private let cellConfiguration: Montage.List.Cell.Configration
    private let elementConfiguration: Montage.List.Element.Configuration
    private let handler: ((Int, Int) -> Void)?

    public init(
        dataSources: MenuDataSource,
        variant: Variant = .normal,
        scroll: Bool = false,
        backgroundColor: SwiftUI.Color = .init(uiColor: .systemBackground),
        cellConfiguration: Montage.List.Cell.Configration,
        elementConfiguration: Montage.List.Element.Configuration,
        handler: ((Int, Int) -> Void)? = nil
    ) {
        self.dataSources = dataSources
        self.variant = variant
        self.scroll = scroll
        self.backgroundColor = backgroundColor
        self.cellConfiguration = cellConfiguration
        self.elementConfiguration = elementConfiguration
        self.handler = handler
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
                        Cell(
                            cellConfiguration: cellConfiguration,
                            elementConfiguration: elementConfiguration,
                            variant: variant,
                            data: data,
                            leftContent: data.leftContent,
                            rightContent: data.rightContent
                        ) {
                            handler?(section, index)
                        }
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
    
    private struct Cell: View {
        var cellConfiguration: Montage.List.Cell.Configration
        var elementConfiguration: Montage.List.Element.Configuration

        var variant: Variant
        var data: MenuModel
        
        var leftContent: List.Element.LeftContent?
        var leftContentFromVariant: List.Element.LeftContent? {
            switch variant {
            case .normal: nil
            case .radio: .radio(data.isOn)
            case .checkbox: .check(data.isOn)
            }
        }
        var rightContent: Montage.List.Element.RightContent?
        var handler: (() -> Void)?
        
        var body: some View {
            List.Cell(
                model: .init(
                    configuration: cellConfiguration,
                    elementModel: .init(
                        configuration: elementConfiguration,
                        title: data.title,
                        leftContent: leftContent == nil ? leftContentFromVariant : leftContent,
                        rightContent: rightContent,
                        handler: { handler?() }
                    )
                )
            )
            .padding(.horizontal, 12)
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
        public var leftContent: Montage.List.Element.LeftContent?
        public var rightContent: Montage.List.Element.RightContent?
        
        public init(
            title: String,
            isOn: Bool,
            leftContent: Montage.List.Element.LeftContent? = nil,
            rightContent: Montage.List.Element.RightContent? = nil
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
        let data = [
            ("제목", ["1", "2", "3"]),
            ("제목", ["1", "2", "3"]),
            ("제목", ["1", "2", "3"]),
        ]
        let menudata: Menu.MenuDataSource = data.map { section in
            (
                section.0,
                section.1.map { row in
                        .init(title: row, isOn: false, leftContent: nil, rightContent: nil)
                }
            )
        }
        return Menu(
            dataSources: menudata,
            variant: .normal,
            scroll: true,
            cellConfiguration: .init(
                padding: .normal,
                paddingInset: false,
                divider: false
            ),
            elementConfiguration: .init(
                variant: .normal,
                caption: nil,
                bold: false,
                disable: false
            ),
            handler: {
                print("section: \($0), index: \($1)")
            }
        )
    }
}
