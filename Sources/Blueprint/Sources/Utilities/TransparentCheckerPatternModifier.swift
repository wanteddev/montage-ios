//
//  TransparentCheckerPatternModifier.swift
//  Views
//
//  Created by 김삼열 on 10/16/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

extension View {
    func transparentChecking(isPresented: Bool, checkerSize: CGFloat, checkerColor: Color, opacity: CGFloat = 0.5) -> some View {
        modifier(
            TransparentCheckerPatternModifier(
                isPresented: isPresented,
                checkerSize: checkerSize,
                color: checkerColor,
                opacity: opacity
            )
        )
    }
}

struct TransparentCheckerPatternModifier: ViewModifier {
    private let isPresented: Bool
    private let checkerSize: CGFloat
    private let checkerColor: Color
    private let opacity: CGFloat
    
    init(isPresented: Bool, checkerSize: CGFloat = 8, color: Color = .gray, opacity: CGFloat = 0.5) {
        self.isPresented = isPresented
        self.checkerSize = checkerSize
        self.checkerColor = color
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isPresented {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    
                    // 캐시된 체커 패턴 이미지 사용
                    Image(
                        uiImage: CheckerPatternCache.shared
                            .image(
                                for: CGSize(width: width, height: height),
                                checkerSize: checkerSize,
                                color: checkerColor,
                                opacity: opacity
                            )
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                }
                .ignoresSafeArea()
            }
            content
        }
    }
}

class CheckerPatternCache {
    static let shared = CheckerPatternCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(for size: CGSize, checkerSize: CGFloat, color: Color, opacity: CGFloat) -> UIImage {
        let colorKey = colorToHexString(color.opacity(opacity))
        let key = "\(size.width)x\(size.height)_\(checkerSize)_\(colorKey)" as NSString
        if let cached = cache.object(forKey: key) { return cached }
        let newImage = generateCheckerPattern(size: size, checkerSize: checkerSize, color: color, opacity: opacity)
        cache.setObject(newImage, forKey: key)
        return newImage
    }
    
    private func colorToHexString(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(
            format: "%02X%02X%02X%02X",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255),
            Int(alpha * 255)
        )
    }
    
    private func generateCheckerPattern(size: CGSize, checkerSize: CGFloat, color: Color, opacity: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // 흰색 배경
            cgContext.setFillColor(UIColor.white.cgColor)
            cgContext.fill(CGRect(origin: .zero, size: size))
            
            // 회색 체커 패턴
            cgContext.setFillColor(color.opacity(opacity).uiColor.cgColor)
            
            let rows = Int(size.height / checkerSize) + 1
            let cols = Int(size.width / checkerSize) + 1
            
            for row in 0..<rows {
                for col in 0..<cols {
                    if (row + col) % 2 == 1 {
                        let rect = CGRect(
                            x: CGFloat(col) * checkerSize,
                            y: CGFloat(row) * checkerSize,
                            width: checkerSize,
                            height: checkerSize
                        )
                        cgContext.fill(rect)
                    }
                }
            }
        }
    }
}
