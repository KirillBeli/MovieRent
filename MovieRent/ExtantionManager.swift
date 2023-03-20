//
//  ExtantionManager.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 20.03.2023.
//

import Foundation
import UIKit

//MARK: - NSObject Extension
@objc
extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

//MARK: - TableView Extension
extension UITableView {
    
    func registerXib(xibName: String) {
        let xib = UINib(nibName: xibName, bundle: nil)
        register(xib, forCellReuseIdentifier: xibName)
    }
}
