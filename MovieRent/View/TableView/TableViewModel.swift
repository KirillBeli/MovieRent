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
    
    func setTableView(data: [Movies], index: IndexPath, action: [Movies], comedy: [Movies], drama: [Movies], fantasy: [Movies], crime: [Movies], completion:@escaping ([Movies]?, [Movies]?, [Movies]?, [Movies]?, [Movies]?)->(Void)) {
        let filter = data[index.item]
        
        DispatchQueue.main.async { [self] in
            let category = filter.category
            addCategory(category: category, localizedS: moviesString.action, localizedC: moviesString.action.capitalized, myCategory: action, filter: filter) { _ in
                let addAction = [filter]
                completion(addAction, nil, nil, nil, nil)
            }
            addCategory(category: category, localizedS: moviesString.comedy, localizedC: moviesString.comedy.capitalized, myCategory: comedy, filter: filter) { _ in
                let addComedy = [filter]
                completion(nil, addComedy, nil, nil, nil)
            }
            addCategory(category: category, localizedS: moviesString.drama, localizedC: moviesString.drama.capitalized, myCategory: drama, filter: filter) { _ in
                let addDrama = [filter]
                completion(nil, nil, addDrama, nil, nil)
            }
            addCategory(category: category, localizedS: moviesString.fantasy, localizedC: moviesString.fantasy.capitalized, myCategory: fantasy, filter: filter) { _ in
                let addFantasy = [filter]
                completion(nil, nil, nil, addFantasy, nil)
            }
            addCategory(category: category, localizedS: moviesString.crime, localizedC: moviesString.crime.capitalized, myCategory: crime, filter: filter) { _ in
                let addCrime = [filter]
                completion(nil, nil, nil, nil, addCrime)
            }
        }
    }
    
    
    //MARK: - Select Row At
    func selectRow(data: [Movies], index: IndexPath, navigation: UINavigationController?) {
        let urlDeatilsId = "\(data[index.row].id).txt"
        let urlDetailsString = "\(URLManager.shared.urlDetailsBase)\(urlDeatilsId)"
        guard let urlDetails = URL(string: "\(urlDetailsString)") else { return }
        RequestManager.shared.getData(url: urlDetails, decodeTo: DetailsData.self) { [weak self] jsonDetails in
            guard let detailsData = jsonDetails as? DetailsData else {return}
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
     func ShowDetails(detailsData: DetailsData, promoImage: UIImage?, navigation: UINavigationController?) {
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



