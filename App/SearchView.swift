//
//  SearchView.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchByMovies = true
    @State private var searchText = ""
    @State private var titleDetailViewPath = NavigationPath()
    private let searchViewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack(path: $titleDetailViewPath) {
            ScrollView {
                if let error = searchViewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
                    ForEach(searchViewModel.searchTitles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { phase in
                            switch phase {
                            case .empty:
                                GeometryReader { geo in
                                    ProgressView()
                                        .frame(width: geo.size.width, height: geo.size.height)
                                }
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            case .failure:
                                FailedImagePhasePlaceholder()
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            titleDetailViewPath.append(title)
                        }
                    }
                }
            }
            .navigationTitle(searchByMovies ?
                             Constants.movieSearchString : Constants.tvSearchString)
            .navigationDestination(for: Title.self, destination: { title in
                TitleDetailView(title: title)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchByMovies.toggle()
                        
                        Task {
                            await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
                        }
                    } label: {
                        searchByMovies ?
                        Image(systemName: Constants.movieIconString) : Image(systemName: Constants.tvIconString)
                    }
                }
            }
            .searchable(text: $searchText, prompt: searchByMovies ? Constants.moviePlaceHolderString : Constants.tvPlaceHolderString)
            .task(id: searchText) {
                try? await Task.sleep(for: .milliseconds(500))
                
                if Task.isCancelled {
                    return
                }
                
                await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
            }
        }
    }
}

#Preview {
    SearchView()
}
