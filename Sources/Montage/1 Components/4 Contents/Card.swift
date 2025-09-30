//
//  Card.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

/// 썸네일과 콘텐츠를 포함하는 기본 카드 컴포넌트입니다.
///
/// 썸네일 이미지와 제목, 캡션 등의 텍스트 콘텐츠를 수직 방향으로 배치한 카드입니다.
/// 스켈레톤 로딩 상태를 지원하고, 썸네일 위에 오버레이 콘텐츠를 표시할 수 있습니다.
///
/// ```swift
/// @State private var isLoading = false
///
/// Card(
///     thumbnail: { Thumbnail(.image(Image("sample"))) },
///     skeleton: $isLoading,
///     title: "카드 제목"
/// )
/// .caption("부제목")
/// .overlay(caption: "New", buttonIcon: .heart)
/// ```
///
/// - Note: 썸네일 이미지는 둥근 모서리로 표시되며, 콘텐츠 영역의 너비는 썸네일 너비에 맞춰집니다.
public struct Card: View {

    // MARK: - Initializer

    private let thumbnail: () -> Thumbnail
    @Binding private var skeleton: Bool
    private let title: String

    /// 카드를 초기화합니다.
    ///
    /// - Parameters:
    ///   - thumbnail: 카드에 표시할 썸네일 이미지
    ///   - skeleton: 스켈레톤 로딩 상태 바인딩
    ///   - title: 카드 제목으로 표시할 뷰
    public init(
        thumbnail: @escaping () -> Thumbnail,
        skeleton: Binding<Bool>,
        title: String
    ) {
        self.thumbnail = thumbnail
        _skeleton = skeleton
        self.title = title
    }

    // MARK: - Modifiers

    private var caption: String?
    private var subCaption: String?
    private var extraCaption: String?
    private var overlayCaption: String?
    private var overlayButtonIcon: Montage.Icon?
    private var overlayButtonColor: SwiftUI.Color = .semantic(.staticWhite)
    private var onTapOverlayButton: (() -> Void)?
    private var topContent: () -> AnyView = { AnyView(EmptyView()) }
    private var bottomContent: () -> AnyView = { AnyView(EmptyView()) }

    /// 카드의 캡션(부제목)을 설정합니다.
    ///
    /// - Parameter caption: 표시할 캡션 문자열
    /// - Returns: 수정된 카드 인스턴스
    public func caption(_ caption: String?) -> Self {
        var zelf = self
        zelf.caption = caption
        return zelf
    }

    /// 카드의 보조 캡션을 설정합니다.
    ///
    /// - Parameter subCaption: 표시할 보조 캡션 문자열
    /// - Returns: 수정된 카드 인스턴스
    public func subCaption(_ subCaption: String?) -> Self {
        var zelf = self
        zelf.subCaption = subCaption
        return zelf
    }

    /// 카드의 추가 캡션을 설정합니다.
    ///
    /// - Parameter extraCaption: 표시할 추가 캡션 문자열
    /// - Returns: 수정된 카드 인스턴스
    public func extraCaption(_ extraCaption: String?) -> Self {
        var zelf = self
        zelf.extraCaption = extraCaption
        return zelf
    }

    /// 썸네일에 오버레이할 콘텐츠를 설정합니다.
    ///
    /// - Parameters:
    ///   - caption: 오버레이에 표시할 텍스트
    ///   - buttonIcon: 오버레이에 표시할 버튼 아이콘
    ///   - buttonColor: 버튼 아이콘 색상
    ///   - onTapButton: 버튼 탭 시 실행할 액션
    /// - Returns: 수정된 카드 인스턴스
    public func overlay(
        caption: String? = nil,
        buttonIcon: Montage.Icon? = nil,
        buttonColor: SwiftUI.Color = .semantic(.staticWhite),
        onTapButton: (() -> Void)? = nil
    ) -> Self {
        var zelf = self
        zelf.overlayCaption = caption
        zelf.overlayButtonIcon = buttonIcon
        zelf.overlayButtonColor = buttonColor
        zelf.onTapOverlayButton = onTapButton
        return zelf
    }

