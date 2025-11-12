//
//  VerticalListView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import SwiftUI

struct VerticalListView: View {
    var titles: [Title]
    
    var body: some View {
        List(titles) { title in
            NavigationLink {
                TitleDetailView(title: title)
            } label: {
                AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                    switch phase {
                    case .empty:
                        GeometryReader { geo in
                            ProgressView()
                                .frame(width: geo.size.width)
                        }
                    case .success(let image):
                        HStack {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(5)
                            
                            Text((title.name ?? title.title) ?? "")
                                .font(.system(size: 14))
                                .bold()
                        }
                    case .failure:
                        FailedImagePhasePlaceholder()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 150)
            }
        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles)
}
