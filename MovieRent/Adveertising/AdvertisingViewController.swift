//
//  LaunchViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class AdvertisingViewController: UIViewController {
    
    //MARK: - Properties
    var image = UIImage()
    @IBOutlet weak var advertisingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advertisingImage.image = image
        timerForNextPage()
        }
    
    //MARK: - Nib View
    static func makeFromNib() -> AdvertisingViewController {
        let nibName = AdvertisingViewController.className
        let vc = AdvertisingViewController(nibName: nibName, bundle: nil)
        return vc
    }
    
    //MARK: - Timer & Get MoviesData
    func timerForNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
            RequestManager.shared.uploadFomURLMovies(url: URLManager.shared.urlMovies!) { jsonMovies in
                let moviewsData = jsonMovies
                let filterData = jsonMovies.movies
                self.showTableView(moviesData: moviewsData, filterData: filterData)
            }
        }
    }
    
    //MARK: - Show TableView like rootVC
    func showTableView(moviesData: MoviesData, filterData: [Movies]) {
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
