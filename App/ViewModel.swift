//
//  ViewModel.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 05/11/2025.
//

import Foundation

@Observable
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }
    
    private(set) var homeStatus: FetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    
    public func getTitles() async {
        homeStatus = .fetching
        
        do {
            trendingMovies = try await dataFetcher.fetchTitles(for: "movie", by: "trending")
            trendingTV = try await dataFetcher.fetchTitles(for: "tv", by: "trending")
            topRatedMovies = try await dataFetcher.fetchTitles(for: "movie", by: "top_rated")
            topRatedTV = try await dataFetcher.fetchTitles(for: "tv", by: "top_rated")
            
            homeStatus = .success
        } catch {
            print("An Error has occured while fetching data \(error.localizedDescription)")
            
            homeStatus = .failed(underlyingError: error)
        }
    }
}
