//
//  PreviewLayout.swift
//  Blueprint
//
//  Copyright © 2025 WantedLab Inc. All rights reserved.
//

import SwiftUI

import Montage

/// 컴포넌트 쇼케이스 화면의 공통 레이아웃 컨테이너.
///
/// 모든 Preview 화면이 반복 구현하던 다음 요소를 한곳에서 담당한다.
/// - "Preview" / "Options" 섹션 헤더
/// - 투명도 체커보드 토글 버튼 + 체커 크기 조절 슬라이더 및 ``transparentChecking`` 모디파이어
/// - 배경색, 폰트, 패딩 등 공통 스타일
///
/// 세 가지 레이아웃 모드를 지원한다.
/// - ``Mode/stacked``: 상단에 미리보기, 하단에 옵션을 세로로 쌓는 스크롤 레이아웃. (일반 컴포넌트)
/// - ``Mode/overlay``: 옵션을 상단에 고정하고 나머지 전체 화면을 미리보기 영역으로 비운다.
///   (Toast·SnackBar처럼 화면 하단에 오버레이되는 컴포넌트)
/// - ``Mode/pinnedTop``: 미리보기를 전체 화면에 채우고(상단에 바 부착) 옵션을 하단 material 패널에 둔다.
///   (TopNavigation·ModalNavigation처럼 화면 상단에 고정되는 컴포넌트. 보통 `fullScreenCover` 안에서 사용)
///
/// 헤더에 추가 버튼이 필요한 경우 `accessory` 클로저로 주입한다. (예: 전체화면 미리보기의 닫기 버튼)
///
/// ```swift
/// // 상단 미리보기 / 하단 옵션
/// PreviewLayout {
///     MyComponent().disable(disable)
/// } options: {
///     SegmentedOptionRow("size", selection: $size)
///     ToggleOptionRow("disable", isOn: $disable)
/// }
///
/// // 옵션 상단 고정 + 전체화면 미리보기 (Toast·SnackBar)
/// PreviewLayout(mode: .overlay) {
///     EmptyView()
/// } options: {
///     Button(variant: .outlined, text: "노출") { present() }
/// }
/// .snackBar($model)
///
/// // 상단 고정 바 + 하단 옵션 패널 + 헤더 닫기 버튼 (TopNavigation)
/// PreviewLayout(mode: .pinnedTop) {
///     content.topNavigation(variant: variant, title: title)
/// } options: {
///     SegmentedIndexRow("variant", index: $variantIndex, labels: labels)
/// } accessory: {
///     Button { dismiss() } label: { Image.icon(.flipBackward) }
/// }
/// ```
struct PreviewLayout<Preview: View, Options: View, Accessory: View>: View {

    /// 레이아웃 배치 방식.
    enum Mode {
        /// 상단 미리보기 / 하단 옵션 (세로 스크롤).
        case stacked
        /// 옵션을 상단에 고정하고 나머지 전체 화면을 미리보기 영역으로 비운다.
        ///
        /// Toast·SnackBar처럼 컴포넌트가 화면(주로 하단)에 오버레이로 나타나는 경우에 적합하다.
        /// 옵션이 하단으로 내려가지 않으므로 하단에 표시되는 미리보기와 겹치지 않는다.
        case overlay
        /// 미리보기를 전체 화면에 채우고 옵션을 하단 material 패널에 고정한다.
        ///
        /// TopNavigation·ModalNavigation처럼 화면 상단에 바가 고정되는 컴포넌트에 적합하다.
        case pinnedTop
        /// 미리보기를 전체 화면에 채우고 옵션을 드래그로 위치를 옮길 수 있는 floating 카드로 띄운다.
        ///
        /// 체커는 컨테이너가 미리보기에 자동 적용하므로 호출부에서 ``previewCheckered()``가 필요 없다.
        /// (배경이 불투명한 컴포넌트는 그만큼 가려지고, 투명한 영역에서만 체커가 비친다)
        case floating
    }

