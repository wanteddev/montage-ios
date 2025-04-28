//
//  SwiftUIView.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

extension Card {
    /// 썸네일과 콘텐츠를 포함하는 기본 카드 컴포넌트입니다.
    ///
    /// 썸네일 이미지와 제목, 캡션 등의 텍스트 콘텐츠를 수직 방향으로 배치한 카드입니다.
    /// 스켈레톤 로딩 상태를 지원하고, 썸네일 위에 오버레이 콘텐츠를 표시할 수 있습니다.
    ///
    /// **사용 예시**:
    /// ```swift
    /// @State private var isLoading = false
    ///
    /// Card.Normal(
    ///     thumbnail: { Thumbnail(.image(Image("sample"))) },
    ///     skeleton: $isLoading,
    ///     title: { Text("카드 제목").montage(variant: .heading3) }
    /// )
    /// .caption { Text("부제목").montage(variant: .body2) }
    /// .overlay(caption: "New", buttonIcon: .heart)
    /// ```
    ///
    /// - Note: 썸네일 이미지는 둥근 모서리로 표시되며, 콘텐츠 영역의 너비는 썸네일 너비에 맞춰집니다.
    public struct Normal: View {
        
        // MARK: - Initializer
        
        private let thumbnail: () -> Thumbnail
        @Binding private var skeleton: Bool
        private let title: () -> any View

        /// Normal 카드를 초기화합니다.
        ///
        /// - Parameters:
        ///   - thumbnail: 카드에 표시할 썸네일 이미지
        ///   - skeleton: 스켈레톤 로딩 상태 바인딩
        ///   - title: 카드 제목으로 표시할 뷰
        public init(
            thumbnail: @escaping () -> Thumbnail,
            skeleton: Binding<Bool>,
            title: @escaping () -> any View
        ) {
            self.thumbnail = thumbnail
            _skeleton = skeleton
            self.title = title
        }
        
        // MARK: - Modifiers
        
        private var caption: (() -> any View)?
        private var overlayCaption: String?
        private var extraCaption: (() -> any View)?
        private var overlayButtonIcon: Montage.Icon?
        private var onTapOverlayButton: (() -> Void)?
        private var topContent: (() -> any View)?
        private var bottomContent: (() -> any View)?
        
        /// 카드의 캡션(부제목)을 설정합니다.
        ///
        /// - Parameter caption: 표시할 캡션 뷰를 반환하는 클로저
        /// - Returns: 수정된 카드 인스턴스
        public func caption(_ caption: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.caption = caption
            return zelf
        }
        
        /// 카드의 추가 캡션을 설정합니다.
        ///
        /// - Parameter extraCaption: 표시할 추가 캡션 뷰를 반환하는 클로저
        /// - Returns: 수정된 카드 인스턴스
        public func extraCaption(_ extraCaption: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.extraCaption = extraCaption
            return zelf
        }
        
        /// 썸네일에 오버레이할 콘텐츠를 설정합니다.
        ///
        /// - Parameters:
        ///   - caption: 오버레이에 표시할 텍스트
        ///   - buttonIcon: 오버레이에 표시할 버튼 아이콘
        ///   - onTapButton: 버튼 탭 시 실행할 액션
        /// - Returns: 수정된 카드 인스턴스
        public func overlay(
            caption: String? = nil,
            buttonIcon: Montage.Icon? = nil,
            onTapButton: (() -> Void)? = nil
        ) -> Self {
            var zelf = self
            zelf.overlayCaption = caption
            zelf.overlayButtonIcon = buttonIcon
            zelf.onTapOverlayButton = onTapButton
            return zelf
        }
        
        /// 카드 상단에 표시할 콘텐츠를 설정합니다.
        ///
        /// - Parameter content: 상단에 표시할 콘텐츠 뷰를 반환하는 클로저
        /// - Returns: 수정된 카드 인스턴스
        public func topContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.topContent = content
            return zelf
        }
        
        /// 카드 하단에 표시할 콘텐츠를 설정합니다.
        ///
        /// - Parameter content: 하단에 표시할 콘텐츠 뷰를 반환하는 클로저
        /// - Returns: 수정된 카드 인스턴스
        public func bottomContent(_ content: (() -> any View)? = nil) -> Self {
            var zelf = self
            zelf.bottomContent = content
            return zelf
        }
        
