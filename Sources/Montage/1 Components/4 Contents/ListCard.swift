//
//  ListCard.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/24/24.
//

import SwiftUI

/// 썸네일과 콘텐츠를 수평으로 배치한 리스트 형태의 카드 컴포넌트입니다.
///
/// 썸네일 이미지와 텍스트 콘텐츠를 수평 방향으로 배치한 카드로, 리스트 항목으로 사용하기 적합합니다.
/// 스켈레톤 로딩 상태를 지원하고 다양한 콘텐츠를 배치할 수 있습니다.
///
/// ```swift
/// @State private var isLoading = false
///
/// ListCard(
///     thumbnail: { Thumbnail(urlString: imageURL, ratio: .r1x1) },
///     skeleton: $isLoading,
///     title: "리스트 카드 제목"
/// )
/// .caption("부제목")
/// .trailingContent { IconButton(variant: .default, icon: .arrowRight) }
/// ```
public struct ListCard: View {
    
    // MARK: - Initializer
    
    private let thumbnail: () -> Thumbnail
    @Binding private var skeleton: Bool
    private let title: String

    /// List 카드를 초기화합니다.
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
    private var extraCaption: String?
    private var topContent: () -> AnyView = { AnyView(EmptyView()) }
    private var bottomContent: () -> AnyView = { AnyView(EmptyView()) }
    private var leadingContent: () -> AnyView = { AnyView(EmptyView()) }
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }
    
    /// 카드의 캡션(부제목)을 설정합니다.
    ///
    /// - Parameter caption: 표시할 캡션 문자열
    /// - Returns: 수정된 카드 인스턴스
    public func caption(_ caption: String?) -> Self {
        var zelf = self
        zelf.caption = caption
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
    
    /// 카드 왼쪽(썸네일 앞)에 표시할 콘텐츠를 설정합니다.
    ///
    /// - Parameter content: 왼쪽에 표시할 콘텐츠 뷰를 반환하는 클로저
    /// - Returns: 수정된 카드 인스턴스
    public func leadingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.leadingContent = { AnyView(content()) }
        return zelf
    }
    
    /// 카드 오른쪽에 표시할 콘텐츠를 설정합니다.
    ///
    /// - Parameter content: 오른쪽에 표시할 콘텐츠 뷰를 반환하는 클로저
    /// - Returns: 수정된 카드 인스턴스
    public func trailingContent<V: View>(@ViewBuilder _ content: @escaping () -> V) -> Self {
        var zelf = self
        zelf.trailingContent = { AnyView(content()) }
        return zelf
    }
    
    // MARK: - Body
    
    @State private var textAreaWidth: CGFloat = 0
    @State private var hasTopContent: Bool = false
    @State private var hasBottomContent: Bool = false
    
    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            leadingContent()
            
            thumbnail()
                .radius()
                .border()
                .skeleton(isPresented: skeleton, kind: .rectangle(cornerRadius: 12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            ZStack {
                SwiftUI.Color.clear
                    .onGeometryChange(for: CGFloat.self, of: { $0.size.width }, action: { textAreaWidth = $0 })
                    
                VStack(alignment: .leading, spacing: 8) {
                    topContent()
                        .ifEmptyView { isEmpty in hasTopContent = !isEmpty }
                        .if(hasTopContent) {
                            $0.skeleton(
                                isPresented: skeleton,
                                kind: .rectangle(cornerRadius: 3),
                                size: CGSize(width: 48, height: 20)
                            )
                        }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .paragraph(variant: .body1, weight: .bold, semantic: .labelNormal)
                            .lineLimit(1)
                            .skeleton(isPresented: skeleton, kind: .text(lengths: [._75]), size: CGSize(width: textAreaWidth, height: 20))
                        
                        if let caption {
                            Text(caption)
                                .paragraph(variant: .label2, weight: .medium, semantic: .labelAlternative)
                                .lineLimit(1)
                                .skeleton(isPresented: skeleton, kind: .text(lengths: [._50]), size: CGSize(width: textAreaWidth, height: 14))
                        }
                        
                        if let extraCaption {
                            Text(extraCaption)
                                .paragraph(variant: .label2, weight: .medium, semantic: .labelAlternative)
                                .lineLimit(1)
                                .skeleton(
                                    isPresented: skeleton,
                                    kind: .text(lengths: [._25]),
                                    size: CGSize(width: textAreaWidth, height: 14)
                                )
                        }
                    }
                    
                    bottomContent()
                        .ifEmptyView { isEmpty in hasBottomContent = !isEmpty }
                        .if(hasBottomContent) {
                            $0.skeleton(
                                isPresented: skeleton,
                                kind: .rectangle(cornerRadius: 3),
                                size: CGSize(width: 48, height: 20)
                            )
                        }
                    
                }
                .frame(maxWidth: textAreaWidth, alignment: .leading)
            }
            .layoutPriority(1)
            
            trailingContent()
        }
    }
}
