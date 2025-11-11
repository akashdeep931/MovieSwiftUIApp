//
//  TitleDetailView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 07/11/2025.
//

import SwiftUI

struct TitleDetailView: View {
    let title: Title
    var titleName: String {
        return (title.name ?? title.title) ?? ""
    }
    let viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            switch (viewModel.videoIdStatus) {
            case .notStarted:
                EmptyView()
            case .fetching:
                ProgressView()
                    .frame(width: geo.size.width, height: geo.size.height)
            case .success:
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        YoutubePlayer(videoId: viewModel.videoId)
                            .aspectRatio(1.3, contentMode: .fit)
                        
                        Text(titleName)
                            .bold()
                            .font(.title2)
                            .padding(.horizontal, 5)
                        
                        Text(title.overview ?? "")
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                       
                    }
                }
            case .failed(underlyingError: let error):
                Text("Error: \(error.localizedDescription)")
                    .frame(width: geo.size.width, height: geo.size.height * 0.85)
            }
        }
        .task {
            await viewModel.getVideoId(for: titleName)
        }
    }
}

#Preview {
    TitleDetailView(title: Title.previewTitles[0])
}
