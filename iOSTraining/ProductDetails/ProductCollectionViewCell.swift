//
//  ProductCollectionViewCell.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/26/26.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configure(with imageName: String?) {
        if let imageName = imageName {
            productImageView.image = UIImage(named: imageName)
        } else {
            productImageView.image = UIImage(systemName: "photo") // Placeholder image if imageName is nil
        }
    }
}
