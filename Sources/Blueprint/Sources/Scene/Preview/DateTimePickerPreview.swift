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
    @State private var graphicalDatePickerPresented = false
    @State private var wheelDatePickerPresented = false
    @State private var timePickerPresented = false

    let datePickerStyles: [any DatePickerStyle] = [.compact, .wheel, .graphical]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if !graphicalDatePickerPresented {
                    datePicker
                }
                
                Text("Options").bold()
                HStack {
                    Text("style")
                    SegmentedControl(
                        selectedIndex: $datePickerStyleIndex,
                        labels: datePickerStyles.map { String(describing: $0).replacingOccurrences(of: "DatePickerStyle()", with: "") }
                    )
                    .size(.small)
                }
                HStack {
                    Text("bottomSheet")
                    Switch($graphicalDatePickerPresented)
                }
                .bottomSheetModal(isPresented: $graphicalDatePickerPresented) {
                    datePicker
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
    
    var datePicker: some View {
        VStack(alignment: .leading) {
            Text("Preview").bold()
            HStack {
                Spacer(minLength: 0)
                VStack {
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute) {}
                        .labelsHidden()
                        .modifying({
                            switch datePickerStyleIndex {
                            case 0: $0.datePickerStyle(.compact)
                            case 1: $0.datePickerStyle(.wheel)
                            case 2: $0.datePickerStyle(.graphical)
                            default: $0.datePickerStyle(.automatic)
                            }
                        })
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .date) {}
                        .labelsHidden()
                        .modifying({
                            switch datePickerStyleIndex {
                            case 0: $0.datePickerStyle(.compact)
                            case 1: $0.datePickerStyle(.wheel)
                            case 2: $0.datePickerStyle(.graphical)
                            default: $0.datePickerStyle(.automatic)
                            }
                        })
                }
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview {
    DateTimePickerPreview()
}
