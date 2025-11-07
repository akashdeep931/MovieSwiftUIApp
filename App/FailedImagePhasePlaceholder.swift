//
//  FailedImagePhasePlaceholder.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 07/11/2025.
//

import SwiftUI

struct FailedImagePhasePlaceholder: View {
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay {
                VStack {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.gray)
                    Text(Constants.imageUnavailable)
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: width, height: height)
    }
}

#Preview {
    FailedImagePhasePlaceholder(width: 300, height: 400)
}
