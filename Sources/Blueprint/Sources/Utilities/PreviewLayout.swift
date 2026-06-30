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
/// - ``Mode/upsideDown``: ``stacked``를 뒤집어 옵션을 상단에 두고 나머지 전체를 미리보기 영역으로 비운다.
///   (Toast·SnackBar처럼 화면 하단에 나타나는 컴포넌트)
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
/// PreviewLayout(mode: .upsideDown) {
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
        /// ``stacked``를 위아래로 뒤집어, 옵션을 상단에 두고 나머지 전체를 미리보기 영역으로 비운다.
        ///
        /// Toast·SnackBar처럼 컴포넌트가 화면(주로 하단)에 나타나는 경우에 적합하다.
        /// 옵션이 하단으로 내려가지 않으므로 하단에 표시되는 미리보기와 겹치지 않는다.
        case upsideDown
        /// 미리보기를 전체 화면에 채우고 옵션을 드래그로 위치를 옮길 수 있는 floating 카드로 띄운다.
        ///
        /// 체커는 컨테이너가 미리보기에 자동 적용하므로 호출부에서 ``previewCheckered()``가 필요 없다.
        /// (배경이 불투명한 컴포넌트는 그만큼 가려지고, 투명한 영역에서만 체커가 비친다)
        case floating
        /// launcher(옵션 + "Show Preview" 버튼)를 보여주고, 버튼을 누르면 미리보기를 push한다.
        ///
        /// 이 모드에서 `preview` 클로저는 **push되는 대상 화면**이다. 컨테이너가 NavigationView와
        /// push 버튼을 제공하고, push된 미리보기에 체커까지 직접 적용한다(호출부에서 체커 처리 불필요).
        /// 화면 상단에 바가 붙고 콘텐츠 전체를 보여줘야 하는 TopNavigation·ModalNavigation 같은
        /// 컴포넌트에 적합하다.
        case navigation
    }

    private let mode: Mode
    private let preview: Preview
    private let options: Options
    private let accessory: Accessory

    @State private var showChecker: Bool = false
    // 체커 크기는 헤더 슬라이더로 실시간 조절한다.
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

    /// `options` 클로저가 `EmptyView`이면 옵션 섹션(과 "Options" 헤더)을 그리지 않는다.
    private var hasOptions: Bool { Options.self != EmptyView.self }

    var body: some View {
        modeBody
            // 체커 상태를 하위 뷰에 전달한다(``previewCheckered()``가 소비). `.navigation` 모드처럼
            // 미리보기가 push되는 경우엔 environment가 닿지 않으므로, 컨테이너가 대상을 직접 감싸 적용한다.
            .environment(
                \.previewChecker,
                PreviewCheckerConfig(isPresented: showChecker, checkerSize: checkerSize)
            )
    }

    @ViewBuilder
    private var modeBody: some View {
        switch mode {
        case .stacked: stackedBody
        case .upsideDown: upsideDownBody
        case .floating: floatingBody
        case .navigation: navigationBody
        }
    }

    private var stackedBody: some View {
        checkered(
            SwiftUI.ScrollView {
                VStack(alignment: .leading) {
                    header("Preview")
                    preview
                        .frame(maxWidth: .infinity)
                    if hasOptions {
                        header("Options", showControls: false)
                        options
                            .font(.caption)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
            }
        )
    }

    private var upsideDownBody: some View {
        // stacked를 뒤집어 옵션을 상단에 고정하고 나머지를 미리보기 영역으로 비운다. 미리보기가
        // EmptyView면(예: Toast·SnackBar) 빈 공간이 남고, greedy하면(예: ActionArea의 ScrollView)
        // 하단까지 채운다. 패딩은 옵션 블록과 "Preview" 타이틀에만 적용하고 미리보기 본문은 edge-to-edge로
        // 둔다. (전체화면 컴포넌트의 배경·그래디언트·하단 바가 화면 너비를 꽉 채울 수 있도록)
        checkered(
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading) {
                    header("Options", showControls: false)
                    options
                        .font(.caption)
                }

                header("Preview")
                preview
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        )
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
                        .font(.caption)
                }
            }
        }
    }

    private var navigationBody: some View {
        // launcher(옵션 + push 버튼)를 보여주고, 버튼을 누르면 `preview`(= push 대상)를 push한다.
        // push되는 미리보기는 컨테이너가 `checkered(...)`로 감싸 체커를 직접 적용한다.
        // (environment는 push 경계를 넘지 못하므로, 컨테이너가 대상을 직접 감싸 책임진다)
        NavigationView {
            SwiftUI.ScrollView {
                VStack(alignment: .leading) {
                    // 런처에는 컨트롤을 두지 않는다(체커 토글·슬라이더·accessory는 push된 미리보기 위에
                    // 드래그 가능한 floating 바로 옮긴다).
                    header("Preview", showControls: false)
                    NavigationLink {
                        checkered(preview)
                            .navigationBarHidden(true)
                            // 체커 토글·슬라이더·accessory를 미리보기 위에 드래그 가능한 floating 바로 띄운다.
                            // 핸들로만 드래그하므로 안쪽 컨트롤(버튼·슬라이더)은 정상 동작한다. 처음엔 상단 중앙.
                            .overlay(alignment: .top) {
                                NavigationFloatingControls(
                                    showChecker: $showChecker,
                                    checkerSize: $checkerSize,
                                    accessory: accessory
                                )
                                .padding()
                            }
                    } label: {
                        Button(variant: .outlined, text: "Show Preview")
                            .allowsHitTesting(false)
                    }
                    .frame(maxWidth: .infinity)
                    if hasOptions {
                        header("Options", showControls: false)
                        options
                            .font(.caption)
                    }
                    Spacer(minLength: 0)
                }
                .padding(.horizontal)
            }
            .background(SwiftUI.Color.semantic(.backgroundNormal))
        }
        .navigationViewStyle(.stack)
    }

    /// 대상 영역에 체커보드 배경을 적용한다.
    ///
    /// 체커 패턴은 콘텐츠 뒤에 깔리므로, 평상시 배경은 체커 모디파이어 "바깥"에 두어
    /// 체커를 가리지 않는다. (체커 ON 시 패턴이 이 배경을 덮고, OFF 시 이 배경이 보인다)
    private func checkered(_ content: some View) -> some View {
        content
            .transparentChecking(
                isPresented: showChecker,
                checkerSize: checkerSize,
                checkerColor: .red
            )
            .background(SwiftUI.Color.semantic(.backgroundNormal))
    }

    /// 섹션 헤더: 제목 + (옵션) 추가 버튼 + 체커 토글, 그리고 체커 ON 시 크기 조절 슬라이더.
    /// `.navigation` 모드처럼 accessory를 헤더가 아닌 곳(미리보기 floating)에 둘 때는 `showAccessory: false`.
    private func header(_ title: String, showControls: Bool = true) -> some View {
        HStack {
            Text(title).bold().font(.subheadline)
            Spacer()
            if showControls {
                accessory
                
                if showChecker {
                    HStack(spacing: 8) {
                        Text("checker")
                        SwiftUI.Slider(value: $checkerSize, in: 10...200, step: 1)
                            .frame(width: 100)
                        Text("\(Int(checkerSize))")
                            .monospacedDigit()
                    }
                    .font(.caption)
                }
                Button {
                    showChecker.toggle()
                } label: {
                    Image(systemName: "checkerboard.rectangle")
                }
            }
        }
        .frame(height: 20)
        .padding(.vertical)
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

// MARK: - Navigation 모드 floating 컨트롤 바

/// ``PreviewLayout/Mode/navigation``의 push된 미리보기 위에 띄우는 드래그 가능한 컨트롤 바.
/// accessory + 체커 토글 + (체커 ON 시) 크기 슬라이더를 담는다.
///
/// 드래그는 **핸들에만** 걸어, 안쪽 버튼/슬라이더의 탭·드래그가 컨트롤 바 이동 제스처나 밑의
/// ScrollView 스크롤과 충돌하지 않도록 한다.
private struct NavigationFloatingControls<Accessory: View>: View {
    @Binding var showChecker: Bool
    @Binding var checkerSize: CGFloat
    let accessory: Accessory

    // push를 pop하려면 destination의 dismiss가 필요하다. (호출부 accessory의 presentationMode로는
    // 내부 NavigationView의 push를 pop할 수 없어, 뒤로가기는 컨테이너가 소유한다)
    @Environment(\.dismiss) private var dismiss

    @State private var offset: CGSize = .zero
    @GestureState private var drag: CGSize = .zero

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.semantic(.labelAssistive))
                .frame(width: 28, height: 36)
                .contentShape(Rectangle())
                // highPriority로 밑의 ScrollView 스크롤과 경쟁하지 않게 해 드래그가 끊기지 않도록 한다.
                // coordinateSpace는 반드시 .global. 기본 .local은 드래그로 움직이는 이 바 자신을 기준으로
                // translation을 재므로, 바가 움직이면 좌표계도 함께 움직여 값이 되먹임되며 진동(버벅임)한다.
                .highPriorityGesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .updating($drag) { value, state, transaction in
                            state = value.translation
                            transaction.animation = nil
                        }
                        .onEnded { value in
                            offset.width += value.translation.width
                            offset.height += value.translation.height
                        }
                )

            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.semantic(.primaryNormal))
            }

            accessory

            Button {
                showChecker.toggle()
            } label: {
                Image(systemName: "checkerboard.rectangle")
            }

            if showChecker {
                SwiftUI.Slider(value: $checkerSize, in: 10...200, step: 1)
                    .frame(width: 100)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: Capsule())
        // floating 느낌을 주는 옅은 그림자.
        .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        .offset(x: offset.width + drag.width, y: offset.height + drag.height)
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
                // 드래그는 핸들에만 건다. 카드 전체에 걸면 안쪽 Slider·TextArea 같은 드래그 기반 컨트롤이
                // 카드 이동 제스처와 경쟁해 옵션 조작이 불안정해진다.
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                // coordinateSpace는 .global. 기본 .local은 드래그로 움직이는 이 카드 자신 기준이라
                // 움직임이 좌표계에 되먹임되어 진동한다.
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .updating($dragY) { value, state, transaction in
                            state = value.translation.height
                            transaction.animation = nil
                        }
                        .onEnded { value in offsetY += value.translation.height }
                )
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        // floating 느낌을 주는 옅은 그림자.
        .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        .padding()
        .offset(y: offsetY + dragY)
    }
}
