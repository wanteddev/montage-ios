//
//  CTAButton.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/19.
//

import SwiftUI

/// Button 만으로 구현되는 CTAButton 입니다.
/// 기본 BackgroundColor는 elevatedBg 입니다.
public struct CTAButton: View {
    private let buttons: [PrimaryButton]
    @ObservedObject public var currentDisabledStatus: CTAButtonDisabledStatus
    private let backgroundColor: Color

    public init(
        buttons: [PrimaryButton],
        currentDisabledStatus: CTAButtonDisabledStatus = CTAButtonDisabledStatus(value: .none),
        backgroundColor: DesignSystem.Color = .elevatedBg
    ) {
        self.buttons = buttons
        self.currentDisabledStatus = currentDisabledStatus
        self.backgroundColor = .designSystem(backgroundColor)
    }

    public var body: some View {
        CTABaseView(
            contentView:
            HStack(spacing: 9.0) {
                ForEach(0..<buttons.count) { index in
                    buttons[index]
                        .disabled(index == currentDisabledStatus.value.index)
                }
            }
            .disabled(.all == currentDisabledStatus.value),
            backgroundColor: backgroundColor
        )
    }
}

struct CTAButtonSample: View {
    @State private var title = "지원하기"
    @State private var disabledStatus = CTAButtonDisabledStatus(value: .none)
    @State private var isDisabled = false

    private let statusArray: [CTAButton.DisabledStatus] = [.all, .leading, .trailing, .none]

    var body: some View {
        VStack {
            Spacer(minLength: 50.0)
            TextField("버튼 명을 입력하세요.", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(15.0)
            Button("버튼 상태 전환") {
                disabledStatus.value = statusArray.randomElement() ?? .none
            }
            ScrollView {
                CTAButton(
                    buttons: [PrimaryButton(type: .fill, size: .large, title: title) {}],
                    currentDisabledStatus: disabledStatus
                )
                CTAButton(
                    buttons: [
                        PrimaryButton(
                            type: .fill,
                            size: .large,
                            title: title,
                            iconAlignment: .left(icon: .lineBookmark18)
                        ) {}
                    ],
                    currentDisabledStatus: disabledStatus
                )
                CTAButton(
                    buttons: [
                        PrimaryButton(
                            type: .fill,
                            size: .large,
                            title: title,
                            iconAlignment: .right(icon: .lineBookmark18)
                        ) {}
                    ],
                    currentDisabledStatus: disabledStatus
                )
                CTAButton(
                    buttons: [
                        PrimaryButton(type: .line(style: .primary), size: .large, title: title) {},
                        PrimaryButton(type: .fill, size: .large, title: title) {}
                    ],
                    currentDisabledStatus: disabledStatus
                )
                CTAButton(
                    buttons: [
                        PrimaryButton(
                            type: .line(style: .primary),
                            size: .large,
                            title: title,
                            iconAlignment: .left(icon: .lineBookmark18)
                        ) {},
                        PrimaryButton(
                            type: .fill,
                            size: .large,
                            title: title,
                            iconAlignment: .left(icon: .lineBookmark18)
                        ) {}
                    ],
                    currentDisabledStatus: disabledStatus
                )
                CTAButton(
                    buttons: [
                        PrimaryButton(
                            type: .line(style: .primary),
                            size: .large,
                            title: title,
                            iconAlignment: .right(icon: .lineBookmark18)
                        ) {},
                        PrimaryButton(
                            type: .fill,
                            size: .large,
                            title: title,
                            iconAlignment: .right(icon: .lineBookmark18)
                        ) {}
                    ],
                    currentDisabledStatus: disabledStatus
                )
            }
            .background(Color.designSystem(.baseBg))
            .disabled(isDisabled)
        }
    }
}

@available(iOS 14.0, *)
struct CTAButton_Preview: PreviewProvider {
    static var previews: some View {
        CTAButtonSample()
            .ignoresSafeArea()
    }
}
