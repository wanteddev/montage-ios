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
    // 패턴 이미지는 라이트/다크 배경색을 구워 넣은 비트맵이므로, 모드가 바뀌면 다시 그려야 한다.
    // 이 프로퍼티를 읽어야 모드 전환 시 body가 재평가된다.
    @Environment(\.colorScheme) private var colorScheme

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
                                opacity: opacity,
                                colorScheme: colorScheme
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
    
    func image(
        for size: CGSize,
        checkerSize: CGFloat,
        color: Color,
        opacity: CGFloat,
        colorScheme: ColorScheme
    ) -> UIImage {
        // 배경색이 다이나믹 컬러라 같은 크기·색이어도 라이트/다크 결과물이 다르다.
        // 키에 스타일을 넣지 않으면 모드를 바꿔도 이전 모드 이미지가 그대로 나온다.
        let traits = UITraitCollection(userInterfaceStyle: colorScheme == .dark ? .dark : .light)
        let colorKey = colorToHexString(color.opacity(opacity), traits: traits)
        let key = "\(size.width)x\(size.height)_\(checkerSize)_\(colorKey)_\(traits.userInterfaceStyle.rawValue)" as NSString
        if let cached = cache.object(forKey: key) { return cached }
        let newImage = generateCheckerPattern(
            size: size,
            checkerSize: checkerSize,
            color: color,
            opacity: opacity,
            traits: traits
        )
        cache.setObject(newImage, forKey: key)
        return newImage
    }

    private func colorToHexString(_ color: Color, traits: UITraitCollection) -> String {
        let uiColor = UIColor(color).resolvedColor(with: traits)
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

    private func generateCheckerPattern(
        size: CGSize,
        checkerSize: CGFloat,
        color: Color,
        opacity: CGFloat,
        traits: UITraitCollection
    ) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let cgContext = context.cgContext

            // 배경. 다이나믹 컬러는 그리는 시점의 UITraitCollection.current를 타므로 명시적으로 resolve한다.
            cgContext.setFillColor(UIColor.semantic(.backgroundNeutralPrimary).resolvedColor(with: traits).cgColor)
            cgContext.fill(CGRect(origin: .zero, size: size))

            // 체커 패턴
            cgContext.setFillColor(color.opacity(opacity).uiColor.resolvedColor(with: traits).cgColor)

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
