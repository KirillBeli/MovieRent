//
//  RequestManager.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class RequestManager {
    
    static let shared = RequestManager(session: URLSession(), image: UIImage())
    var session: URLSession
    var image: UIImage
    private init(session: URLSession, image: UIImage) {
        self.session = session
        self.image = image
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
    
    //MARK: - URLSession MoviesURL
    func uploadFomURLMovies(url: URL, completion: @escaping (MoviesData) -> Void) {
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
                completion(nil, NetworkManagerError.badData as? Error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { completion(nil, NetworkManagerError.badResponse(URLResponse()) as? Error)
                return
            }
            guard let url = url else { completion(nil, NetworkManagerError.badLocalUrl as? Error)
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

//MARK: - TableView Extension
extension UITableView {
    
    func registerXib(xibName: String) {
        let xib = UINib(nibName: xibName, bundle: nil)
        register(xib, forCellReuseIdentifier: xibName)
    }
}
//MARK: - Error Manager
enum NetworkManagerError {
    case badResponse(URLResponse?)
    case badLocalUrl
    case badData
}
