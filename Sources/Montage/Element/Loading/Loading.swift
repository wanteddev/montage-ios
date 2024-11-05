//
//  Loading.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/29/24.
//

import SwiftUI

import Lottie

public struct Loading: View {
    public enum Kind {
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
    private let kind: Kind
    private let size: CGSize?

    public init(kind: Kind, size: CGSize? = nil) {
        self.kind = kind
        self.size = size
    }
    
    public var body: some View {
        LottieView(animation: .named(kind.resourceName(colorScheme), bundle: .module))
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
