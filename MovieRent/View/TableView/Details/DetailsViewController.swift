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
    var image: UIImage?
    
    @IBOutlet weak var movieImage: UIImageView?
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
        self.movieImage?.image = image
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
            let viewController = PromoViewController.makeFromNib()
                viewController.url = URL(string: "\(self.detailsData.promoURL)")
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
    }
 
}

