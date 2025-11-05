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
    
    public func getTitles() async {
        homeStatus = .fetching
        
        do {
            trendingMovies = try await dataFetcher.fetchTitles(for: "movie")
            
            homeStatus = .success
        } catch {
            print("An Error has occured while fetching data \(error.localizedDescription)")
            
            homeStatus = .failed(underlyingError: error)
        }
    }
}
