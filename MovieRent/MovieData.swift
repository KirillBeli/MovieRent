

import Foundation

struct MovieList: Codable {
//    let movies: [id: Int, name: String, year: Int, category: String ]
    let id: Int
    let name: String
    let year: Int
    let category: String
}

struct SplashAPI: Codable {
    let imageUrl: String
    let videoUrl : String
}



