//
//  SwiftUIView.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 02/11/2025.
//

import SwiftUI

struct HomeView: View {
    var heroTestTitle = Constants.testTitleURL
    let viewModel = ViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                switch (viewModel.homeStatus) {
                case .notStarted:
                    EmptyView()
                case .fetching:
                    ProgressView()
                        .frame(width: geo.size.width, height: geo.size.height)
                case .success:
                    LazyVStack {
                        AsyncImage(url: URL(string: heroTestTitle)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: geo.size.width, height: geo.size.height * 0.80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .overlay {
                                        LinearGradient(
                                            stops: [Gradient.Stop(color: .clear, location: 0.8),
                                                    Gradient.Stop(color: .gradient, location: 1)],
                                            startPoint: .top,
                                            endPoint: .bottom)
                                    }
                                    .frame(width: geo.size.width, height: geo.size.height * 0.80)
                            case .failure:
                                FailedImagePhasePlaceholder(width: geo.size.width, height: geo.size.height * 0.80)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Text(Constants.playString)
                                    .ghostButton()
                            }
                            
                            Button {
                                
                            } label: {
                                Text(Constants.dowloadString)
                                    .ghostButton()
                            }
                        }
                        
                        HorizontalListView(header: Constants.trendingMovieString, titles: viewModel.trendingMovies)
                        HorizontalListView(header: Constants.trendingTVString, titles: viewModel.trendingTV)
                        HorizontalListView(header: Constants.topRatedMovieString, titles: viewModel.topRatedMovies)
                        HorizontalListView(header: Constants.topRatedTVString, titles: viewModel.topRatedTV)
                    }
                case .failed(underlyingError: let error):
                    Text("Error: \(error.localizedDescription)")
                        .frame(width: geo.size.width, height: geo.size.height * 0.80)
                }
            }
            .task{
                await viewModel.getTitles()
            }
        }
    }
}

#Preview {
    HomeView()
}
