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
    @IBOutlet weak var cardContainer: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var stockLabel: UILabel!
    
    private var currentImageURL: String?
    var product: Product? {
        didSet {
            displayData()
        }
    }
    
    private let primaryColor = UIColor(red: 0.97, green: 0.74, blue: 0.24, alpha: 1.0) // #f8bc3c
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Card shadow and styling
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardContainer.layer.shadowRadius = 8
        cardContainer.layer.shadowOpacity = 0.1
        cardContainer.layer.masksToBounds = false
        
        // Product image styling
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        productImageView.contentMode = .scaleAspectFill
        productImageView.backgroundColor = .systemGray6
        
        // Badge styling
        featuredBadge.isHidden = true
        featuredBadge.layer.cornerRadius = 4
        featuredBadge.clipsToBounds = true
        
        categoryBadge.layer.cornerRadius = 4
        categoryBadge.clipsToBounds = true
        categoryBadge.setContentHuggingPriority(.required, for: .horizontal)
        categoryBadge.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Rating star styling
        ratingImageView.tintColor = primaryColor
        ratingImageView.contentMode = .scaleAspectFit
        
        // Remove default cell styling for card effect
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        currentImageURL = nil
        featuredBadge.isHidden = true
        categoryBadge.isHidden = false
        ratingLabel.text = nil
        stockLabel.text = nil
    }
    
    private func displayData() {
        guard let product = product else { return }
        
        productNameLabel.text = product.title
        productDescriptionLabel.text = product.description
        
        
        if let flashItem = FlashSaleService.shared.currentFlashItems.first(
            where: { $0.product.id == product.id }) {
            let originalText = NSMutableAttributedString(
                string: product.price.formatted(
                    .currency(code: "USD")
                    .locale(Locale(identifier: "en_US"))) + "  ",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                             .foregroundColor: UIColor.systemGray]
            )
            let flashText = NSAttributedString (
                string: flashItem.flashPrice.formatted(
                    .currency(code: "USD")
                    .locale(Locale(identifier: "en_US"))),
                attributes: [
                    .foregroundColor: UIColor.systemRed,
                    .font: UIFont.systemFont(ofSize: 15, weight: .bold)]
            )
            originalText.append(flashText)
            productPriceLabel.attributedText = originalText
            let flashDiscount = ((product.price - flashItem.flashPrice) / product.price) * 100
            featuredBadge.isHidden = false
            featuredBadge.text = "  🔥 \(String(format: "%.0f", flashDiscount))% OFF  "
            featuredBadge.backgroundColor = .systemRed
            featuredBadge.textColor = .white
            featuredBadge.font = .systemFont(ofSize: 11, weight: .heavy)
        } else {
            productPriceLabel.attributedText = nil
            productPriceLabel.text = product.price.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))
            // Discount badge overlaid on image
            let discount = product.discountPercentage
            if discount > 0 {
                featuredBadge.isHidden = false
                featuredBadge.text = "  \(String(format: "%.0f", discount))% OFF  "
                featuredBadge.backgroundColor = primaryColor
                featuredBadge.textColor = .white
                featuredBadge.font = .systemFont(ofSize: 11, weight: .heavy)
            } else {
                featuredBadge.isHidden = true
            }
        }
        // Category badge in content area (after product name)
        categoryBadge.isHidden = false
        categoryBadge.text = "  \(product.category.uppercased())  "
        categoryBadge.backgroundColor = primaryColor.withAlphaComponent(0.2)
        categoryBadge.textColor = primaryColor
        categoryBadge.font = .systemFont(ofSize: 10, weight: .semibold)
        

        
        // Rating display
        let rating = product.rating
        ratingLabel.text = String(format: "%.1f", rating)
        
        // Stock status - semibold for emphasis like reference design
        stockLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        if product.stock > 0 {
            if product.stock <= 5 {
                stockLabel.text = "Only \(product.stock) left"
                stockLabel.textColor = .systemOrange
            } else {
                stockLabel.text = "In Stock"
                stockLabel.textColor = .systemGreen
            }
        } else {
            stockLabel.text = "Out of Stock"
            stockLabel.textColor = .systemRed
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
