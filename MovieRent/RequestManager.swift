//
//  RequestManager.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class RequestManager {
    
    static let shared = RequestManager()
    private init() {
    }
    
    let decoder = JSONEncoder()
    
    //MARK: - URLSession BannerURL
    func uploadFomURLBanner(url: URL, completion: @escaping (BannerData) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { jsonData, response, error in
            if jsonData != nil && error == nil {
                do {
                    let jsonBanner = try JSONDecoder().decode(BannerData.self, from: jsonData!)
                    self.decoder.outputFormatting = .prettyPrinted
                    completion(jsonBanner)
                } catch {
                    print("parse error \(error)")
                }
            }
        }.resume()
    }
    //MARK: - URLSession BannerURL
    func uploadFomURL1(url: URL, completion: @escaping (BannerData) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { jsonData, response, error in
            if jsonData != nil && error == nil {
                do {
                    let jsonBanner = try JSONDecoder().decode(BannerData.self, from: jsonData!)
                    self.decoder.outputFormatting = .prettyPrinted
                    completion(jsonBanner)
                } catch {
                    print("parse error \(error)")
                }
            }
        }.resume()
    }
    
   
    
    //MARK: - URLSession MoviesURL
    func uploadFomURL2(url: URL, completion: @escaping (MoviesData) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { jsonData, response, error in
            if jsonData != nil && error == nil {
                do {
                    let jsonMovies = try JSONDecoder().decode(MoviesData.self, from: jsonData!)
                    self.decoder.outputFormatting = .prettyPrinted
                    completion(jsonMovies)
                } catch {
                    print("parse error \(error)")
                }
            }
        }.resume()
    }
    
    //MARK: - URLSession from URLDetails
    func uploadFomURLDetails(url: URL, completion: @escaping (DetailsData) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { jsonData, response, error in
            if jsonData != nil && error == nil {
                do {
                    let jsonDetails = try JSONDecoder().decode(DetailsData.self, from: jsonData!)
                    self.decoder.outputFormatting = .prettyPrinted
                    completion(jsonDetails)
                } catch {
                    print("parse error \(error)")
                }
            }
        }.resume()
    }
    
    
}

//MARK: - NSObject Extension
@objc
extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
