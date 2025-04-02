//
//  Loading.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/29/24.
//

import SwiftUI

import Lottie

public struct Loading: View {
    
    // MARK: - Type
    
    public enum Kind {
        case wanted
        case circular
        
        func resourceName(_ colorScheme: ColorScheme) -> String {
            switch self {
            case .wanted: colorScheme == .light ? "loading-wanted-light.json" : "loading-wanted-dark.json"
            case .circular: colorScheme == .light ? "loading-circular-light.json" :
                "loading-circular-dark.json"
            }
        }
    }

    // MARK: - Initializer
    
    private let kind: Kind
    private let size: CGSize?

    public init(kind: Kind, size: CGSize? = nil) {
        self.kind = kind
        self.size = size
    }
    
    // MARK: - Modifiers
    private var foregroundColor: SwiftUI.Color?
    public func foregroundColor(_ color: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.foregroundColor = color
        return zelf
    }
    
    // MARK: - Body
    
    @Environment(\.colorScheme) private var colorScheme
    
    public var body: some View {
        LottieView(animation: .named(kind.resourceName(colorScheme), bundle: .module))
            .playing(loopMode: .loop)
            .if(size != nil) {
                $0.resizable()
                    .if(foregroundColor != nil) { $0.colorMultiply(foregroundColor!) }
                    .frame(width: size?.width, height: size?.height)
            }
    }
    
    struct LoadingViewModifier: ViewModifier {
        @Binding var isLoading: Bool
        let type: Loading.Kind
        let dimmedColor: SwiftUI.Color
        
        init(_ isLoading: Binding<Bool>, type: Loading.Kind, dimmedColor: SwiftUI.Color) {
            _isLoading = isLoading
            self.type = type
            self.dimmedColor = dimmedColor
        }
        
        @State var opacity: CGFloat = 0

        func body(content: Content) -> some View {
            ZStack {
                content
                    .userInteractionDisabled(isLoading)
                dimmedColor
                    .opacity(opacity)
                    .ignoresSafeArea()
                Loading(kind: type)
                    .if(isLoading)
            }
            .onChange(of: isLoading, perform: { newValue in
                opacity = newValue ? 0 : 1
                withAnimation {
                    opacity = newValue ? 1 : 0
                }
            })
        }
    }
}
