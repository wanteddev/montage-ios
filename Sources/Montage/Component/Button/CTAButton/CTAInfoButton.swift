//
//  CTAInfoButton.swift
//  Montage
//
//  Created by Eunyeong Kim on 2021/04/21.
//

import SwiftUI

/// Info + Button 만으로 구현되는 CTAButton 입니다.
public struct CTAInfoButton: View {
    let info: CTAInfo
    let button: PrimaryButton
    let backgroundColor = Color.designSystem(.baseBg)

    public var body: some View {
        CTABaseView(
            contentView:
            HStack(spacing: 9.0) {
                info
                Spacer()
                button
                    .frame(idealWidth: 145.0, maxWidth: 145.0)
            },
            backgroundColor: backgroundColor
        )
    }
}

/// CTAInfoButton에서 Leading을 차지하게 되는 View 입니다.
public struct CTAInfo: View {
    let title: String?
    let amount: String?
    let unit: String

    public var body: some View {
        VStack(alignment: .leading, spacing: 2.0) {
            if let title = title {
                Text(title)
                    .designSystem(ofSize: 16.0, weight: .medium, color: .neutralGray700)
            }
            HStack(alignment: .center, spacing: 3.0) {
                if let amount = amount {
                    Text(amount)
                        .designSystem(ofSize: 24.0, weight: .bold, color: .neutralBlack100)
                }
                Text(unit)
                    .designSystem(ofSize: 20.0, weight: .bold, color: .neutralBlack100)
            }
        }
    }
}

@available(iOS 14.0, *)
struct CTAInfoButton_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CTAInfoButton(
                info: CTAInfo(title: "명강사의 명강의", amount: "23,000", unit: "원"),
                button: PrimaryButton(type: .fill, size: .large, title: "수강하기") {}
            )
        }.ignoresSafeArea()
    }
}
