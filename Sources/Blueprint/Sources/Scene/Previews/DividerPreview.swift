//
//  DividerPreview.swift
//  Montage
//
//  Created by AI Assistant on 2025/10/22.
//

import SwiftUI
import Montage

struct DividerPreview: View {
    @State private var showTransparentChecker: Bool = false
    @State private var axisIndex = 0
    @State private var variantIndex = 0
    
    private let axes: [Axis] = [.horizontal, .vertical]
    private let variants: [Montage.Divider.Variant] = [.normal, .thick]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
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
                
                Group {
                    if axes[axisIndex] == .vertical {
                        VStack(spacing: 16) {
                            Text("Contents")
                                .frame(maxHeight: .infinity)
                            
                            Divider(.horizontal, variant: variants[variantIndex])
                            
                            Text("Contents")
                                .frame(maxHeight: .infinity)
                        }
                    } else {
                        HStack(spacing: 16) {
                            Text("Contents")
                                .frame(maxWidth: .infinity)

                            Divider(.vertical, variant: variants[variantIndex])
                            
                            Text("Contents")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .frame(height: 300)
                
                // Options Section
                Text("Options").bold()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Axis")
                            .font(.font(variant: .body2, weight: .regular))
                            .foregroundStyle(SwiftUI.Color.semantic(.labelNormal))
                        
                        SegmentedControl(
                            selectedIndex: $axisIndex,
                            labels: ["Horizontal", "Vertical"]
                        )
                        .size(.small)
                    }
                    
                    HStack {
                        Text("Variant")
                            .font(.font(variant: .body2, weight: .regular))
                            .foregroundStyle(SwiftUI.Color.semantic(.labelNormal))
                        
                        SegmentedControl(
                            selectedIndex: $variantIndex,
                            labels: ["Normal", "Thick"]
                        )
                        .size(.small)
                    }
                }
            }
        }
        .padding(.horizontal)
        .transparentChecking(isPresented: showTransparentChecker, checkerSize: 51, checkerColor: .red)
    }
}

#Preview {
    DividerPreview()
}

