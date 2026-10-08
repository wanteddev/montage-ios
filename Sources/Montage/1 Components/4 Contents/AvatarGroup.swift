//
//  AvatarGroup.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

/// 여러 사용자 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.
///
/// 최대 5개의 사용자(.person) 아바타를 부분적으로 겹쳐 표시하며, 각 아바타에 개별 탭 동작을 지정할 수 있습니다.
/// 겹치는 아바타 사이에는 1.5pt 두께의 분리 여백이 적용됩니다.
///
/// ```swift
/// // 기본 그룹 아바타
/// AvatarGroup(
///     ["https://example.com/user1.jpg", "https://example.com/user2.jpg"],
///     size: .small
/// )
///
/// // 탭 동작과 후행 콘텐츠가 있는 그룹 아바타
/// AvatarGroup(
///     imageUrls,
///     size: .small,
///     onTap: { index in
///         print("탭한 아바타 인덱스: \(index)")
///     }
/// )
/// .trailingContent {
///     Text("외 3명")
///         .typography(variant: .label1, weight: .medium, semantic: .foregroundNeutralSecondary)
/// }
/// ```
public struct AvatarGroup: View {
    // MARK: - Types

    /// 그룹 아바타의 크기와 간격을 정의하는 열거형입니다.
    public enum Size {
        /// 가장 작은 크기
        case xsmall
        /// 작은 크기
        case small

        var space: CGFloat {
            switch self {
            case .xsmall: 6
            case .small: 8
            }
        }
    }

    // MARK: - Initializer

    private let imageSources: [Avatar.ImageSource]
    private let size: Size
    private let onTap: ((_ index: Int) -> Void)?

    /// URL 문자열 배열로 그룹 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - imageUrls: 표시할 이미지의 URL 문자열 배열 (최대 5개)
    ///   - size: 그룹 아바타 크기
    ///   - onTap: 각 아바타 탭 시 실행할 액션 (인덱스가 전달됨), 생략하면 기본값으로 `nil` 적용
    public init(
        _ imageUrls: [String],
        size: Size,
        onTap: ((_ index: Int) -> Void)? = nil
    ) {
        self.imageSources = Array(imageUrls.prefix(Self.maxDisplayCount)).map { .url($0) }
        self.size = size
        self.onTap = onTap
    }

    /// SwiftUI Image 배열로 그룹 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - images: 표시할 SwiftUI Image 배열 (최대 5개)
    ///   - size: 그룹 아바타 크기
    ///   - onTap: 각 아바타 탭 시 실행할 액션 (인덱스가 전달됨), 생략하면 기본값으로 `nil` 적용
    public init(
        _ images: [Image],
        size: Size,
        onTap: ((_ index: Int) -> Void)? = nil
    ) {
        self.imageSources = Array(images.prefix(Self.maxDisplayCount)).map { .image($0) }
        self.size = size
        self.onTap = onTap
    }

    // MARK: - Body

    /// 뷰의 내용과 동작을 정의합니다.
    public var body: some View {
        HStack(spacing: 10) {
            if !imageSources.isEmpty {
                let count = imageSources.count
                ZStack {
                    ForEach(imageSources.indices, id: \.self) { index in
                        ZStack {
                            avatarView(for: imageSources[index], index: index)
                                .contentMode(contentMode)
                                .interactionDisabled()

                            if index < count - 1 {
                                // 겹치는 다음 아바타와 1.5pt 두께로 분리되도록,
                                // 아바타보다 상하좌우 1.5pt씩 큰 원형 마스크로 배경을 뚫는다.
                                Circle()
                                    .frame(
                                        width: avatartSize.containerSize.width + Self.overlapBorderWidth * 2,
                                        height: avatartSize.containerSize.height + Self.overlapBorderWidth * 2
                                    )
                                    .offset(x: avatartSize.containerSize.width - size.space)
                                    .blendMode(.destinationOut)
                            }
                        }
                        .compositingGroup()
                        .frame(
                            width: avatartSize.containerSize.width,
                            height: avatartSize.containerSize.height
                        )
                        .offset(
                            x: avatartSize.containerSize
                                .width * CGFloat(index) - (size.space * CGFloat(index))
                        )
                    }
                }
                .offset(
                    x: -(avatartSize.containerSize.width - size.space) * CGFloat(count - 1)
                        / 2
                )
                .frame(
                    width: avatartSize.containerSize
                        .width * CGFloat(count) - (size.space * CGFloat(count - 1)),
                    height: avatartSize.containerSize.height
                )
            }

            trailingContent()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            "\(Avatar.Variant.person.accessibilityDescription) \(imageSources.count)"
        )
    }

    // MARK: - Modifiers

    private var contentMode: ContentMode = .fit
    private var trailingContent: () -> AnyView = { AnyView(EmptyView()) }

    /// 이미지의 콘텐츠 모드를 설정합니다.
    ///
    /// - Parameter contentMode: 콘텐츠 모드, `.fit` 또는 `.fill`
    /// - Returns: 수정된 그룹 아바타 인스턴스
    public func contentMode(_ contentMode: ContentMode) -> Self {
        var zelf = self
        zelf.contentMode = contentMode
        return zelf
    }

    /// 그룹 아바타 오른쪽에 추가적인 콘텐츠를 표시합니다.
    ///
    /// 이 수정자를 사용하여 아바타 그룹 옆에 추가 정보(예: "+3" 같은 추가 멤버 수)를 표시할 수 있습니다.
    ///
    /// - Parameter trailingContent: 표시할 뷰를 생성하는 클로저
    /// - Returns: 수정된 그룹 아바타 인스턴스
    public func trailingContent<V: View>(@ViewBuilder _ trailingContent: @escaping () -> V) -> Self
    {
        var zelf = self
        zelf.trailingContent = { AnyView(trailingContent()) }
        return zelf
    }

}

/// `AvatarGroup`의 내부 구현을 위한 확장입니다.
extension AvatarGroup {
    /// 겹쳐서 표시할 수 있는 최대 아바타 수.
    fileprivate static let maxDisplayCount = 5

    /// 겹치는 아바타 사이의 분리 여백(테두리) 두께.
    fileprivate static let overlapBorderWidth: CGFloat = 1.5

    /// 그룹 아바타 크기에 맞는 개별 아바타 크기를 반환합니다.
    fileprivate var avatartSize: Avatar.Size {
        size == .xsmall ? .xsmall : .small
    }

    fileprivate func avatarView(for source: Avatar.ImageSource, index: Int) -> Avatar {
        switch source {
        case .url(let imageUrl):
            Avatar(imageUrl, variant: .person, size: avatartSize) { onTap?(index) }
        case .image(let image):
            Avatar(image, variant: .person, size: avatartSize) { onTap?(index) }
        }
    }
}
