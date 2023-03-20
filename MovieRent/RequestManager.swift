//
//  RequestManager.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class RequestManager {
    
    static let shared = RequestManager(image: UIImage())
    var session = URLSession.shared
    var image: UIImage
    let decoder = JSONEncoder()
    private init(image: UIImage) {
        self.image = image
    }
    
    
    
    //MARK: - URLSession BannerURL
    func uploadFromURLBanner(url: URL, completion: @escaping (BannerData) -> Void) {
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
    func uploadFromURLMovies(url: URL, completion: @escaping (MoviesData) -> Void) {
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
    
    func downloadImage(url: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        let configur = URLSessionConfiguration.default
        session = URLSession(configuration: configur)
        let _: Void = session.downloadTask(with: url) { url, response, error in
            if error != nil {
                completion(nil, NetworkManagerError.errorData as? Error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { completion(nil, NetworkManagerError.errorResponse(URLResponse()) as? Error)
                return
            }
            guard let url = url else { completion(nil, NetworkManagerError.errorLocalUrl as? Error)
                return
            }
            do{
                let data = try Data(contentsOf: url)
                completion(data, nil)
            } catch let error {
                completion(nil, error)
            }
        }.resume()
    }
    
}
