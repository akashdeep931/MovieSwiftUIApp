//
//  YoutubeSearchResponse.swift
//  App
//
//  Created by Akashdeep Singh Kaur on 11/11/2025.
//

import Foundation

struct YoutubeSearchResponse: Decodable {
    let items: [ItemProperties]?
}

struct ItemProperties: Decodable {
    let id: IdProperties?
}

struct IdProperties: Decodable {
    let videoId: String?
}
