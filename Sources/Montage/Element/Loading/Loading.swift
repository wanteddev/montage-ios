//
//  Loading.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/29/24.
//

import SwiftUI

import Lottie

public struct Loading: View {
    public enum `Type` {
        case wanted
        case circular
        
        func resourceName(_ colorScheme: ColorScheme) -> String {
            switch self {
            case .wanted: colorScheme == .light ? "loading-wanted-light.json" : "loading-wanted-dark.json"
            case .circular: colorScheme == .light ? "loading-circular-light.json" : "loading-circular-dark.json"
            }
        }
    }
    
    @Environment(\.colorScheme)  private var colorScheme
    
    private let subdirectory: String = Loading.subdirectory
    private let type: `Type`
    private let size: CGSize?

    public init(type: `Type`, size: CGSize? = nil) {
        self.type = type
        self.size = size
    }
    
    public var body: some View {
        LottieView(animation: .named(type.resourceName(colorScheme), subdirectory: subdirectory))
            .playing(loopMode: .loop)
            .if(size != nil) {
                $0.resizable()
                    .frame(width: size?.width, height: size?.height)
            }
    }
}

extension Loading {
    static var subdirectory: String { "montage-ios/Sources/Montage/Asset/Lottie" }
}
