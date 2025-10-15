//
//  TextButton.swift
//  Views
//
//  Created by 김삼열 on 10/10/25.
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

/// Text 스타일의 버튼 컴포넌트입니다.
///
/// Text만 있는 스타일의 버튼으로, 가벼운 액션이나 링크 형태의 액션에 적합합니다.
///
/// ```swift
/// TextButton(text: "더 보기", handler: { showMore() })
/// TextButton(color: .assistive, text: "상세보기", trailingIcon: .chevronRight)
/// ```
public struct TextButton: View {
    
    /// Text 버튼의 색상 스타일을 정의합니다.
    public enum Color: String {
        /// 기본 강조 스타일 - 브랜드 컬러를 텍스트에 사용
        case primary
        /// 보조 스타일 - 중요도가 낮은 텍스트 링크에 사용
        case assistive
    }
    
    /// Text 스타일 버튼의 크기를 정의합니다.
    public enum Size: String {
        /// 작은 크기
        case small
        /// 중간 크기
        case medium
    }
    
    // MARK: - Initializer
    
    private let color: Color
    private let size: Size
    private let text: String
    private let leadingIcon: Icon?
    private let trailingIcon: Icon?
    private let handler: (() -> Void)?
    
    /// Text 스타일의 버튼을 생성합니다.
    ///
    /// - Parameters:
    ///   - color: 버튼의 스타일, 기본값은 `.primary`
    ///   - size: 버튼의 크기, 기본값은 `.medium`
    ///   - text: 버튼에 표시할 텍스트
    ///   - leadingIcon: 텍스트 앞에 표시할 아이콘
    ///   - trailingIcon: 텍스트 뒤에 표시할 아이콘
    ///   - handler: 버튼 탭 시 실행할 핸들러
    /// - Returns: 구성된 버튼 인스턴스
    public init(
        color: Color = .primary,
        size: Size = .medium,
        text: String,
        leadingIcon: Icon? = nil,
        trailingIcon: Icon? = nil,
        handler: (() -> Void)? = nil
    ) {
        self.color = color
        self.size = size
        self.text = text
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.handler = handler
    }

    // MARK: - Body
    
    public var body: some View {
        Button(
            .text,
            color: .init(rawValue: color.rawValue) ?? .primary,
            size: .init(rawValue: size.rawValue) ?? .medium,
            text: text,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            handler: handler
        )
        .disable(disable)
        .contentColor(contentColor)
        .fontVariant(fontVariant)
        .fontWeight(fontWeight)
        .loading(loading)
        .fill(horizontal: fillHorizontal, vertical: fillVertical)
    }
    
    // MARK: - Modifiers
    
    private var disable: Bool = false
    private var contentColor: SwiftUI.Color? = nil
    private var fontVariant: Typography.Variant? = nil
    private var fontWeight: Typography.Weight? = nil
    private var loading = false
    private var fillHorizontal = false
    private var fillVertical = false
    
    /// 버튼을 비활성화 상태로 설정합니다.
    ///
    /// 비활성화된 버튼은 시각적으로 흐리게 표시되며 사용자 상호작용에 반응하지 않습니다.
    ///
    /// ```swift
    /// TextButton(text: "저장")
    ///     .disable(isFormInvalid)
    /// ```
    ///
    /// - Parameter disable: 비활성화 여부, 기본값은 `true`
    /// - Returns: 수정된 버튼 인스턴스
    public func disable(_ disable: Bool = true) -> Self {
        var zelf = self
        zelf.disable = disable
        return zelf
    }
    
    /// 버튼 콘텐츠(텍스트와 아이콘)의 색상을 설정합니다.
    ///
    /// ```swift
    /// TextButton(text: "복사")
    ///     .contentColor(.red)
    /// ```
    ///
    /// - Parameter contentColor: 설정할 색상
    /// - Returns: 수정된 버튼 인스턴스
    public func contentColor(_ contentColor: SwiftUI.Color?) -> Self {
        var zelf = self
        zelf.contentColor = contentColor
        return zelf
    }
    
    /// 버튼 텍스트의 폰트 변형을 설정합니다.
    ///
    /// 텍스트의 크기와 스타일을 변경할 때 사용합니다.
    ///
    /// ```swift
    /// TextButton(text: "중요 안내")
    ///     .fontVariant(.heading)
    /// ```
    ///
    /// - Parameter fontVariant: 설정할 폰트 변형
    /// - Returns: 수정된 버튼 인스턴스
    public func fontVariant(_ fontVariant: Typography.Variant?) -> Self {
        var zelf = self
        zelf.fontVariant = fontVariant
        return zelf
    }
    
    /// 버튼 텍스트의 폰트 두께를 설정합니다.
    ///
    /// 텍스트의 강조를 조절할 때 사용합니다.
    ///
    /// ```swift
    /// TextButton(text: "중요 공지")
    ///     .fontWeight(.bold)
    /// ```
    ///
    /// - Parameter fontWeight: 설정할 폰트 두께
    /// - Returns: 수정된 버튼 인스턴스
    public func fontWeight(_ fontWeight: Typography.Weight?) -> Self {
        var zelf = self
        zelf.fontWeight = fontWeight
        return zelf
    }
    
    /// 버튼을 로딩 상태로 설정합니다.
    ///
    /// 로딩 상태인 버튼은 내부 콘텐츠 대신 로딩 인디케이터를 표시하며 사용자 상호작용에 반응하지 않습니다.
    /// 비동기 작업이 진행 중일 때 사용자에게 피드백을 제공하는 데 유용합니다.
    ///
    /// ```swift
    /// TextButton(text: "저장")
    ///     .loading(isLoading)
    /// ```
    ///
    /// - Parameter loading: 로딩 상태 여부, 기본값은 `true`
    /// - Returns: 수정된 버튼 인스턴스
    public func loading(_ loading: Bool = true) -> Self {
        var zelf = self
        zelf.loading = loading
        return zelf
    }
    
    /// 버튼이 수평 또는 수직 방향으로 공간을 채우도록 설정합니다.
    ///
    /// 버튼의 크기를 조절하여 컨테이너 뷰의 공간을 효율적으로 활용할 때 사용합니다.
    ///
    /// ```swift
    /// // 부모 뷰의 가로 너비를 모두 채우는 버튼
    /// TextButton(text: "전체 확인")
    ///     .fill(horizontal: true)
    ///
    /// // 가로, 세로 모두 채우는 버튼
    /// TextButton(text: "영역 전체 채우기")
    ///     .fill(horizontal: true, vertical: true)
    /// ```
    ///
    /// - Parameters:
    ///   - fillHorizontal: 수평 방향 채우기 여부, 기본값은 `false`
    ///   - fillVertical: 수직 방향 채우기 여부, 기본값은 `false`
    /// - Returns: 수정된 버튼 인스턴스
    public func fill(horizontal fillHorizontal: Bool = false, vertical fillVertical: Bool = false) -> Self {
        var zelf = self
        zelf.fillHorizontal = fillHorizontal
        zelf.fillVertical = fillVertical
        return zelf
    }
}
