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
        ScrollView {
            VStack(alignment: .leading) {
                if !isBottomSheetPresented {
                    datePicker
                }
                
                Text("Options").bold()
                HStack {
                    Text("style")
                    SegmentedControl(
                        selectedIndex: $datePickerStyleIndex,
                        labels: styleLabels
                    )
                    .size(.small)
                }
                HStack {
                    Text("bottomSheet")
                    Control.switch(checked: isBottomSheetPresented) { isBottomSheetPresented = $0 }
                }
                .bottomSheetModal(isPresented: $isBottomSheetPresented) {
                    datePicker
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    private var datePicker: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
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
