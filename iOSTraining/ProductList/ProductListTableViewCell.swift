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
    
    
    private var currentImageURL: String?
    var product: Product? {
        didSet {
            displayData()
        }
    }
    
    private let primaryColor = UIColor(red: 0.97, green: 0.74, blue: 0.24, alpha: 1.0) // #f8bc3c
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray6
        
        featuredBadge.isHidden = true
        
        categoryBadge.layer.cornerRadius = 4
        categoryBadge.clipsToBounds = true
        
        featuredBadge.layer.cornerRadius = 4
        featuredBadge.clipsToBounds = true
        
        categoryBadge.setContentHuggingPriority(.required, for: .horizontal)
        categoryBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        currentImageURL = nil
    }
    
    private func displayData() {
        guard let product = product else { return }
        
        productNameLabel.text = product.title
        productPriceLabel.text = product.price.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
        productDescriptionLabel.text = product.description
        
        categoryBadge.isHidden = false
        categoryBadge.text = "  \(product.category.uppercased())  "
        categoryBadge.backgroundColor = primaryColor.withAlphaComponent(0.2)
        categoryBadge.textColor = primaryColor
        categoryBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        
        let discount = product.discountPercentage
        if discount > 0 {
            featuredBadge.isHidden = false
            featuredBadge.text = "  \(String(format: "%.0f", discount))% OFF  "
            featuredBadge.backgroundColor = primaryColor
            featuredBadge.textColor = .white
            featuredBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        } else {
            featuredBadge.isHidden = true
        }
        
        loadImage(from: product.thumbnail)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
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
