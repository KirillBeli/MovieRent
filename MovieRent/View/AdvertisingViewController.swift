//
//  LaunchViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 25.02.2023.
//

import UIKit

class AdvertisingViewController: UIViewController {
    
    //MARK: - Properties
    
    private var model: AdvertisingModelView?
    @IBOutlet weak var advertisingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        advertisingImage.image = model?.image
        model?.timerForNextPage()
        }
    
    //MARK: - Nib View
    static func makeFromNib(image: UIImage?, didFinishShowing: @escaping () -> Void) -> AdvertisingViewController {
        let nibName = AdvertisingViewController.className
        let vc = AdvertisingViewController(nibName: nibName, bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.model = AdvertisingModelView(image: image, didFinishShowing: didFinishShowing)
        return vc
    }
    
}
