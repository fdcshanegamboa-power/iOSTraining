//
//  ProductCollectionViewCell.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/26/26.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    private var currentImageURL: String?
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        currentImageURL = nil
    }
        
    func configure(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            productImageView.image = UIImage(systemName: "photo")
            return
        }
            
        currentImageURL = urlString
            
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let image = UIImage(data: data),
                self.currentImageURL == urlString
            else { return }
            
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }.resume()
    }
}
