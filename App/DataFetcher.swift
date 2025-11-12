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
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    
    public func fetchTitles(for media:String, by type:String, with title: String? = nil) async throws -> [Title] {
        guard let url = try buildURL(media: media, type: type, searchQuery: title) else {
            throw NetworkError.urlBuildFailed
        }

        var titles = try await fetchAndDecode(url: url, type: TMDBAPIObject.self).results
        
        Constants.addPosterPath(to: &titles)
        return titles
    }
    
    private func buildURL(media: String, type: String, searchQuery: String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming" {
            path = "3/\(media)/\(type)"
        } else if type == "search" {
            path = "3/\(type)/\(media)"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        var urlQueryItems = [
            URLQueryItem(name: "api_key", value: tmdbAPIKey)
        ]
        
        if let searchQuery {
            urlQueryItems.append(URLQueryItem(name: "query", value: searchQuery))
        }
        
        guard let fetchTitlesURL = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: urlQueryItems) else {
            throw NetworkError.urlBuildFailed
        }
        
        return fetchTitlesURL
    }
    
    public func fetchVideoId(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfig
        }
        
        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfig
        }
        
        let trailerSearch = title + YoutubeURLString.space.rawValue + YoutubeURLString.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: baseSearchURL)?.appending(queryItems: [
            URLQueryItem(name: YoutubeURLString.quertShorten.rawValue, value: trailerSearch),
            URLQueryItem(name: YoutubeURLString.key.rawValue, value: searchAPIKey)
        ]) else {
            throw NetworkError.urlBuildFailed
        }
        
        return try await fetchAndDecode(url: fetchVideoURL, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
    }
    
    private func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let(data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(type, from: data)
    }
}
