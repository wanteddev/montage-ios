//
//  DateTimePickerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/27/24.
//

import SwiftUI
import Montage

struct DateTimePickerPreview: View {
    @State private var selectedDate = Date()
    @State private var datePickerStyleIndex = 0
    @State private var isBottomSheetPresented = false

    private let styleLabels = ["Compact", "Wheel", "Graphical"]

    var body: some View {
        PreviewLayout {
            HStack {
                Spacer(minLength: 0)
                VStack {
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute) {}
                        .labelsHidden()
                        .applyDatePickerStyle(index: datePickerStyleIndex)
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .date) {}
                        .labelsHidden()
                        .applyDatePickerStyle(index: datePickerStyleIndex)
                }
                Spacer(minLength: 0)
            }
        } options: {
            SegmentedIndexRow("style", index: $datePickerStyleIndex, labels: styleLabels)
            HStack {
                Text("bottomSheet")
                Switch(checked: isBottomSheetPresented) { isBottomSheetPresented = $0 }
            }
            .bottomSheet(isPresented: $isBottomSheetPresented) {
                HStack {
                    Spacer(minLength: 0)
                    VStack {
                        DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute) {}
                            .labelsHidden()
                            .applyDatePickerStyle(index: datePickerStyleIndex)
                        DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .date) {}
                            .labelsHidden()
                            .applyDatePickerStyle(index: datePickerStyleIndex)
                    }
                    Spacer(minLength: 0)
                }
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func applyDatePickerStyle(index: Int) -> some View {
        switch index {
        case 0: self.datePickerStyle(.compact)
        case 1: self.datePickerStyle(.wheel)
        case 2: self.datePickerStyle(.graphical)
        default: self.datePickerStyle(.automatic)
        }
    }
}

#Preview {
    DateTimePickerPreview()
}