    private let mode: Mode
    private let preview: Preview
    private let options: Options
    private let accessory: Accessory

    @State private var showTransparentChecker: Bool = false
    // 체커 크기는 헤더 슬라이더로 실시간 조절한다. 기본값만 두고 init 파라미터로 받지 않는다.
    @State private var checkerSize: CGFloat = 50

    init(
        mode: Mode = .stacked,
        @ViewBuilder preview: () -> Preview,
        @ViewBuilder options: () -> Options,
        @ViewBuilder accessory: () -> Accessory
    ) {
        self.mode = mode
        self.preview = preview()
        self.options = options()
        self.accessory = accessory()
    }

    var body: some View {
        modeBody
            // 체커 상태를 하위 뷰에 전달한다. `.pinnedTop`처럼 컨테이너가 체커를 직접 입힐 수 없는
            // 경우(예: TopNavigation이 불투명 배경을 그림), 호출부가 콘텐츠에 ``previewCheckered()``로
            // 적절한 위치에 체커를 적용한다.
            .environment(
                \.previewChecker,
                PreviewCheckerConfig(isPresented: showTransparentChecker, checkerSize: checkerSize)
            )
    }

    @ViewBuilder
    private var modeBody: some View {
        switch mode {
        case .stacked: stackedBody
        case .overlay: overlayBody
        case .pinnedTop: pinnedTopBody
        case .floating: floatingBody
        }
    }

    private var stackedBody: some View {
        checkered(
            SwiftUI.ScrollView {
                VStack(alignment: .leading) {
                    header("Preview")
                    preview
                        .frame(maxWidth: .infinity)
                    Text("Options").bold().font(.subheadline)
                    options
                    Spacer(minLength: 0)
                }
                .font(.caption)
                .padding()
            }
        )
    }

    private var overlayBody: some View {
        // 옵션은 상단에 고정하고 나머지를 미리보기 영역으로 비운다. 미리보기가 EmptyView면(예: Toast·
        // SnackBar) 빈 공간이 남고, 미리보기가 greedy하면(예: ActionArea의 ScrollView) 하단까지 채운다.
        // 패딩은 옵션 블록에만 적용하고 미리보기는 edge-to-edge로 둔다. (전체화면 컴포넌트의 배경·
        // 그래디언트·하단 바가 화면 너비를 꽉 채울 수 있도록)
        checkered(
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    header("Options")
                    options
                }
                .font(.caption)
                .padding()

                preview
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
    }

    private var pinnedTopBody: some View {
        VStack(spacing: 0) {
            // 미리보기는 화면을 채운다. 체커는 호출부가 콘텐츠에 `previewCheckered()`로 직접 적용한다.
            // (상단 바 컴포넌트가 불투명 배경을 그리므로 컨테이너가 바깥에서 입히면 가려진다)
            preview
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(SwiftUI.Color.semantic(.backgroundNormal))

            VStack(alignment: .leading) {
                header("Options")
                options
            }
            .font(.caption)
            .padding()
            .background(.regularMaterial)
        }
    }

