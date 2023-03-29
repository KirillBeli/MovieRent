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
    let model = AdvertisingModelView()
    @IBOutlet weak var advertisingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advertisingImage.image = image
        model.timerForNextPage()
//        timerForNextPage()
        }
    
    //MARK: - Nib View
    static func makeFromNib() -> AdvertisingViewController {
        let nibName = AdvertisingViewController.className
        let vc = AdvertisingViewController(nibName: nibName, bundle: nil)
        return vc
    }
    
}
