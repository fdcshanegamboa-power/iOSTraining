//
//  ProductDetailViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productDetailCollectionView: UICollectionView!
    @IBOutlet weak var isFeaturedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    
    var productDetailIdentifier = "ProductCollectionViewCell"
    var product: Product?
    
//    weak var delegate: ProductListViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupPageControl()
        setupNavigationBar()
        
        setupLabels()
        displayProductDetails()
        animateContent()
        
        productDescriptionTextView.textContainerInset = .zero
        productDescriptionTextView.textContainer.lineFragmentPadding = 0
        
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDescription))
//        productDescriptionTextView.isUserInteractionEnabled = true
//        productDescriptionTextView.addGestureRecognizer(tapGesture)
    }
    
//    @objc func didTapDescription(){
//        delegate?.userHasTriggeredSomething()
//    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: productDetailIdentifier, bundle: nil)
        productDetailCollectionView.register(nib, forCellWithReuseIdentifier: productDetailIdentifier)
        productDetailCollectionView.dataSource = self
        productDetailCollectionView.delegate = self
        productDetailCollectionView.isPagingEnabled = true
        productDetailCollectionView.layer.cornerRadius = 16
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        productDetailCollectionView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func didTapImage() {
        guard let imageURL = product?.images[pageControl.currentPage] else { return }
        let imageViewerVC = ImageViewerViewController(imageURL: imageURL)
        imageViewerVC.modalPresentationStyle = .overFullScreen
        imageViewerVC.modalTransitionStyle = .crossDissolve
        present(imageViewerVC, animated: true)
    }
    
    private func setupPageControl() {
        let imageCount = product?.images.count ?? 0
        pageControl.numberOfPages = imageCount
        pageControl.currentPage = 0
        pageControl.hidesForSinglePage = true
        pageControl.isHidden = imageCount <= 1
        pageControl.backgroundStyle = .minimal
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setupNavigationBar() {
        self.title = product?.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureBadge(_ label: UILabel, backgroundColor: UIColor) {
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.backgroundColor = backgroundColor
        label.textColor = .white
        label.textAlignment = .center
    }
    
    private func getCategoryColor(for category: String) -> UIColor {
        switch category.lowercased() {
        case "beauty":          return UIColor(red: 0.95, green: 0.41, blue: 0.64, alpha: 1.0)
        case "fragrances":      return UIColor(red: 0.55, green: 0.27, blue: 0.67, alpha: 1.0)
        case "skin-care":       return UIColor(red: 0.99, green: 0.73, blue: 0.55, alpha: 1.0)
        case "smartphones":     return UIColor(red: 0.0,  green: 0.48, blue: 1.0,  alpha: 1.0)
        case "laptops":         return UIColor(red: 0.10, green: 0.37, blue: 0.80, alpha: 1.0)
        case "tablets":         return UIColor(red: 0.20, green: 0.55, blue: 0.90, alpha: 1.0)
        case "mobile-accessories": return UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1.0)
        case "womens-dresses":  return UIColor(red: 0.91, green: 0.30, blue: 0.50, alpha: 1.0)
        case "womens-shoes":    return UIColor(red: 0.85, green: 0.20, blue: 0.40, alpha: 1.0)
        case "womens-bags":     return UIColor(red: 0.75, green: 0.22, blue: 0.55, alpha: 1.0)
        case "womens-jewellery": return UIColor(red: 0.80, green: 0.60, blue: 0.20, alpha: 1.0)
        case "womens-watches":  return UIColor(red: 0.70, green: 0.45, blue: 0.20, alpha: 1.0)
        case "sunglasses":      return UIColor(red: 0.40, green: 0.20, blue: 0.10, alpha: 1.0)
        case "tops":            return UIColor(red: 0.60, green: 0.30, blue: 0.60, alpha: 1.0)
        case "mens-shirts":     return UIColor(red: 0.13, green: 0.55, blue: 0.45, alpha: 1.0)
        case "mens-shoes":      return UIColor(red: 0.25, green: 0.45, blue: 0.35, alpha: 1.0)
        case "mens-watches":    return UIColor(red: 0.20, green: 0.30, blue: 0.50, alpha: 1.0)
        case "furniture":       return UIColor(red: 0.60, green: 0.40, blue: 0.20, alpha: 1.0)
        case "home-decoration": return UIColor(red: 1.0,  green: 0.27, blue: 0.23, alpha: 1.0)
        case "kitchen-accessories": return UIColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1.0)
        case "groceries":       return UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1.0)
        case "vehicle":         return UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1.0)
        case "motorcycle":      return UIColor(red: 0.50, green: 0.20, blue: 0.10, alpha: 1.0)
        case "sports-accessories": return UIColor(red: 0.0, green: 0.65, blue: 0.45, alpha: 1.0)
        default:                return UIColor.systemGray
        }
    }
    
    private func displayProductDetails() {
        guard let product = product else { return }
        
        // Always hidden
        isFeaturedLabel.isHidden = true
        
        // Name
        productNameLabel.text = product.title
        
        // Brand
        brandLabel.text = product.brand ?? "Unknown Brand"
        
        // Price
        productPriceLabel.text = product.price.formatted(.currency(code: "PHP"))
        
        // Rating
        ratingLabel.text = "⭐ \(String(format: "%.1f", product.rating)) rating"
        
        // Stock — turns red if below 10
        stockLabel.text = "📦 \(product.stock) in stock"
        stockLabel.textColor = product.stock < 10 ? .systemRed : .secondaryLabel
        
        // Discount badge
        let discount = product.discountPercentage
        if discount > 0 {
            discountLabel.isHidden = false
            discountLabel.text = "   -\(String(format: "%.0f", discount))%   "
            configureBadge(discountLabel, backgroundColor: UIColor(red: 0.85, green: 0.15, blue: 0.15, alpha: 1.0))
        } else {
            discountLabel.isHidden = true
        }
        
        // Category badge
        categoryLabel.isHidden = false
        categoryLabel.text = product.category.uppercased()
        configureBadge(categoryLabel, backgroundColor: getCategoryColor(for: product.category))
        
        // Description
        productDescriptionTextView.text = product.description
    }
    
    private func animateContent() {
        // Initial state
        productDetailCollectionView.alpha = 0
        productDetailCollectionView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        productNameLabel.alpha = 0
        productNameLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        brandLabel.alpha = 0
        productPriceLabel.alpha = 0
        productPriceLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        ratingLabel.alpha = 0
        stockLabel.alpha = 0
        discountLabel.alpha = 0
        productDescriptionTextView.alpha = 0
        
        // Collection view
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.productDetailCollectionView.alpha = 1
            self.productDetailCollectionView.transform = .identity
        }
        
        // Name
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.productNameLabel.transform = .identity
            self.productNameLabel.alpha = 1
        }
        
        // Brand
        UIView.animate(withDuration: 0.4, delay: 0.25) {
            self.brandLabel.alpha = 1
        }
        
        // Price + Discount
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.productPriceLabel.transform = .identity
            self.productPriceLabel.alpha = 1
            self.discountLabel.alpha = 1
        }
        
        // Rating + Stock
        UIView.animate(withDuration: 0.4, delay: 0.35) {
            self.ratingLabel.alpha = 1
            self.stockLabel.alpha = 1
        }
        
        // Description
        UIView.animate(withDuration: 0.5, delay: 0.4) {
            self.productDescriptionTextView.alpha = 1
        }
    }
    
    private func setupLabels() {
        // Brand
        brandLabel.font = .systemFont(ofSize: 13, weight: .regular)
        brandLabel.textColor = .secondaryLabel
        
        // Rating
        ratingLabel.font = .systemFont(ofSize: 13, weight: .medium)
        ratingLabel.textColor = .secondaryLabel
        
        // Stock
        stockLabel.font = .systemFont(ofSize: 13, weight: .medium)
        stockLabel.textColor = .secondaryLabel // may be overridden to .systemRed in displayProductDetails
        
        // Discount badge
        discountLabel.font = .systemFont(ofSize: 11, weight: .bold)
        
        // Category badge
        categoryLabel.font = .systemFont(ofSize: 11, weight: .bold)
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.images.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productDetailIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let imageURL = product?.images[indexPath.row]
        cell.configure(with: imageURL)
        return cell
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
