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
    
    struct LoadingViewModifier: ViewModifier {
        @Binding var isLoading: Bool
        let type: Loading.Kind
        let dimmingNeeded: Bool
        
        init(_ isLoading: Binding<Bool>, type: Loading.Kind, dimmingNeeded: Bool) {
            self._isLoading = isLoading
            self.type = type
            self.dimmingNeeded = dimmingNeeded
        }
        
        @State var opacity: CGFloat = 0

        func body(content: Content) -> some View {
            ZStack {
                content
                    .interactionDisabled(isLoading)
                SwiftUI.Color.white.opacity(0.5)
                    .opacity(opacity)
                    .ignoresSafeArea()
                    .if(dimmingNeeded)
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
