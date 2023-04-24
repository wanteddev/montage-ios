//
//  ChipPreviews.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import SwiftUI

struct Chip_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Action Chip").montage(varient: .heading1, weight: .bold)
                    
                    actionChipControllerPreview
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Filter Chip").montage(varient: .heading1, weight: .bold)
                    
                    filterChipControllerPreview
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("MultiSelect Chip").montage(varient: .heading1, weight: .bold)
                    
                    multiSelectChipControllerPreview
                }
            }
            
            Spacer()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
