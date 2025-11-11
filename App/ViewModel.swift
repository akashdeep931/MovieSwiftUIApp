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
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    var heroTitle = Title.previewTitles[0]
    var videoId = ""
    
    public func getTitles() async -> Void {
        homeStatus = .fetching
        if trendingMovies.isEmpty {
            do {
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTV = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let tRMovies = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let tRTV = dataFetcher.fetchTitles(for: "tv", by: "top_rated")
                
                (trendingMovies, trendingTV, topRatedMovies, topRatedTV) = try await (tMovies, tTV, tRMovies, tRTV)
                
                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                
                homeStatus = .success
            } catch {
                print("An error has occurred while fetching data: \(error.localizedDescription)")
                
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }
    
    public func getVideoId(for title: String) async -> Void {
        videoIdStatus = .fetching

        do {
            videoId = try await dataFetcher.fetchVideoId(for: title)
            videoIdStatus = .success
        } catch {
            print("An error has occurred while fetching the Video ID: \(error.localizedDescription)")
            videoIdStatus = .failed(underlyingError: error)
            return
        }
    }
}
