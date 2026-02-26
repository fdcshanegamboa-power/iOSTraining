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
    
    var productDetailIdentifier = "ProductCollectionViewCell"
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product?.name
        let nib = UINib(nibName: productDetailIdentifier, bundle: nil)
        productDetailCollectionView.register(nib, forCellWithReuseIdentifier: productDetailIdentifier)
        
        productDetailCollectionView.dataSource = self
        productDetailCollectionView.delegate = self
        productDetailCollectionView.layer.cornerRadius = 16
        
        configureBadge(categoryLabel)
        configureBadge(isFeaturedLabel)
        setupNavigationBar()
        displayProductDetails()
        animateContent()
        productDescriptionTextView.textContainerInset = .zero
        productDescriptionTextView.textContainer.lineFragmentPadding = 0
        
    }
    
    private func setupNavigationBar() {
        self.title = product?.name
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureBadge(_ label: UILabel){
        label.layer.cornerRadius = 12
        
    }
    private func displayProductDetails(){
        guard let product = product else { return }
        
        productNameLabel.text = product.name
        productPriceLabel.text = product.price.formatted(.currency(code: "PHP"))
        productDescriptionTextView.text = product.description ?? "NO description available"
        
        if product.isFeatured {
            isFeaturedLabel.isHidden = false
        } else {
            isFeaturedLabel.isHidden = true
        }
        
        if let category = product.category {
            categoryLabel.isHidden = false
            categoryLabel.text = "\(category.uppercased())"
        } else {
            categoryLabel.isHidden = true
        }
    }
    
    private func animateContent() {
        // Initial state
        productDetailCollectionView.alpha = 0
        productDetailCollectionView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        productNameLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        productNameLabel.alpha = 0
        productPriceLabel.transform = CGAffineTransform(translationX: 0, y: 30)
        productPriceLabel.alpha = 0
        productDescriptionTextView.alpha = 0
        
        // Animate collection view
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.productDetailCollectionView.alpha = 1
            self.productDetailCollectionView.transform = .identity
        }
        
        // Animate product name
        UIView.animate(withDuration: 0.6, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.productNameLabel.transform = .identity
            self.productNameLabel.alpha = 1
        }
        
        // Animate price
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.productPriceLabel.transform = .identity
            self.productPriceLabel.alpha = 1
        }
        
        // Animate description
        UIView.animate(withDuration: 0.5, delay: 0.4) {
            self.productDescriptionTextView.alpha = 1
        }
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productDetailIdentifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: product?.image)
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
    
}
