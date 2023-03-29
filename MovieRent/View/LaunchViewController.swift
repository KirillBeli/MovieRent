//
//  ViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class LaunchViewController: UIViewController, URLSessionDelegate {
    
    //MARK: - Properties
//    var bannerData: BannerData?
    let model = LaunchModelView()
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: LocalizedString.ImagesString.advertisingImage)
        
        model.loadAdvertising()
    }
 
}
