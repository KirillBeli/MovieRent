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
    
    func getData<T: Codable>(url: URL, decodeTo: T.Type, completion: @escaping (Any)->()) {
        let session = URLSession.shared
        session.dataTask(with: url) { jsonData, response, error in
            if jsonData != nil && error == nil {
                do {
                    guard let jsonData = jsonData else {return}
                    let jsonDetails = try JSONDecoder().decode(T.self, from: jsonData)
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
                completion(nil, NetworkManagerError.errorData)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { completion(nil, NetworkManagerError.errorResponse(response))
                return
            }
            guard let url = url else { completion(nil, NetworkManagerError.errorLocalUrl)
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
    
//    func load<T: Codable>(resource: Resourse<T>) async throws -> T {
//
//        var request = URLRequest(url: resource.url)
//        switch resource.method {
//        case .post(let data):
//            request.httpMethod = resource.method.name
//            request.httpBody = data
//        case .get(let queryItems):
//            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
//            components?.queryItems = queryItems
//            guard let url = components?.url else { throw NetworkManagerError.errorLocalUrl }
//            request = URLRequest(url: url)
//        }
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
//        let session = URLSession(configuration: configuration)
//        let (data, response) = try await session.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { throw NetworkManagerError.errorResponse(response)}
//        guard let result = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkManagerError.errorData }
//
//
//        return result
//    }
}
