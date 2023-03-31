//
//  TableViewModel.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 29.03.2023.
//

import Foundation
import UIKit

class TableViewModel {
    
    typealias moviesString = LocalizedString.MoviesFilter
    typealias moviesTitle = LocalizedString.MoviesTitle

    private let allMovies: [Movie]
    private(set) var filteredResults: [Movie] = []
    private(set) var moviesResult: [Movie] = []
    
    init(allMovies: [Movie]) {
        self.allMovies = allMovies
        self.moviesResult = allMovies
    }
    
    func filterMovies(by category: MovieCategory, completion: () -> Void) {
        if category == .all {
            filteredResults = allMovies
            moviesResult = allMovies
        }
        else {
            filteredResults = allMovies.filter { $0.category.lowercased() == category.rawValue.lowercased() }
            moviesResult = filteredResults
        }
        completion()
    }
    
    func searchMovies(searchText text: String, completion: () -> Void) {
        if text.isEmpty {
            moviesResult = filteredResults
        }
        else {
            moviesResult = filteredResults.filter { $0.name.contains(text) || $0.category.contains(text) }
        }
        completion()
    }
    
    //MARK: - Select Row At
    func selectRow(index: Int, completion: @escaping (_ detailsData: DetailsData, _ promoImage: UIImage?) -> Void) {
        let urlDeatilsId = "\(moviesResult[index].id).txt"
        let urlDetailsString = "\(URLManager.shared.urlDetailsBase)\(urlDeatilsId)"
        guard let urlDetails = URL(string: "\(urlDetailsString)") else { return }
        RequestManager.shared.getData(url: urlDetails, decodeTo: DetailsData.self) { [weak self] jsonDetails in
            let detailsData = jsonDetails
            self?.downloadImage(imgString: detailsData.imageURL) { image in
                completion(detailsData, image)
            }
        }
    }
    
    private func downloadImage(imgString: String, completion: @escaping (_ promoImage: UIImage?) -> Void) {
        var urlImageString: String = "\(imgString)"
        if !urlImageString.contains("https") {
            urlImageString = urlImageString.replacingOccurrences(of: "http", with: "https")
        }
        guard let urlDetailImage = URL(string: "\(urlImageString)") else {return}
        //MARK: - Download PromoImage
        RequestManager.shared.downloadImage(url: urlDetailImage) { (data, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let promoImage = UIImage(data: data)
                    completion(promoImage)
                } else {
                    print(NetworkManagerError.errorData)
                }
            }
        }
    }
}



