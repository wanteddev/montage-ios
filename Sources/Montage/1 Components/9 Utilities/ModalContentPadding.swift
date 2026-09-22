//
//  ModalContentPadding.swift
//  Montage
//

import SwiftUI

/// 모달 콘텐츠 영역의 여백 적용 방식입니다.
///
/// ``Popup``·``BottomSheet``의 `contentPadding(vertical:horizontal:)` 수정자에 넘겨
/// 콘텐츠 상하·좌우 여백을 각각 켜고 끕니다. 실제 여백 값은 모달 종류가 정하므로
/// 사용처는 "여백을 준다/주지 않는다"만 고릅니다.
///
/// ```swift
/// YourView()
///     .bottomSheet(isPresented: $isPresented) {
///         // 이미지를 가장자리까지 붙이고 위쪽 여백만 남긴다
///         RemoteImage(url: url)
///     }
///     .contentPadding(vertical: .top, horizontal: .none)
/// ```
public struct ModalContentPadding {
    /// 콘텐츠 상하 여백의 적용 범위입니다.
    public enum Vertical {
        /// 상하 모두 여백을 두지 않습니다.
        case none
        /// 위쪽에만 여백을 둡니다.
        case top
        /// 아래쪽에만 여백을 둡니다.
        case bottom
        /// 상하 모두 여백을 둡니다.
        case both

        var appliesTop: Bool {
            switch self {
            case .top, .both: true
            case .none, .bottom: false
            }
        }

        var appliesBottom: Bool {
            switch self {
            case .bottom, .both: true
            case .none, .top: false
            }
        }
    }

    /// 콘텐츠 좌우 여백의 적용 여부입니다.
    public enum Horizontal {
        /// 좌우 여백을 두지 않습니다. 이미지처럼 가장자리까지 채우는 콘텐츠에 씁니다.
        case none
        /// 모달 종류에 맞는 기본 좌우 여백을 둡니다.
        case `default`

        var applies: Bool { self == .default }
    }
}

// MARK: - Modal Kind

/// 하위 컴포넌트가 자신이 어떤 모달 안에 있는지 판별하기 위한 종류입니다.
///
/// ``ActionArea``·``ModalNavigation``은 모달 밖에서도 쓰이는데 여백 값이 모달 종류마다
/// 다르므로, 모달이 환경값으로 자기 종류를 내려 준다. 모달 밖에서는 ``none``이 된다.
enum ModalKind {
    /// 모달 바깥입니다. 화면에 직접 놓인 경우입니다.
    case none
    /// ``Popup`` 안입니다.
    case popup
    /// ``BottomSheet`` 안입니다.
    case bottomSheet
    /// 전체 화면 모달 안입니다.
    case full

    /// 콘텐츠 좌우 여백입니다.
    var contentHorizontalPadding: CGFloat {
        switch self {
        case .none, .popup, .bottomSheet: 28
        case .full: 24
        }
    }

    /// 콘텐츠 상하 여백입니다.
    var contentVerticalPadding: CGFloat {
        switch self {
        case .none, .popup, .bottomSheet: 24
        case .full: 20
        }
    }

    /// ``ActionArea``의 좌우 여백입니다.
    ///
    /// 모달 밖과 전체 화면 모달은 화면 여백과 같은 20을 쓰고, ``Popup``·``BottomSheet``만 24로 넓힌다.
    var actionAreaHorizontalPadding: CGFloat {
        switch self {
        case .none, .full: 20
        case .popup, .bottomSheet: 24
        }
    }

    /// ``ModalNavigation``의 상하·좌우 여백입니다.
    var navigationPadding: CGFloat {
        switch self {
        case .none, .popup, .bottomSheet: 24
        case .full: 20
        }
    }
}

struct ModalKindKey: EnvironmentKey {
    static let defaultValue: ModalKind = .none
}

extension EnvironmentValues {
    var modalKind: ModalKind {
        get { self[ModalKindKey.self] }
        set { self[ModalKindKey.self] = newValue }
    }
}
