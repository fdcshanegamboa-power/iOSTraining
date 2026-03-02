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
    
    // Primary color from design
    private let primaryColor = UIColor(red: 0.97, green: 0.74, blue: 0.24, alpha: 1.0) // #f8bc3c
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Image styling
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray6
        
        featuredBadge.isHidden = true
        
        // Badge styling
        categoryBadge.layer.cornerRadius = 4
        categoryBadge.clipsToBounds = true
        
        featuredBadge.layer.cornerRadius = 4
        featuredBadge.clipsToBounds = true
        
        categoryBadge.setContentHuggingPriority(.required, for: .horizontal)
        categoryBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Cell styling
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .default
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Reset cell before reuse to prevent stale image flicker
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        currentImageURL = nil
    }
    
    // MARK: - Display
    private func displayData() {
        guard let product = product else { return }
        
        // Text fields
        productNameLabel.text = product.title
        productPriceLabel.text = product.price.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
        productDescriptionLabel.text = product.description
        
        // Category badge - light primary color background
        categoryBadge.isHidden = false
        categoryBadge.text = "  \(product.category.uppercased())  "
        categoryBadge.backgroundColor = primaryColor.withAlphaComponent(0.2)
        categoryBadge.textColor = primaryColor
        categoryBadge.font = .systemFont(ofSize: 12, weight: .semibold)
        
        // Featured/Discount badge - solid primary color
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
        
        // Async image load from URL
        loadImage(from: product.thumbnail)
    }
    
    // MARK: - Async Image Loading
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
                // Make sure this cell hasn't been reused for a different product
                self.currentImageURL == urlString
            else { return }
            
            DispatchQueue.main.async {
                self.productImageView.image = image
            }
        }.resume()
    }
}
