//
//  TitleDetailView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 07/11/2025.
//

import SwiftUI

struct TitleDetailView: View {
    let title: Title
    
    
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure:
                            FailedImagePhasePlaceholder()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height * 0.85)
                    
                    Text((title.name ?? title.title) ?? "")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal, 5)
                    
                    Text(title.overview ?? "")
                        .padding(.horizontal, 5)
                }
            }
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
