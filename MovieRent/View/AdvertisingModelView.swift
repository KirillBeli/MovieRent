//
//  AdvertisingModelView.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 29.03.2023.
//

import Foundation
import UIKit

class AdvertisingModelView {
    
    //MARK: - Timer & Get MoviesData
     func timerForNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            guard let urlMovies = URLManager.shared.urlMovies else {return}
            RequestManager.shared.getData(url: urlMovies, decodeTo: MoviesData.self) { [weak self] jsonDetails in
                guard let jsonDetails = jsonDetails as? MoviesData else {return}
                let moviewsData = jsonDetails
                let filterData = jsonDetails.movies
                self?.showTableView(moviesData: moviewsData, filterData: filterData)
            }
        }
    }
    
    //MARK: - Show TableView like rootVC
    private func showTableView(moviesData: MoviesData, filterData: [Movies]) {
        DispatchQueue.main.async {
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let firstWindow = firstScene.windows.first else { return }
            let viewController = TableViewController.makeFromNib()
            let nav = UINavigationController(rootViewController: viewController)
            viewController.moviesData = moviesData
            viewController.filterData = filterData
            firstWindow.rootViewController = nav
        }
    }
}
