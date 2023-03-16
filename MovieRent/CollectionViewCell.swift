//
//  CollectionViewCell.swift
//  MovieRent
//
//  Created by Kyrylo Bielykov on 14.03.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    var category: String = ""
    @IBOutlet weak var filterItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.filterItem.text = category
    }

    func configure(category: String) {
        self.filterItem.text = category
    }
}
