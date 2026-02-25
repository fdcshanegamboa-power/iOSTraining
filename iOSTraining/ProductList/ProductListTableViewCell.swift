//
//  ProductListTableViewCell.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var featuredBadge: UILabel!
    @IBOutlet weak var categoryBadge: UILabel!
    
    var product: Product?{
        didSet{
            displayData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Image styling
        productImageView.layer.cornerRadius = 16
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray5
            
        // Badges
        configureBadge(featuredBadge)
        configureBadge(categoryBadge)
    
        // Cell styling
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configureBadge(_ label: UILabel){
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
    }
    
    private func displayData(){
        guard let product = product else {
            return
        }
        
        productNameLabel.text = product.name
        productPriceLabel.text = product.price.formatted(.currency(code: "PHP"))
        productDescriptionLabel.text = product.description
        
        if let imageName = product.image {
            productImageView.image = UIImage(named: imageName)
        } else {
            productImageView.image = UIImage(systemName: "spotify")
        }
        
        featuredBadge.isHidden = !product.isFeatured
        featuredBadge.text = "Featured"
        
        if let category = product.category {
            categoryBadge.isHidden = false
            categoryBadge.text = category.uppercased()
        } else {
            categoryBadge.isHidden = true
        }
    }
}
