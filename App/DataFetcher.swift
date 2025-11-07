//
//  DataFetcher.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 03/11/2025.
//

import Foundation

struct DataFetcher {
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    
    public func fetchTitles(for media:String, by type:String) async throws -> [Title] {
        guard let url = try buildURL(media: media, type: type) else {
            throw NetworkError.urlBuildFailed
        }

        let(data, urlResponse) = try await URLSession.shared.data(from: url)
        
        print("after run \(urlResponse)")
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var titles = try decoder.decode(APIObject.self, from: data).results
        Constants.addPosterPath(to: &titles)
        return titles
    }
    
    private func buildURL(media:String, type:String) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/trending/\(media)/day"
        } else if type == "top_rated" {
            path = "3/\(media)/top_rated"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        guard let fetchTitlesURL = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: [
                URLQueryItem(name: "api_key", value: apiKey)
            ]) else {
            throw NetworkError.urlBuildFailed
        }
        
        return fetchTitlesURL
    }
}
