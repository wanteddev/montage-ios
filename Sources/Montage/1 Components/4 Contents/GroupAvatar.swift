//
//  GroupAvatar.swift
//  Montage
//
//  Created by Sanghoon Ahn on 10/18/24.
//

import SwiftUI

/// 여러 아바타를 겹쳐서 표시하는 그룹 아바타 컴포넌트입니다.
///
/// 최대 5개의 아바타를 부분적으로 겹쳐 표시하며, 각 아바타에 개별 탭 동작을 지정할 수 있습니다.
///
/// ```swift
/// // 기본 그룹 아바타
/// GroupAvatar(
///     ["https://example.com/user1.jpg", "https://example.com/user2.jpg"],
///     variant: .person,
///     size: .small
/// )
///
/// // 탭 동작과 후행 콘텐츠가 있는 그룹 아바타
/// GroupAvatar(
///     imageUrls,
///     variant: .person,
///     size: .small,
///     onTap: { index in
///         print("탭한 아바타 인덱스: \(index)")
///     }
/// )
/// .trailingContent {
///     Text("+3").typography(variant: .body2)
/// }
/// ```
///
/// - Note: 아바타는 왼쪽에서 오른쪽으로 겹쳐서 표시되며, 마지막 아바타가 가장 앞에 표시됩니다.
public struct GroupAvatar: View {
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
    
    private let imageUrls: [String]
    private let variant: Avatar.Variant
    private let size: Size
    private let onTap: ((_ index: Int) -> Void)?
    
    /// 그룹 아바타를 초기화합니다.
    ///
    /// - Parameters:
    ///   - imageUrls: 표시할 이미지의 URL 문자열 배열 (최대 5개)
    ///   - variant: 아바타 유형 (.person, .company, .academy)
    ///   - size: 그룹 아바타 크기
    ///   - onTap: 각 아바타 탭 시 실행할 액션 (인덱스가 전달됨) (기본값: nil)
    public init(
        _ imageUrls: [String],
        variant: Avatar.Variant,
        size: Size,
        onTap: ((_ index: Int) -> Void)? = nil
    ) {
        self.imageUrls = Array(imageUrls.prefix(5))
        self.variant = variant
        self.size = size
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 10) {
            ZStack {
                ForEach(imageUrls.indices, id: \.self) { index in
                    ZStack {
                        Avatar(imageUrls[index], variant: variant, size: avatartSize) {
                            onTap?(index)
                        }
                        .interactionDisabled()
                        
                        if index < imageUrls.count - 1 {
                            RoundedRectangle(cornerRadius: variant.cornerRadius(size: avatartSize))
                                .scaleEffect(1.1)
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
            .offset(x: -(avatartSize.containerSize.width - size.space) * CGFloat(imageUrls.count - 1) / 2)
            .frame(
                width: avatartSize.containerSize
                    .width * CGFloat(imageUrls.count) - (size.space * CGFloat(imageUrls.count - 1)),
                height: avatartSize.containerSize.height
            )
            
            if let trailingContent {
                AnyView(trailingContent())
            }
        }
    }
    
    // MARK: - Modifiers
    
    private var trailingContent: (() -> any View)?
    
    /// 그룹 아바타 오른쪽에 추가적인 콘텐츠를 표시합니다.
    ///
    /// 이 수정자를 사용하여 아바타 그룹 옆에 추가 정보(예: "+3" 같은 추가 멤버 수)를 표시할 수 있습니다.
    ///
    /// - Parameter trailingContent: 표시할 뷰를 생성하는 클로저
    /// - Returns: 수정된 그룹 아바타 인스턴스
    public func trailingContent(_ trailingContent: @escaping () -> any View) -> Self {
        var zelf = self
        zelf.trailingContent = trailingContent
        return zelf
    }
}

/// `GroupAvatar`의 내부 구현을 위한 확장입니다.
private extension GroupAvatar {
    /// 그룹 아바타 크기에 맞는 개별 아바타 크기를 반환합니다.
    var avatartSize: Avatar.Size {
        size == .xsmall ? .xsmall : .small
    }
}
