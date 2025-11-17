//
//  HorizontalProgressTrackerPreview.swift
//  Blueprint
//
//  Created by 김삼열 on 12/23/24.
//

import SwiftUI
import Montage

struct HorizontalProgressTrackerPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var progress: Int = 1
    @State private var showLabels: Bool = true
    @State private var stepCount: CGFloat = 4
    
    private let labels: [String] = ["처음이에요\n진짜", "중간이구요", "또\n중간", "끝입니다\n정말\n진짜로"]
    
    init() {}
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Preview").bold()
                    Spacer()
                    Button(action: {
                        showTransparentChecker.toggle()
                    }) {
                        Image(systemName: "checkerboard.rectangle")
                            .foregroundColor(.semantic(.primaryNormal))
                    }
                }
                
                VStack(spacing: 20) {
                    if showLabels {
                        HorizontalProgressTracker(progress: $progress, labels: labels)
                    } else {
                        HorizontalProgressTracker(progress: $progress, count: Int(stepCount))
                    }
                }
                .padding(.vertical)
                
                Text("Options").bold()
                
                HStack {
                    Text("showLabels")
                    Control.switch(checked: showLabels) { showLabels = $0 }
                }
                
                if !showLabels {
                    HStack {
                        Text("stepCount")
                        SwiftUI.Slider(value: $stepCount, in: 2...10, step: 1)
                        Text("\(Int(stepCount))")
                            .frame(width: 30)
                    }
                }
                
                HStack {
                    Spacer()
                    Button(variant: .outlined, text: "Previous") {
                        progress = max(1, progress - 1)
                    }
                    .disable(progress <= 1)
                    
                    Button(variant: .outlined, text: "Next") {
                        progress = min(progress + 1, showLabels ? labels.count : Int(stepCount))
                    }
                    .disable(progress >= (showLabels ? labels.count : Int(stepCount)))
                    Spacer()
                }
                
                Spacer(minLength: 0)
            }
            .font(.caption)
            .padding()
        }
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
        .background(SwiftUI.Color.semantic(.backgroundNormal))
    }
}

#Preview {
    HorizontalProgressTrackerPreview()
}
