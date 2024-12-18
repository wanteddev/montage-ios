//
//  ButtonPreviews.swift
//  Montage
//
//  Created by Euigyom Kim on 2023/04/24.
//

import SwiftUI

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Icon Button").montage(variant: .heading2, weight: .bold)
                    
                    IconButtonControllerPreview()
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Solid Button").montage(variant: .heading2, weight: .bold)
                    
                    SolidButtonControllerPreview()
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Outlined Button").montage(variant: .heading2, weight: .bold)
                    
                    OutlinedButtonControllerPreview()
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: .spacing(.pt20)) {
                    Text("Text Button").montage(variant: .heading2, weight: .bold)
                    
                    TextButtonPreview()
                }
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
