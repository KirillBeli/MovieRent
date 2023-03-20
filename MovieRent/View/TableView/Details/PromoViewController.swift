//
//  PromoViewController.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 26.02.2023.
//

import UIKit
import WebKit

class PromoViewController: UIViewController {

    //MARK: - Properties
    var url = URL(string: "")
    
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url:URL = url else {return}
            self.webView.load(URLRequest(url: url))
        }

  
    
    //MARK: - Nib View
    static func makeFromNib() -> PromoViewController {
        let nibName = PromoViewController.className
        let vc = PromoViewController(nibName: nibName, bundle: nil)
        return vc
    }

}
