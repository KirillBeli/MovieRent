//
//  ViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class LaunchViewController: UIViewController, URLSessionDelegate {
    
    //MARK: - Properties
    var bannerData = BannerData(banner: [Banner(isImage: String(), imageUrl: String(), videoUrl: String())])
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Cinema")
        
        //MARK: - Get Banner Data
        RequestManager.shared.uploadFomURL1(url: URLManager.shared.urlBanner!) { jsonBanner in
            DispatchQueue.main.async {
                self.bannerData = jsonBanner
                var imageUrl = jsonBanner.banner[1].imageUrl!
                if !imageUrl.contains("https") {
                    imageUrl = imageUrl.replacingOccurrences(of: "http", with: "https")
                }
                imageUrl = imageUrl.replacingOccurrences(of: ".jpg.jpg", with: ".jpg")
                let url = URL(string: "\(imageUrl)")
                self.downloadImage(url: url!)
            }
        }
    }
    
    //MARK: - Download Session
    func downloadImage(url: URL) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.downloadTask(with: url).resume()
    }
    
    
    //MARK: - Push To View Degital Agreement
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

//MARK: - Download URLSession of image
extension LaunchViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("we didn't get the data")
            return
        }
        guard let image = UIImage(data: data) else { return }
        showAdvertising(image: image)

    }
}
