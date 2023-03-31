//
//  AdvertisingModelView.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 29.03.2023.
//

import Foundation
import UIKit

class AdvertisingModelView {
    
    let image: UIImage?
    let didFinishShowing: () -> Void
    init(image: UIImage?, didFinishShowing: @escaping () -> Void) {
        self.image = image
        self.didFinishShowing = didFinishShowing
    }
    
    //MARK: - Timer & Get MoviesData
     func timerForNextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                self?.didFinishShowing()
        }
    }
}
