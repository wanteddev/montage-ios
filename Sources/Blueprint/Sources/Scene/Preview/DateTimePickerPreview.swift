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
    @State private var datePickerStyleIsWheel = false
    @State private var graphicalDatePickerPresented = false
    @State private var wheelDatePickerPresented = false
    @State private var timePickerPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Preview").bold()
                HStack {
                    Spacer()
                    Text(selectedDate.formatted("yyyy.MM.dd"))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.blue))
                        .onTapGesture {
                            graphicalDatePickerPresented.toggle()
                        }
                    
                    Text(selectedDate.formatted("hh:mm:ss"))
                        .padding(8)
                        .foregroundColor(.white)
                        .background(RoundedRectangle(cornerRadius: 12).foregroundColor(.blue))
                        .onTapGesture {
                            timePickerPresented.toggle()
                        }
                    Spacer()
                }
                .bottomSheetModal(isPresented: $graphicalDatePickerPresented) {
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .date) {}
                        .labelsHidden()
                        .if(datePickerStyleIsWheel) {
                            $0.datePickerStyle(.wheel)
                        } else: {
                            $0.datePickerStyle(.graphical)
                        }
                }
                .bottomSheetModal(isPresented: $timePickerPresented) {
                    DatePicker(selection: $selectedDate, in: Date.now...Date.distantFuture, displayedComponents: .hourAndMinute) {}
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                Text("Options").bold()
                HStack {
                    Text("wheel style date picker")
                    Control.Switch($datePickerStyleIsWheel)
                }
            }
            .padding(.horizontal)
        }
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    DateTimePickerPreview()
}