    /// 카드 상단에 표시할 콘텐츠를 설정합니다.
    ///
    /// - Parameter content: 상단에 표시할 콘텐츠 뷰를 반환하는 클로저
    /// - Returns: 수정된 카드 인스턴스
    public func topContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.topContent = { AnyView(content()) }
        return zelf
    }

    /// 카드 하단에 표시할 콘텐츠를 설정합니다.
    ///
    /// - Parameter content: 하단에 표시할 콘텐츠 뷰를 반환하는 클로저
    /// - Returns: 수정된 카드 인스턴스
    public func bottomContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.bottomContent = { AnyView(content()) }
        return zelf
    }

    // MARK: - Body

    @State private var thumbnailWidth: CGFloat = 0
    @State private var hasTopContent: Bool = false
    @State private var hasBottomContent: Bool = false

    public var body: some View {
        Grid(alignment: .leading, verticalSpacing: 6) {
            GridRow {
                thumbnail()
                    .radius()
                    .border()
                    .modifier(
                        ThumbnailOverlayModifier(
                            caption: overlayCaption,
                            buttonIcon: overlayButtonIcon,
                            buttonColor: overlayButtonColor,
                            onTapButton: onTapOverlayButton
                        )
                    )
                    .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 12))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onGeometryChange(
                for: CGFloat.self, of: { $0.size.width }, action: { thumbnailWidth = $0 })

            GridRow {
                VStack(alignment: .leading, spacing: 6) {
                    topContent()
                        .ifEmptyView { isEmpty in hasTopContent = !isEmpty }
                        .if(hasTopContent) {
                            $0.skeleton(
                                isPresented: skeleton, kind: .rectangle(cornerRadius: 3),
                                size: CGSize(width: 48, height: 20)
                            )
                            .padding(.top, 2)
                        }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .paragraphNew(variant: .body1, weight: .bold, semantic: .labelNormal)
                            .lineLimit(2)
                            .skeleton(
                                isPresented: skeleton, kind: .text(lengths: [._100]),
                                size: CGSize(width: textAreaWidth, height: 22))

                        VStack(alignment: .leading, spacing: 2) {
                            if let caption {
                                Text(caption)
                                    .paragraphNew(
                                        variant: .label2, weight: .medium,
                                        semantic: .labelAlternative
                                    )
                                    .lineLimit(1)
                                    .skeleton(
                                        isPresented: skeleton, kind: .text(lengths: [._50]),
                                        size: CGSize(width: textAreaWidth, height: 18))
                            }

                            if let subCaption {
                                Text(subCaption)
                                    .paragraphNew(
                                        variant: .label2, weight: .medium,
                                        semantic: .labelAlternative
                                    )
                                    .lineLimit(1)
                                    .skeleton(
                                        isPresented: skeleton, kind: .text(lengths: [._25]),
                                        size: CGSize(width: textAreaWidth, height: 18))
                            }

                            if let extraCaption {
                                Text(extraCaption)
                                    .paragraphNew(
                                        variant: .label2, weight: .medium,
                                        semantic: .labelAlternative
                                    )
                                    .lineLimit(1)
                                    .skeleton(
                                        isPresented: skeleton, kind: .text(lengths: [._25]),
                                        size: CGSize(width: textAreaWidth, height: 18))
                            }
                        }
                        .if(
                            !caption.isNilOrEmpty || !subCaption.isNilOrEmpty
                                || !extraCaption.isNilOrEmpty)
                    }

                    bottomContent()
                        .ifEmptyView { isEmpty in hasBottomContent = !isEmpty }
                        .if(hasBottomContent) {
                            $0.skeleton(
                                isPresented: skeleton, kind: .rectangle(cornerRadius: 3),
                                size: CGSize(width: 48, height: 20)
                            )
                            .padding(.top, 2)
                        }
                }
                .padding(.horizontal, horizontalPadding)
                .frame(maxWidth: thumbnailWidth, alignment: .leading)
            }
        }
    }

    private var horizontalPadding: CGFloat = 2
    private var textAreaWidth: CGFloat {
        max(0, thumbnailWidth - horizontalPadding * 2)
    }
}

extension Card {
    /// 썸네일 이미지 위에 그라데이션 오버레이와 콘텐츠를 표시하는 모디파이어입니다.
    ///
    /// 썸네일 상단에 어두운 그라데이션 배경과 함께 캡션 텍스트, 버튼 등을 표시합니다.
    /// 주로 썸네일에 추가 정보나 액션 버튼을 제공하기 위해 사용됩니다.
    ///
    /// - Note: 그라데이션은 위에서 아래로 점점 투명해지는 형태로 적용됩니다.
    private struct ThumbnailOverlayModifier: ViewModifier {
        private let caption: String?
        private let buttonIcon: Montage.Icon?
        private let buttonColor: SwiftUI.Color
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
            buttonColor: SwiftUI.Color = .semantic(.staticWhite),
            onTapButton: (() -> Void)? = nil
        ) {
            self.caption = caption
            self.buttonIcon = buttonIcon
            self.buttonColor = buttonColor
            self.onTapButton = onTapButton
        }

        private let gradientColors: [SwiftUI.Color] = [
            1.0, 0.97, 0.95, 0.92, 0.89, 0.86, 0.82, 0.77, 0.71, 0.64, 0.57, 0.48, 0.38, 0.26, 0.14,
            0,
        ].map { .semantic(.staticBlack).opacity($0) }

        public func body(content: Content) -> some View {
            content
                .if(!caption.isNilOrEmpty || buttonIcon != nil) {
                    $0.overlay(alignment: .top) {
                        ZStack {
                            HStack(alignment: .top, spacing: 0) {
                                if let caption {
                                    Text(caption)
                                        .paragraphNew(
                                            variant: .caption2, weight: .bold,
                                            semantic: .staticWhite
                                        )
                                        .padding(.bottom, 6)
                                }

                                Spacer(minLength: 4)

                                if let buttonIcon {
                                    Montage.IconButton(
                                        variant: .normal(size: 20),
                                        icon: buttonIcon
                                    ) {
                                        onTapButton?()
                                    }
                                    .iconColor(buttonColor)
                                }
                            }
                            .padding(.all, 10)
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
