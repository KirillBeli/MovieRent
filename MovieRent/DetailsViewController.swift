//
//  DetailsViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 26.02.2023.
//

import UIKit

class DetailsViewController: UIViewController, URLSessionDelegate {
    
    //MARK: - Properties
    var detailsData: DetailsData!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var promoTitle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = detailsData.name
        self.yearLabel.text = "Year: \(detailsData.year)"
        self.categoryLabel.text = "Category: \(detailsData.category)"
        self.rateLabel.text = "Rate: \(detailsData.rate)"
        self.descriptionLabel.text = "Description: \(detailsData.description)"
        self.promoTitle.setTitle("Watch Promo", for: .normal)
        var urlImageString: String = "\(detailsData.imageURL)"
        if !urlImageString.contains("https") {
            urlImageString = urlImageString.replacingOccurrences(of: "http", with: "https")
        }
        guard let urlImage = URL(string: "\(urlImageString)") else { return }
        //MARK: - Download PromoImage
        RequestManager.shared.downloadImage(url: urlImage) { (data, error) in
            DispatchQueue.main.async {
                if let data = data {
                    let promoImage = UIImage(data: data)
                    self.movieImage.image = promoImage
                } else {
                    print(error as Any)
                }
            }
            
        }
    }
    
    
    //MARK: - Nib View
    static func makeFromNib() -> DetailsViewController {
        let nibName = DetailsViewController.className
        let vc = DetailsViewController(nibName: nibName, bundle: nil)
        return vc
    }
    //MARK: - Show Promo 
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
 
}

