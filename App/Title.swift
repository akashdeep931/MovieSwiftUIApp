//
//  Title.swift
//  TestApp
//
//  Created by Akashdeep Singh Kaur on 02/11/2025.
//

import Foundation

struct APIObject: Decodable {
    var results: [Title] = []
}

struct Title: Decodable, Identifiable {
    var id: Int?
    var title: String?
    var name: String?
    var overview: String?
    var posterPath: String?
    
    static var previewTitles = [
        Title.init(id: 1, title: "BeetleJuice", name: "BeetleJuice", overview: "A movie about BeetleJuice", posterPath: Constants.testTitleURL),
        Title.init(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL),
        Title.init(id: 3, title: "The Dark Knight", name: "The Dark Knight", overview: "A movie about The Dark Knight", posterPath: Constants.testTitleURL)
    ]
}
