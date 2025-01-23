//
//  Skeleton.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/21/24.
//

import SwiftUI

public enum Skeleton {
    public struct SkeletonModifier<V: View>: ViewModifier {
        private var isPresented: Bool
        @ViewBuilder private let skeletonView: () -> V

        public init(isPresented: Bool, @ViewBuilder skeletonView: @escaping () -> V) {
            self.isPresented = isPresented
            self.skeletonView = skeletonView
        }
        
        @State var animationOpacity: CGFloat = 1
        
        public func body(content: Content) -> some View {
            if isPresented {
                skeletonView()
                    .opacity(animationOpacity)
                    .onChange(of: animationOpacity) { _ in
                        if animationOpacity == 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                    animationOpacity = 0.5
                                }
                            }
                        } else if animationOpacity == 0.5 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                    animationOpacity = 1
                                }
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            withAnimation(.timingCurve(0.42, 0, 0.58, 1, duration: 2)) {
                                animationOpacity = 0.5
                            }
                        }
                    }
            } else {
                content
            }
        }
    }
}
