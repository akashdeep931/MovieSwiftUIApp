//
//  Errors.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 02/11/2025.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "API configuration file not found. Please ensure APIConfig.json is included in the app bundle."
        case .dataLoadingFailed(underlyingError: let error):
            return "Failed to load configuration data: \(error.localizedDescription)"
        case .decodingFailed(underlyingError: let error):
            return "Failed to parse configuration file: \(error.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
            case .badURLResponse(underlyingError: let error):
                return "Failed to parse URL response: \(error.localizedDescription)"
            case .missingConfig:
                return "Missing API configuration."
            case .urlBuildFailed:
                return "Failed to build URL"
        }
    }
}
