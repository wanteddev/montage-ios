//
//  PrimaryButton.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/14.
//

import SwiftUI

/// DesignSystem 에서 정의하는 기본 버튼입니다.
public struct PrimaryButton: View {
    private let type: PrimaryButton.`Type`
    private let size: PrimaryButton.Size
    @ObservedObject var title: PrimaryButtonTitle
    private let iconAlignment: PrimaryButton.IconAlignment?
    @ObservedObject var isDisable: PrimaryButtonDisabledStatus
    @ObservedObject var width: PrimaryButtonWidth
    private let action: () -> Void

    public init(
        type: PrimaryButton.`Type`,
        size: PrimaryButton.Size,
        title: String,
        iconAlignment: PrimaryButton.IconAlignment? = nil,
        isDisable: PrimaryButtonDisabledStatus = PrimaryButtonDisabledStatus(value: false),
        width: PrimaryButtonWidth.Value? = nil,
        action: @escaping () -> Void
    ) {
        self.type = type
        self.size = size
        self.title = PrimaryButtonTitle(text: title)
        self.iconAlignment = iconAlignment
        self.isDisable = isDisable
        self.width = PrimaryButtonWidth(value: width)
        self.action = action
    }

    public var body: some View {
        if let value = width.value {
            baseButton
                .frame(minWidth: value.minWidth, maxWidth: value.maxWidth)
                .fixedSize(horizontal: value.fixedSize, vertical: true)
        } else {
            baseButton
        }
    }

    /// Button에서 Image의 Icon을 표시하는 View
    struct IconView: View {
        let icon: DesignSystem.Icon

        var body: some View {
            Image(icon.name, bundle: DesignSystem.bundle)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 18.0, height: 18.0, alignment: .center)
        }
    }

    /// Button의 State를 확인하기 위한 ButtonStyle
    struct PrimaryButtonStyle: ButtonStyle {
        let type: PrimaryButton.`Type`
        let size: PrimaryButton.Size

        func makeBody(configuration: Configuration) -> some View {
            ButtonStyleView(type: type, size: size, configuration: configuration)
        }
    }

    /// Custom ButtonStyle의 State에 따라 표시를 커스텀하는View
    struct ButtonStyleView: View {
        let type: PrimaryButton.`Type`
        let size: PrimaryButton.Size
        let configuration: ButtonStyle.Configuration

        @Environment(\.isEnabled) var isEnabled

        private var backgroundColor: Color {
            guard isEnabled else { return type.backgroundColor.disabled }

            return configuration.isPressed
                ? type.backgroundColor.pressed : type.backgroundColor.default
        }

        private var foregroundColor: Color {
            guard isEnabled else { return type.tintColor.disabled }

            return configuration.isPressed
                ? type.tintColor.pressed : type.tintColor.default
        }

        private var borderColor: Color? {
            guard isEnabled else { return type.borderColor?.disabled }

            return configuration.isPressed
                ? type.borderColor?.pressed : type.borderColor?.default
        }

        var body: some View {
            configuration.label
                .lineLimit(1)
                .font(size.font)
                .frame(
                    maxWidth: CGFloat.infinity,
                    idealHeight: size.height,
                    maxHeight: size.height,
                    alignment: Alignment.center
                )
                .padding(
                    EdgeInsets(
                        top: 0.0,
                        leading: 20.0,
                        bottom: 0.0,
                        trailing: 20.0
                    )
                )
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(size.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(borderColor ?? .clear, lineWidth: 1.0)
                )
        }
    }
}

// MARK: - private

extension PrimaryButton {
    private var baseButton: some View {
        Button(action: action) {
            HStack(spacing: 3.0) {
                if case .left(let icon) = iconAlignment {
                    IconView(icon: icon)
                }
                Text(title.text)
                if case .right(let icon) = iconAlignment {
                    IconView(icon: icon)
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle(type: type, size: size))
        .disabled(isDisable.value)
    }
}

struct PrimaryButtonSampleView: View {
    @State private var isDisabled = false
    @State private var labelText = "지원하기"

    var body: some View {
        List {
            Toggle("Disabled", isOn: $isDisabled)
            Section(header: Text("버튼 텍스트 입력")) {
                TextField("버튼 텍스트를 입력해주세요.", text: $labelText)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            Section(header: Text("large")) {
                PrimaryButton(
                    type: .fill,
                    size: .large,
                    title: labelText
                ) {}
                Text("fill/large/primary")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .primary),
                    size: .large,
                    title: labelText,
                    iconAlignment: .left(icon: .fillBookmark18)
                ) {}
                Text("line/large/primary/leftIcon")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .black),
                    size: .large,
                    title: labelText,
                    iconAlignment: .right(icon: .fillBookmark18)
                ) {}
                Text("line/large/black/rightIcon")
                    .designSystem(ofSize: 12.0, weight: .medium)
            }.disabled(isDisabled)
            Section(header: Text("MEDIUM")) {
                PrimaryButton(
                    type: .fill,
                    size: .medium,
                    title: labelText
                ) {}
                    .frame(width: 135)
                Text("fill/medium/primary")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .primary),
                    size: .medium,
                    title: labelText,
                    iconAlignment: .left(icon: .fillBookmark18)
                ) {}
                    .frame(width: 135)
                Text("line/medium/primary/leftIcon")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .blue),
                    size: .medium,
                    title: labelText,
                    iconAlignment: .right(icon: .fillBookmark18)
                ) {}
                    .frame(width: 135)
                Text("line/medium/blue/rightIcon")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .black),
                    size: .medium,
                    title: labelText,
                    iconAlignment: .right(icon: .fillBookmark18)
                ) {}
                    .frame(width: 135)
                Text("line/medium/black/rightIcon")
                    .designSystem(ofSize: 12.0, weight: .medium)
            }.disabled(isDisabled)
            Section(header: Text("SMALL")) {
                PrimaryButton(
                    type: .fill,
                    size: .small,
                    title: labelText
                ) {}
                    .frame(width: 100)
                Text("fill/small/primary")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .primary),
                    size: .small,
                    title: labelText
                ) {}
                    .frame(width: 100)
                Text("line/small/primary")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .blue),
                    size: .small,
                    title: labelText
                ) {}
                    .frame(width: 100)
                Text("line/small/blue")
                    .designSystem(ofSize: 12.0, weight: .medium)
                PrimaryButton(
                    type: .line(style: .black),
                    size: .small,
                    title: labelText
                ) {}
                    .frame(width: 100)
                Text("line/small/black")
                    .designSystem(ofSize: 12.0, weight: .medium)
            }.disabled(isDisabled)
        }
        .listStyle(GroupedListStyle())
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButtonSampleView()
    }
}
