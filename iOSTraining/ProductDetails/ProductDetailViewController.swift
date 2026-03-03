//
//  ProductDetailViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//  Redesigned v3 — #f8bc3c primary, fixed pills, programmatic bottom bar.
//

import UIKit

class ProductDetailViewController: UIViewController {

    // MARK: - IBOutlets
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

    // NOTE: addToCartButton and bottomBarView are no longer wired from the XIB.
    // They are created and laid out entirely in code below so they always sit
    // above the tab bar regardless of device / safe-area size.
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var bottomBarView: UIView!

    // MARK: - Programmatic Bottom Bar Views
    private let bottomBar    = UIView()
    private let cartButton   = UIButton(type: .system)
    private let buyNowButton = UIButton(type: .system)

    // MARK: - Theme
    private let primaryColor = UIColor(red: 0.973, green: 0.737, blue: 0.235, alpha: 1.0)
    private let nearBlack    = UIColor(red: 0.1,   green: 0.1,   blue: 0.1,   alpha: 1.0)
    private let bgColor      = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1.0)

    // MARK: - Data
    var productDetailIdentifier = "ProductCollectionViewCell"
    var product: Product?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor

        setupNavigationBar()
        setupCollectionView()
        setupPageControl()
        setupProgrammaticBottomBar()
        setupScrollViewInset()
        setupLabels()
        displayProductDetails()
        animateContent()

        productDescriptionTextView.textContainerInset = .zero
        productDescriptionTextView.textContainer.lineFragmentPadding = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundCardPanel()
        updateScrollViewInset()
    }

    // MARK: - Navigation Bar

    private func setupNavigationBar() {
        title = product?.title ?? "Details"
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = primaryColor
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: nearBlack,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance   = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance    = appearance
        navigationController?.navigationBar.tintColor = nearBlack
    }

    // MARK: - Collection View

    private func setupCollectionView() {
        let nib = UINib(nibName: productDetailIdentifier, bundle: nil)
        productDetailCollectionView.register(nib, forCellWithReuseIdentifier: productDetailIdentifier)
        productDetailCollectionView.dataSource  = self
        productDetailCollectionView.delegate    = self
        productDetailCollectionView.isPagingEnabled = true
        productDetailCollectionView.clipsToBounds   = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        productDetailCollectionView.addGestureRecognizer(tap)
    }

    @objc private func didTapImage() {
        guard let imageURL = product?.images[pageControl.currentPage] else { return }
        let vc = ImageViewerViewController(imageURL: imageURL)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle   = .crossDissolve
        present(vc, animated: true)
    }

    // MARK: - Page Control

    private func setupPageControl() {
        let count = product?.images.count ?? 0
        pageControl.numberOfPages                 = count
        pageControl.currentPage                   = 0
        pageControl.hidesForSinglePage            = true
        pageControl.isHidden                      = count <= 1
        pageControl.backgroundStyle               = .minimal
        pageControl.isUserInteractionEnabled      = false
        pageControl.pageIndicatorTintColor        = UIColor.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = primaryColor
    }

    private func setupProgrammaticBottomBar() {
        bottomBarView?.isHidden = true

        bottomBar.backgroundColor = .systemGroupedBackground
        bottomBar.translatesAutoresizingMaskIntoConstraints = false

        bottomBar.layer.shadowColor   = UIColor.black.cgColor
        bottomBar.layer.shadowOpacity = 0.08
        bottomBar.layer.shadowRadius  = 12
        bottomBar.layer.shadowOffset  = CGSize(width: 0, height: -4)
        bottomBar.clipsToBounds       = false


        cartButton.setTitle("Add to Cart", for: .normal)
        cartButton.titleLabel?.font   = .systemFont(ofSize: 16, weight: .bold)
        cartButton.setTitleColor(primaryColor, for: .normal)
        cartButton.backgroundColor    = .clear
        cartButton.layer.cornerRadius = 14
        cartButton.layer.borderWidth  = 2
        cartButton.layer.borderColor  = primaryColor.cgColor
        cartButton.clipsToBounds      = true
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.addTarget(self, action: #selector(didTapAddToCart(_:)), for: .touchUpInside)

        buyNowButton.setTitle("Buy Now", for: .normal)
        buyNowButton.titleLabel?.font   = .systemFont(ofSize: 16, weight: .bold)
        buyNowButton.setTitleColor(nearBlack, for: .normal)
        buyNowButton.backgroundColor    = primaryColor
        buyNowButton.layer.cornerRadius = 14
        buyNowButton.clipsToBounds      = true
        buyNowButton.translatesAutoresizingMaskIntoConstraints = false
        buyNowButton.addTarget(self, action: #selector(didTapBuyNow(_:)), for: .touchUpInside)

        view.addSubview(bottomBar)
        bottomBar.addSubview(cartButton)
        bottomBar.addSubview(buyNowButton)

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            cartButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 16),
            cartButton.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 16),
            cartButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -16),
            cartButton.heightAnchor.constraint(equalToConstant: 52),

            buyNowButton.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 16),
            buyNowButton.leadingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 10),
            buyNowButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            buyNowButton.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -16),
            buyNowButton.heightAnchor.constraint(equalToConstant: 52),

            buyNowButton.widthAnchor.constraint(equalTo: cartButton.widthAnchor, multiplier: 1.1),
        ])
    }
    
    private func setupScrollViewInset() {
        guard let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return }
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    private func updateScrollViewInset() {
        guard let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView else { return }
        let barHeight = bottomBar.frame.height == 0
            ? (52 + 32 + view.safeAreaInsets.bottom)
            : bottomBar.frame.height
        scrollView.contentInset.bottom        = barHeight
        scrollView.verticalScrollIndicatorInsets.bottom = barHeight
    }

    private func roundCardPanel() {
        guard
            let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView,
            let contentView = scrollView.subviews.first,
            let cardPanel = contentView.subviews.first(where: {
                !($0 is UICollectionView) && !($0 is UIPageControl)
            })
        else { return }

        cardPanel.layer.cornerRadius  = 24
        cardPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardPanel.layer.masksToBounds = true
    }


    private func applyPillBadge(_ label: UILabel, tint: UIColor) {
        label.layer.cornerRadius = 8
        label.clipsToBounds      = true
        label.textAlignment      = .center
    }

    private func applySolidBadge(_ label: UILabel, bg: UIColor, fg: UIColor) {
        label.layer.cornerRadius = 8
        label.clipsToBounds      = true
        label.backgroundColor    = bg
        label.textColor          = fg
        label.textAlignment      = .center
    }

    // MARK: - Category Color

    private func categoryColor(for category: String) -> UIColor {
        switch category.lowercased() {
        case "beauty":               return UIColor(red: 0.95, green: 0.41, blue: 0.64, alpha: 1)
        case "fragrances":           return UIColor(red: 0.55, green: 0.27, blue: 0.67, alpha: 1)
        case "skin-care":            return UIColor(red: 0.99, green: 0.60, blue: 0.30, alpha: 1)
        case "smartphones":          return UIColor(red: 0.0,  green: 0.48, blue: 1.0,  alpha: 1)
        case "laptops":              return UIColor(red: 0.10, green: 0.37, blue: 0.80, alpha: 1)
        case "tablets":              return UIColor(red: 0.20, green: 0.55, blue: 0.90, alpha: 1)
        case "mobile-accessories":   return UIColor(red: 0.35, green: 0.34, blue: 0.84, alpha: 1)
        case "womens-dresses":       return UIColor(red: 0.91, green: 0.30, blue: 0.50, alpha: 1)
        case "womens-shoes":         return UIColor(red: 0.85, green: 0.20, blue: 0.40, alpha: 1)
        case "womens-bags":          return UIColor(red: 0.75, green: 0.22, blue: 0.55, alpha: 1)
        case "womens-jewellery":     return UIColor(red: 0.80, green: 0.60, blue: 0.20, alpha: 1)
        case "womens-watches":       return UIColor(red: 0.70, green: 0.45, blue: 0.20, alpha: 1)
        case "sunglasses":           return UIColor(red: 0.40, green: 0.20, blue: 0.10, alpha: 1)
        case "tops":                 return UIColor(red: 0.60, green: 0.30, blue: 0.60, alpha: 1)
        case "mens-shirts":          return UIColor(red: 0.13, green: 0.55, blue: 0.45, alpha: 1)
        case "mens-shoes":           return UIColor(red: 0.25, green: 0.45, blue: 0.35, alpha: 1)
        case "mens-watches":         return UIColor(red: 0.20, green: 0.30, blue: 0.50, alpha: 1)
        case "furniture":            return UIColor(red: 0.60, green: 0.40, blue: 0.20, alpha: 1)
        case "home-decoration":      return UIColor(red: 1.0,  green: 0.27, blue: 0.23, alpha: 1)
        case "kitchen-accessories":  return UIColor(red: 0.95, green: 0.55, blue: 0.10, alpha: 1)
        case "groceries":            return UIColor(red: 0.20, green: 0.78, blue: 0.35, alpha: 1)
        case "vehicle":              return UIColor(red: 0.30, green: 0.30, blue: 0.30, alpha: 1)
        case "motorcycle":           return UIColor(red: 0.50, green: 0.20, blue: 0.10, alpha: 1)
        case "sports-accessories":   return UIColor(red: 0.0,  green: 0.65, blue: 0.45, alpha: 1)
        default:                     return primaryColor
        }
    }

    // MARK: - Display

    private func displayProductDetails() {
        guard let product = product else { return }

        isFeaturedLabel.isHidden = true

        productNameLabel.text  = product.title
        brandLabel.text        = product.brand ?? "Unknown Brand"
        productPriceLabel.text = product.price.formatted(.currency(code: "USD").locale(Locale(identifier: "en_US")))

        ratingLabel.text = "  \(String(format: "%.1f", product.rating))  rating "
        applyPillBadge(ratingLabel, tint: UIColor(red: 1.0, green: 0.75, blue: 0.0, alpha: 1))

        stockLabel.text = "  \(product.stock) in stock "
        if product.stock < 10 {
            applyPillBadge(stockLabel, tint: .systemRed)
        } else {
            applyPillBadge(stockLabel, tint: UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1))
        }

        let discount = product.discountPercentage
        if discount > 0 {
            discountLabel.isHidden = false
            discountLabel.text = "  -\(String(format: "%.0f", discount))%  "
            applySolidBadge(discountLabel, bg: primaryColor, fg: nearBlack)
        } else {
            discountLabel.isHidden = true
        }

        let catTint = categoryColor(for: product.category)
        categoryLabel.isHidden = false
        categoryLabel.text = "  \(product.category.uppercased())  "
        applyPillBadge(categoryLabel, tint: catTint)

        productDescriptionTextView.text = product.description
    }


    private func setupLabels() {
        productNameLabel.font  = .systemFont(ofSize: 24, weight: .bold)
        productNameLabel.textColor = nearBlack

        brandLabel.font      = .systemFont(ofSize: 14, weight: .regular)
        brandLabel.textColor = .secondaryLabel

        productPriceLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        productPriceLabel.textColor = nearBlack

        ratingLabel.font   = .systemFont(ofSize: 12, weight: .semibold)
        stockLabel.font    = .systemFont(ofSize: 12, weight: .semibold)
        discountLabel.font = .systemFont(ofSize: 11, weight: .bold)
        categoryLabel.font = .systemFont(ofSize: 11, weight: .semibold)
    }


    private func animateContent() {
        let views: [UIView] = [
            productDetailCollectionView, categoryLabel, productNameLabel,
            brandLabel, productPriceLabel, discountLabel,
            ratingLabel, stockLabel, productDescriptionTextView
        ]
        views.forEach { $0.alpha = 0 }
        productDetailCollectionView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        productNameLabel.transform            = CGAffineTransform(translationX: 0, y: 20)
        productPriceLabel.transform           = CGAffineTransform(translationX: 0, y: 16)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5) {
            self.productDetailCollectionView.alpha     = 1
            self.productDetailCollectionView.transform = .identity
        }
        UIView.animate(withDuration: 0.55, delay: 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.categoryLabel.alpha        = 1
            self.productNameLabel.alpha     = 1
            self.productNameLabel.transform = .identity
        }
        UIView.animate(withDuration: 0.4, delay: 0.22) { self.brandLabel.alpha = 1 }
        UIView.animate(withDuration: 0.55, delay: 0.28, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) {
            self.productPriceLabel.alpha     = 1
            self.productPriceLabel.transform = .identity
            self.discountLabel.alpha         = 1
        }
        UIView.animate(withDuration: 0.4, delay: 0.34) {
            self.ratingLabel.alpha = 1
            self.stockLabel.alpha  = 1
        }
        UIView.animate(withDuration: 0.5, delay: 0.4) {
            self.productDescriptionTextView.alpha = 1
        }
    }


    @IBAction func didTapAddToCart(_ sender: UIButton) {
        animateButtonTap(sender)
        print("Add to cart: \(product?.title ?? "")")
        
        performAddToCart()
    }
    private func performAddToCart() {
        guard let product = self.product else { return }
        CartManager.shared.add(product: product)
        self.showAddedToCartFeedback()
    }
    
    
    private func showAddedToCartFeedback() {
        let alert = UIAlertController(
            title: "Added to Cart",
            message: nil,
            preferredStyle: .alert
        )

        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            alert.dismiss(animated: true)
        }
    }

    @IBAction func didTapBuyNow(_ sender: UIButton) {
        animateButtonTap(sender)
        print("Buy now: \(product?.title ?? "")")
    }

    private func animateButtonTap(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
        }) { _ in
            UIView.animate(
                withDuration: 0.15, delay: 0,
                usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8
            ) { button.transform = .identity }
        }
    }
}


private extension UIColor {
    func darkened(by amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a) else { return self }
        return UIColor(
            hue: h,
            saturation: min(s * 1.05, 1.0),
            brightness: max(b - amount, 0),
            alpha: a
        )
    }
}


extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        product?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: productDetailIdentifier, for: indexPath
        ) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: product?.images[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat { 0 }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets { .zero }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == productDetailCollectionView else { return }
        let page = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(page)
    }
}
