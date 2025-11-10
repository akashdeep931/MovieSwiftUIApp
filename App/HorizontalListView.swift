//
//  HorizontalListView.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 02/11/2025.
//

import SwiftUI

struct HorizontalListView: View {
    let header: String
    let titles: [Title]
    let onSelect: (Title) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header).font(.title)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(titles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            case .failure:
                                FailedImagePhasePlaceholder()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            onSelect(title)
                        }
                    }
                }
            }
        }
        .frame(height: 250)
        .padding(10)
    }
}

#Preview {
    HorizontalListView(header: Constants.trendingMovieString, titles: Title.previewTitles) { title in }
}
