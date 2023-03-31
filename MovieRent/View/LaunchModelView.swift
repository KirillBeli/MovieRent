//
//  LaunchModelView.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 29.03.2023.
//

import Foundation
import UIKit

class LaunchModelView {
    
    var bannerData: BannerData?
    
    //MARK: - Get Banner Data
    func loadAdvertising() {
        
        let urlBanner = URLManager.shared.urlBanner
        RequestManager.shared.getData(url: urlBanner, decodeTo: BannerData.self) { [weak self] jsonDetails in
            DispatchQueue.main.async {
                self?.bannerData = jsonDetails
                guard var imageUrl = self?.bannerData?.banner[1].imageUrl else {return}
                if !imageUrl.contains("https") {
                    imageUrl = imageUrl.replacingOccurrences(of: "http", with: "https")
                }
                imageUrl = imageUrl.replacingOccurrences(of: ".jpg.jpg", with: ".jpg")
                guard let url = URL(string: "\(imageUrl)") else {return print("Convert url error")}
                
                //MARK: - Download AdvertisingImage
                RequestManager.shared.downloadImage(url: url) { [weak self] (data, error) in
                    if let data = data {
                        DispatchQueue.main.sync {
                            guard let adImage = UIImage(data: data) else {return print("Data is not of type UIIMage")}
                            self?.showAdvertising(image: adImage)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Push To AdvertisingViewController
     func showAdvertising(image: UIImage) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            DispatchQueue.main.async {
                guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let firstWindow = firstScene.windows.first else { return }
                var viewController: AdvertisingViewController?
                viewController = AdvertisingViewController.makeFromNib(image: image) {
                    viewController?.dismiss(animated: true)
                    self?.startShowTableFlow()
                }
                guard let vc = viewController else { return }
                firstWindow.rootViewController?.present(vc, animated: true)
            }
        }
    }
        private func startShowTableFlow() {
            guard let urlMovies = URLManager.shared.urlMovies else {return}
            RequestManager.shared.getData(url: urlMovies, decodeTo: MoviesData.self) { [weak self] jsonDetails in
                let moviewsData = jsonDetails
                let filterData = jsonDetails.movies
                self?.showTableView(moviesData: moviewsData, filterData: filterData)
            }
        }
        
        //MARK: - Show TableView like rootVC
        private func showTableView(moviesData: MoviesData, filterData: [Movie]) {
            DispatchQueue.main.async {
                guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let firstWindow = firstScene.windows.first else { return }
                let viewController = TableViewController.makeFromNib(data: moviesData.movies)
                let nav = UINavigationController(rootViewController: viewController)
                firstWindow.rootViewController = nav
            }
        }
}
