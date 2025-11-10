//
//  SwiftUIView.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 02/11/2025.
//

import SwiftUI

struct HomeView: View {
    let viewModel = ViewModel()
    @State private var titleDetailPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
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
                            AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: geo.size.width, height: geo.size.height * 0.85)
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
                                        .frame(width: geo.size.width, height: geo.size.height * 0.85)
                                case .failure:
                                    FailedImagePhasePlaceholder(width: geo.size.width, height: geo.size.height * 0.85)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            HStack {
                                Button {
                                    titleDetailPath.append(viewModel.heroTitle)
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
                            
                            HorizontalListView(header: Constants.trendingMovieString, titles: viewModel.trendingMovies) { title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.trendingTVString, titles: viewModel.trendingTV) { title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.topRatedMovieString, titles: viewModel.topRatedMovies) { title in
                                titleDetailPath.append(title)
                            }
                            HorizontalListView(header: Constants.topRatedTVString, titles: viewModel.topRatedTV) { title in
                                titleDetailPath.append(title)
                            }
                        }
                    case .failed(underlyingError: let error):
                        Text("Error: \(error.localizedDescription)")
                            .frame(width: geo.size.width, height: geo.size.height * 0.85)
                    }
                }
                .task{
                    await viewModel.getTitles()
                }
                .navigationDestination(for: Title.self) { title in
                    TitleDetailView(title: title)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
