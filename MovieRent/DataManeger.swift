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

public struct Banner: Codable, Equatable {
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
    var movies: [Movie]
}

enum MovieCategory: String {
    case all = "All"
    case action = "Action"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case crime = "Crime"
    case comedy = "Comedy"
    
    init(tag: Int) {
        switch tag {
        case 0: self = .all
        case 1: self = .action
        case 2: self = .drama
        case 3: self = .fantasy
        case 4: self = .crime
        case 5: self = .comedy
        default: self = .all
        }
    }
}

public struct Movie: Codable, Equatable {
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


struct LocalizedString {
    
    struct ImagesString {
        static let advertisingImage = "Cinema"
    }
    
    struct MoviesFilter {
        static let action = "action"
        static let comedy = "comedy"
        static let drama = "drama"
        static let fantasy = "fantasy"
        static let crime = "crime"
    }
    
    struct MoviesTitle {
        static let action = "Action"
        static let comedy = "Comedy"
        static let drama = "Drama"
        static let fantasy = "Fantasy"
        static let crime = "Crime"
        static let movies = "Movies"
    }
}
