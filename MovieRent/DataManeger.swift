//
//  DataMeneger.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import Foundation


//MARK: - Banner
public struct BannerData: Codable {
    let banner: [Banner]
}

public struct Banner: Codable {
    let isImage: String?
    let imageUrl: String?
    let videoUrl: String? 

    enum CodingKeys: String, CodingKey {
        case isImage = "isImage"
        case imageUrl = "imageUrl"
        case videoUrl = "videoUrl"
    }
}
//MARK: - Movies
public struct MoviesData: Codable {
    var movies: [Movies]
}
public struct Movies: Codable {
    let id: String
    let name: String
    let year: String
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case year = "year"
        case category = "category"
    }
}
//MARK: - Details
public struct DetailsData: Codable {
    let id, name, year, category: String
    let description: String
    let imageURL: String
    let promoURL: String
    let rate, hour: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, year, category, description
        case imageURL = "imageUrl"
        case promoURL = "promoUrl"
        case rate, hour
    }
}
