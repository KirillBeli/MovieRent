//
//  URLManager.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import Foundation

class URLManager {
    
    
    static let shared = URLManager()
    private init() {
    }
    
    
    var urlBanner = URL(string: "https://x-mode.co.il/exam/allMovies/generalDeclaration.txt")!
    var urlMovies = URL(string: "https://x-mode.co.il/exam/allMovies/allMovies.txt#")
    var urlDetailsBase = "https://x-mode.co.il/exam/descriptionMovies/"
    
}

//extension URL {
//    static var urlBanner: URL = URL(string: "https://x-mode.co.il/exam/allMovies/generalDeclaration.txt")!
//    static var urlMovies: URL = URL(string: "https://x-mode.co.il/exam/allMovies/allMovies.txt#")!
//    static var urlDetailsBase: URL = URL(string: "https://x-mode.co.il/exam/descriptionMovies/")!
//}

enum HttpMethod {
    case get([URLQueryItem])
    case post(Data?)
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

struct Resourse<T: Codable> {
    
    let url: URL
    var method: HttpMethod = .get([])
}


