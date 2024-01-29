//
//  Model.swift
//  ImageApp
//
//  Created by Mr Producer on 28/01/2024.
//

import SwiftUI


struct SearchPhoto: Codable {
    var results: [Photo]
}



struct Photo: Identifiable, Codable, Hashable {
    
    let id: String
    let altDescription: String?
    let urls: [String: String]
    var likes: Int?
    let location: Location?
    let views: Int?
    let downloads: Int?

    enum CodingKeys: String, CodingKey {
        case id, altDescription = "alt_description", urls, likes, location, views, downloads
    }
}

struct Location: Codable, Hashable {
    let name: String?
    let city: String?
    let country: String?
    let position: Position
}

struct Position: Codable, Hashable {
    let latitude, longitude: Double?
}


struct FavoriteImage: Identifiable, Codable, Hashable {
    
    var id = UUID()
    var imageUrl: String
    let altDescription: String?
    let likes: Int?
    let downloads: Int?
}
