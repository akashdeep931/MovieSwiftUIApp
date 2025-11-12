//
//  File.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 12/11/2025.
//

import Foundation

@Observable
class SearchViewModel {
    private(set) var errorMessage: String?
    private(set) var searchTitles: [Title] = []
    private let dataFetcher = DataFetcher()
    
    func getSearchTitles(by media: String, for title: String) async {
        do {
            errorMessage = nil
            
            if title.isEmpty {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "search", with: title)
            }
        } catch {
            print("An error has occurred while fetching data: \(error.localizedDescription)")
            
            errorMessage = error.localizedDescription
        }
    }
}
