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
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Image styling
        productImageView.layer.cornerRadius = 16
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray5
        
        featuredBadge.isHidden = true
        
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
    
    // MARK: - Badge Styling
    private func configureBadge(_ label: UILabel, backgroundColor: UIColor, textColor: UIColor = .white) {
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.shadowOpacity = 0.1
        label.layer.shadowRadius = 2
        label.bounds = label.bounds.insetBy(dx: -8, dy: -4)
    }
    
    private func getCategoryColor(for category: String) -> UIColor {
        switch category.lowercased() {
        
        // Beauty & Personal Care
        case "beauty":
            return UIColor(red: 0.95, green: 0.41, blue: 0.64, alpha: 1.0)   // Pink
        case "fragrances":
            return UIColor(red: 0.55, green: 0.27, blue: 0.67, alpha: 1.0)   // Purple
        case "skin-care":
            return UIColor(red: 0.99, green: 0.73, blue: 0.55, alpha: 1.0)   // Peach
            
        // Tech
        case "smartphones":
            return UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)     // Electric Blue
        case "laptops":
            return UIColor(red: 0.10, green: 0.37, blue: 0.80, alpha: 1.0)   // Deep Blue
        case "tablets":
            return UIColor(red: 0.20, green: 0.55, blue: 0.90, alpha: 1.0)   // Sky Blue
        case "mobile-accessories":
            return UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)   // Indigo
            
        // Fashion - Womens
        case "womens-dresses":
            return UIColor(red: 0.91, green: 0.30, blue: 0.50, alpha: 1.0)   // Rose
        case "womens-shoes":
            return UIColor(red: 0.85, green: 0.20, blue: 0.40, alpha: 1.0)   // Crimson
        case "womens-bags":
            return UIColor(red: 0.75, green: 0.22, blue: 0.55, alpha: 1.0)   // Magenta
        case "womens-jewellery":
            return UIColor(red: 0.80, green: 0.60, blue: 0.20, alpha: 1.0)   // Gold
        case "womens-watches":
            return UIColor(red: 0.70, green: 0.45, blue: 0.20, alpha: 1.0)   // Bronze
        case "sunglasses":
            return UIColor(red: 0.40, green: 0.20, blue: 0.10, alpha: 1.0)   // Dark Brown
        case "tops":
            return UIColor(red: 0.60, green: 0.30, blue: 0.60, alpha: 1.0)   // Mauve
            
        // Fashion - Mens
        case "mens-shirts":
            return UIColor(red: 0.13, green: 0.55, blue: 0.45, alpha: 1.0)   // Teal Green
        case "mens-shoes":
            return UIColor(red: 0.25, green: 0.45, blue: 0.35, alpha: 1.0)   // Forest Green
        case "mens-watches":
            return UIColor(red: 0.20, green: 0.30, blue: 0.50, alpha: 1.0)   // Navy
            
        // Home & Living
        case "furniture":
            return UIColor(red: 0.60, green: 0.40, blue: 0.20, alpha: 1.0)   // Warm Brown
        case "home-decoration":
            return UIColor(red: 1.0, green: 0.27, blue: 0.23, alpha: 1.0)    // Coral
        case "kitchen-accessories":
            return UIColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1.0)   // Amber
            
        // Food
        case "groceries":
            return UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)   // Green
            
        // Vehicles
        case "vehicle":
            return UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.0)   // Charcoal
        case "motorcycle":
            return UIColor(red: 0.50, green: 0.20, blue: 0.10, alpha: 1.0)   // Dark Red
            
        // Sports
        case "sports-accessories":
            return UIColor(red: 0.0, green: 0.65, blue: 0.45, alpha: 1.0)    // Emerald
            
        default:
            return UIColor.systemGray
        }
    }
    
    // MARK: - Display
    private func displayData() {
        guard let product = product else { return }
        
        // Text fields
        productNameLabel.text = product.title
        productPriceLabel.text = product.price.formatted(.currency(code: "PHP"))
        productDescriptionLabel.text = product.description
        
        // Category badge
        categoryBadge.isHidden = false
        categoryBadge.text = "  \(product.category.uppercased())    "
        configureBadge(categoryBadge, backgroundColor: getCategoryColor(for: product.category))
        
        let discount = product.discountPercentage
        if discount > 0 {
            featuredBadge.isHidden = false
            featuredBadge.text = "  \(String(format: "%.0f", discount))% OFF   "
            configureBadge(featuredBadge, backgroundColor: UIColor(red: 0.85, green: 0.15, blue: 0.15, alpha: 1.0))
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

