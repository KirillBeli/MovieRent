//
//  TableViewModel.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 29.03.2023.
//

import Foundation
import UIKit

class TableViewModel {
    
    //MARK: - Select Row At
    func selectRow(data: [Movies], index: IndexPath, navigation: UINavigationController?) {
        let urlDeatilsId = "\(data[index.row].id).txt"
        let urlDetailsString = "\(URLManager.shared.urlDetailsBase)\(urlDeatilsId)"
        guard let urlDetails = URL(string: "\(urlDetailsString)") else { return }
        RequestManager.shared.uploadFomURLDetails(url: urlDetails) { [weak self] jsonDetails in
            let detailsData = jsonDetails
            var urlImageString: String = "\(detailsData.imageURL)"
            if !urlImageString.contains("https") {
                urlImageString = urlImageString.replacingOccurrences(of: "http", with: "https")
            }
            guard let urlDetailImage = URL(string: "\(urlImageString)") else {return}
            //MARK: - Download PromoImage
            RequestManager.shared.downloadImage(url: urlDetailImage) { [weak self] (data, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        let promoImage = UIImage(data: data)
                        self?.ShowDetails(detailsData: detailsData, promoImage: promoImage, navigation: navigation)
                    } else {
                        print(NetworkManagerError.errorData)
                    }
                }
            }
        }
    }
    
    //MARK: - Push to Details
    private func ShowDetails(detailsData: DetailsData, promoImage: UIImage?, navigation: UINavigationController?) {
        DispatchQueue.main.async {
            let viewController = DetailsViewController.makeFromNib()
            viewController.detailsData = detailsData
            viewController.image = promoImage
            navigation?.pushViewController(viewController, animated: true)
        }
    }
     
    //MARK: - Add Categoty
     func addCategory(category: String, localizedS: String, localizedC: String, myCategory: [Movies], filter: Movies, completion: @escaping (Bool) -> ()) {
        if category == localizedS || category == localizedC {
            if !myCategory.contains(where: { $0 == filter}) {
                completion(true)
            }
        }
    }
    
    //MARK: - SearchBar Method
    func searchBarSet(data: MoviesData, bar: UISearchBar, searchText: String, completion: @escaping ([Movies]?, Movies?)->()) {
        
        if bar.text == "" {
            completion(data.movies, nil)
        }
        for word in data.movies {
            if word.name.contains(searchText) || word.category.contains(searchText) {
                completion(nil, word)
            }
        }
    }
}