        // MARK: - Body
        @State private var thumbnailWidth: CGFloat = 0
        
        public var body: some View {
            Grid(alignment: .leading, verticalSpacing: 12) {
                GridRow {
                    thumbnail()
                        .radius()
                        .border()
                        .modifier(
                            ThumbnailOverlayModifier(
                                caption: overlayCaption,
                                buttonIcon: overlayButtonIcon,
                                onTapButton: onTapOverlayButton
                            )
                        )
                        .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 12))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .onGeometryChange(for: CGFloat.self, of: { $0.size.width }, action: { thumbnailWidth = $0 })
                
                GridRow {
                    VStack(alignment: .leading, spacing: 8) {
                        if let topContent {
                            AnyView(topContent())
                                .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 3), size: CGSize(width: 48, height: 20))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            AnyView(title())
                                .skeleton(isPresented: skeleton, kind: .text(lengths: [._100]), size: CGSize(width: thumbnailWidth - 12, height: 20))
                            
                            if let caption {
                                AnyView(caption())
                                    .skeleton(isPresented: skeleton, kind: .text(lengths: [._50]), size: CGSize(width: thumbnailWidth - 12, height: 14))
                            }
                            
                            if let extraCaption {
                                AnyView(extraCaption())
                                    .skeleton(isPresented: skeleton, kind: .text(lengths: [._25]), size: CGSize(width: thumbnailWidth - 12, height: 14))
                            }
                        }
                        
                        if let bottomContent {
                            AnyView(bottomContent())
                                .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 3), size: CGSize(width: 48, height: 20))
                        }
                    }
                    .padding(.horizontal, 6)
                    .frame(maxWidth: thumbnailWidth, alignment: .leading)
                }
            }
        }
    }
}

extension Card.Normal {
    /// 썸네일 이미지 위에 그라데이션 오버레이와 콘텐츠를 표시하는 모디파이어입니다.
    ///
    /// 썸네일 상단에 어두운 그라데이션 배경과 함께 캡션 텍스트, 버튼 등을 표시합니다.
    /// 주로 썸네일에 추가 정보나 액션 버튼을 제공하기 위해 사용됩니다.
    ///
    /// - Note: 그라데이션은 위에서 아래로 점점 투명해지는 형태로 적용됩니다.
    private struct ThumbnailOverlayModifier: ViewModifier {
        private let caption: String?
        private let buttonIcon: Montage.Icon?
        private let onTapButton: (() -> Void)?

        /// 오버레이 모디파이어를 초기화합니다.
        ///
        /// - Parameters:
        ///   - caption: 오버레이에 표시할 텍스트
        ///   - buttonIcon: 오버레이에 표시할 버튼 아이콘
        ///   - onTapButton: 버튼 탭 시 실행할 액션
        public init(
            caption: String? = nil,
            buttonIcon: Montage.Icon? = nil,
            onTapButton: (() -> Void)? = nil
        ) {
            self.caption = caption
            self.buttonIcon = buttonIcon
            self.onTapButton = onTapButton
        }

        private let gradientColors: [SwiftUI.Color] = [
            1.0, 0.97, 0.95, 0.92, 0.89, 0.86, 0.82, 0.77, 0.71, 0.64, 0.57, 0.48, 0.38, 0.26, 0.14, 0
        ].map { .semantic(.staticBlack).opacity($0) }
        
        public func body(content: Content) -> some View {
            content
                .if(!caption.isNilOrEmpty || buttonIcon != nil) {
                    $0.overlay(alignment: .top) {
                        ZStack {
                            HStack(spacing: 4) {
                                if let caption {
                                    HStack(spacing: 0) {
                                        Text(caption)
                                            .montage(variant: .label2, weight: .bold, semantic: .staticWhite)
                                            .paragraph(variant: .label2)
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.bottom, 6)
                                }
                                
                                if let buttonIcon {
                                    HStack(spacing: 0) {
                                        Spacer(minLength: 0)
                                        Montage.IconButton(
                                            icon: buttonIcon,
                                            iconColor: SwiftUI.Color.semantic(.staticWhite)
                                        ) {
                                            onTapButton?()
                                        }
                                    }
                                }
                            }
                            .padding(.all, 14)
                        }
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .init(x: 0, y: 0),
                                endPoint: .init(x: 0, y: 1)
                            )
                            .opacity(0.35)
                        )
                    }
                }
        }
    }
}

