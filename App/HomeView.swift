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
                case .success:
                    LazyVStack {
                        AsyncImage(url: URL(string: heroTestTitle)){ image in
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
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: geo.size.width, height: geo.size.height * 0.85)
                        
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
    //                    HorizontalListView(header: Constants.trendingTVString)
    //                    HorizontalListView(header: Constants.topRatedMovieString)
    //                    HorizontalListView(header: Constants.topRatedTVString)
                    }
                case .failed(underlyingError: let error):
                    Text("Error: \(error.localizedDescription)")
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
