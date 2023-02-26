//
//  DetailsViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 26.02.2023.
//

import UIKit

class DetailsViewController: UIViewController, URLSessionDelegate {
    
    //MARK: - Properties
    var detailsData = DetailsData(id: String(), name: String(), year: String(), category: String(), description: String(), imageURL: String(), promoURL: String(), rate: String(), hour: String())
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var promoTitle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.detailsData)
        self.nameLabel.text = detailsData.name
        self.yearLabel.text = "Year: \(detailsData.year)"
        self.categoryLabel.text = "Category: \(detailsData.category)"
        self.rateLabel.text = "Rate: \(detailsData.rate)"
        self.descriptionLabel.text = "Description: \(detailsData.description)"
        
        self.promoTitle.titleLabel?.numberOfLines = 1
        self.promoTitle.titleLabel?.lineBreakMode = .byTruncatingTail
        self.promoTitle.setTitle("\(detailsData.promoURL)", for: .normal)
        
        var urlImageString: String = "\(self.detailsData.imageURL)"
        if !urlImageString.contains("https") {
            urlImageString = urlImageString.replacingOccurrences(of: "http", with: "https")
        }
        guard let urlImage = URL(string: "\(urlImageString)") else { return }
        downloadImage(url: urlImage)
    }
    
    
    //MARK: - Nib View
    static func makeFromNib() -> DetailsViewController {
        let nibName = DetailsViewController.className
        let vc = DetailsViewController(nibName: nibName, bundle: nil)
        return vc
    }
    
    @IBAction func promoButton(_ sender: UIButton) {
        guard let urlPromo = URL(string: "\(detailsData.promoURL)") else { return }
        ShowPromo(url: urlPromo)
    }
    
    //MARK: - Push to webView
    func ShowPromo(url: URL) {
        DispatchQueue.main.async {
            guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let firstWindow = firstScene.windows.first else { return }
            let viewController = PromoViewController.makeFromNib()
            if let nav = firstWindow.rootViewController as? UINavigationController {
                viewController.url = URL(string: "\(self.detailsData.promoURL)")
                nav.pushViewController(viewController, animated: true)
            }
        }
    }
    
    //MARK: - Download Session
    func downloadImage(url: URL) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        session.downloadTask(with: url).resume()
    }
    
}

//MARK: - Download URLSession of image
extension DetailsViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else {
            print("we didn't get the data")
            return
        }
        let image = UIImage(data: data)
        movieImage.image = image
    }
    
    
    
}
