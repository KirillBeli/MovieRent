//
//  ViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class LaunchViewController: UIViewController, URLSessionDelegate {
    
    //MARK: - Properties
    var bannerData: BannerData?
    //    var bannerData = BannerData(banner: [Banner(isImage: String(), imageUrl: String(), videoUrl: String())])
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Cinema")
        
        //MARK: - Get Banner Data
        RequestManager.shared.uploadFomURLBanner(url: URLManager.shared.urlBanner!) { jsonBanner in
            DispatchQueue.main.async {
                self.bannerData = jsonBanner
                var imageUrl = jsonBanner.banner[1].imageUrl!
                if !imageUrl.contains("https") {
                    imageUrl = imageUrl.replacingOccurrences(of: "http", with: "https")
                }
                imageUrl = imageUrl.replacingOccurrences(of: ".jpg.jpg", with: ".jpg")
                guard let url = URL(string: "\(imageUrl)") else {return print("Convert url error")}
                
                //MARK: - Download AdvertisingImage
                RequestManager.shared.downloadImage(url: url) { (data, error) in
                    if let data = data {
                        DispatchQueue.main.sync {
                            guard let adImage = UIImage(data: data) else {return print("Data is not of type UIIMage")}
                            self.showAdvertising(image: adImage)
                        }
                    }
                }
            }
        }
    }
 
            //MARK: - Push To AdvertisingViewController
            func showAdvertising(image: UIImage) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0){
                    DispatchQueue.main.async {
                        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        guard let firstWindow = firstScene.windows.first else { return }
                        let viewController = AdvertisingViewController.makeFromNib()
                        let nav = UINavigationController(rootViewController: viewController)
                        viewController.image = image
                        firstWindow.rootViewController = nav
                    }
                }
            }
}