    private var floatingBody: some View {
        // 미리보기는 전체 화면을 채우고 컨테이너가 체커를 자동 적용한다(호출부 previewCheckered 불필요).
        // 옵션은 드래그로 위치를 옮길 수 있는 floating 카드로 미리보기 위에 띄운다.
        checkered(
            preview
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        .overlay(alignment: .bottom) {
            DraggableCard {
                VStack(alignment: .leading) {
                    header("Options")
                    options
                }
                .font(.caption)
            }
        }
    }

    /// 대상 영역에 체커보드 배경을 적용한다.
    ///
    /// 체커 패턴은 콘텐츠 뒤에 깔리므로, 평상시 배경은 체커 모디파이어 "바깥"에 두어
    /// 체커를 가리지 않는다. (체커 ON 시 패턴이 이 배경을 덮고, OFF 시 이 배경이 보인다)
    private func checkered(_ content: some View) -> some View {
        content
            .transparentChecking(
                isPresented: showTransparentChecker,
                checkerSize: checkerSize,
                checkerColor: .red
            )
            .background(SwiftUI.Color.semantic(.backgroundNormal))
    }

    /// 섹션 헤더: 제목 + (옵션) 추가 버튼 + 체커 토글, 그리고 체커 ON 시 크기 조절 슬라이더.
    private func header(_ title: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text(title).bold().font(.subheadline)
                Spacer()
                accessory
                Button {
                    showTransparentChecker.toggle()
                } label: {
                    Image(systemName: "checkerboard.rectangle")
                        .foregroundColor(.semantic(.primaryNormal))
                }
            }
            if showTransparentChecker {
                HStack(spacing: 8) {
                    Text("checker")
                    SwiftUI.Slider(value: $checkerSize, in: 8...300, step: 1)
                    Text("\(Int(checkerSize))")
                        .monospacedDigit()
                }
                .font(.caption)
            }
        }
    }
}

// MARK: - Checker 환경 전달

/// ``PreviewLayout``이 하위 뷰에 전달하는 투명도 체커 상태.
struct PreviewCheckerConfig {
    var isPresented: Bool = false
    var checkerSize: CGFloat = 50
}

private struct PreviewCheckerKey: EnvironmentKey {
    static let defaultValue = PreviewCheckerConfig()
}

extension EnvironmentValues {
    var previewChecker: PreviewCheckerConfig {
        get { self[PreviewCheckerKey.self] }
        set { self[PreviewCheckerKey.self] = newValue }
    }
}

extension View {
    /// ``PreviewLayout``이 전달한 체커 상태로 ``transparentChecking``을 적용한다.
    ///
    /// `.pinnedTop`처럼 컨테이너가 미리보기 콘텐츠 바깥에서 체커를 입힐 수 없는 경우(상단 바
    /// 컴포넌트가 불투명 배경을 그림), 호출부가 체커가 보여야 할 콘텐츠에 직접 호출한다.
    /// 보통 `.topNavigation` 같은 컴포넌트 모디파이어를 적용하기 **직전**에 둔다.
    func previewCheckered() -> some View {
        modifier(PreviewCheckeredModifier())
    }
}

private struct PreviewCheckeredModifier: ViewModifier {
    @Environment(\.previewChecker) private var config

    func body(content: Content) -> some View {
        content.transparentChecking(
            isPresented: config.isPresented,
            checkerSize: config.checkerSize,
            checkerColor: .red
        )
    }
}

// 헤더에 추가 버튼이 필요 없는 일반적인 경우를 위한 편의 이니셜라이저.
extension PreviewLayout where Accessory == EmptyView {
    init(
        mode: Mode = .stacked,
        @ViewBuilder preview: () -> Preview,
        @ViewBuilder options: () -> Options
    ) {
        self.init(
            mode: mode,
            preview: preview,
            options: options,
            accessory: { EmptyView() }
        )
    }
}

// MARK: - Floating Options 카드

/// 드래그로 세로 위치를 옮길 수 있는 floating material 카드. ``PreviewLayout/Mode/floating``에서
/// 옵션 패널을 미리보기 위에 띄우는 데 사용한다. 상단 핸들을 잡고 위/아래로 끌어 미리보기를 가리지
/// 않도록 옮길 수 있다.
private struct DraggableCard<Content: View>: View {
    @ViewBuilder var content: Content

    @State private var offsetY: CGFloat = 0
    @GestureState private var dragY: CGFloat = 0

    var body: some View {
        VStack(spacing: 8) {
            Capsule()
                .fill(SwiftUI.Color.semantic(.lineNeutral))
                .frame(width: 36, height: 5)
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding()
        .offset(y: offsetY + dragY)
        .gesture(
            DragGesture()
                .updating($dragY) { value, state, _ in state = value.translation.height }
                .onEnded { value in offsetY += value.translation.height }
        )
    }
}
