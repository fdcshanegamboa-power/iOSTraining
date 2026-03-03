//
//  ProductListViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit
import Foundation

class ProductListViewController: UIViewController {
    
    
    @IBOutlet weak var productSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "ProductListTableViewCell"
    
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        
        setupTableView()
        setupNetworkManager()
        fetchProducts()
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        productSearchBar.delegate = self
    }
    
    private func setupNetworkManager() {
        NetworkManager.shared.delegate = self
    }
    
    private func fetchProducts() {
        NetworkManager.shared.fetchProducts()
    }
    
    @IBAction func didTapSort(_ sender: UIButton) {
        let menu = UIMenu(title: "Sort Products", children: [
            UIAction(title: "Name (A-Z)", image: UIImage(systemName: "textformat.abc")) { _ in
                self.sortProducts(by: .nameAscending)
            },
            UIAction(title: "Name (Z-A)", image: UIImage(systemName: "textformat.abc")) { _ in
                self.sortProducts(by: .nameDescending)
            },
            UIAction(title: "Price (Low to High)", image: UIImage(systemName: "arrow.up")) { _ in
                self.sortProducts(by: .priceLowToHigh)
            },
            UIAction(title: "Price (High to Low)", image: UIImage(systemName: "arrow.down")) { _ in
                self.sortProducts(by: .priceHighToLow)
            }
        ])
        
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    enum SortOption {
        case nameAscending, nameDescending
        case priceLowToHigh, priceHighToLow
    }
    
    private func sortProducts(by option: SortOption) {
        let dataToSort = isSearching ? filteredProducts : products
        
        let sorted = dataToSort.sorted { p1, p2 in
            switch option {
            case .nameAscending:    return p1.title < p2.title
            case .nameDescending:   return p1.title > p2.title
            case .priceLowToHigh:   return p1.price < p2.price
            case .priceHighToLow:   return p1.price > p2.price
            }
        }
        
        if isSearching {
            filteredProducts = sorted
        } else {
            products = sorted
            filteredProducts = sorted
        }
        
        tableView.reloadData()
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
}

extension ProductListViewController: ProductFetchDelegate {
    
    func didFetchProducts(_ products: [Product]) {
        self.products = products
        self.filteredProducts = products
        tableView.reloadData()
    }
    
    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchProducts()
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell else {
            return UITableViewCell()
        }
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        cell.product = product
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = selectedProduct
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let product = isSearching
            ? filteredProducts[indexPath.row]
            : products[indexPath.row]

        let addToCart = UIContextualAction(
            style: .normal,
            title: "Add"
        ) { _, _, completion in
            CartManager.shared.add(product: product)
            self.showAddedToCartFeedback()
            completion(true)
        }

        addToCart.backgroundColor = .systemGreen
        addToCart.image = UIImage(systemName: "cart.badge.plus")

        return UISwipeActionsConfiguration(actions: [addToCart])
    }
}

extension ProductListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredProducts = products
        } else {
            isSearching = true
            filteredProducts = products.filter { product in
                product.title.lowercased().contains(searchText.lowercased()) ||
                product.description.lowercased().contains(searchText.lowercased()) ||
                product.category.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        productSearchBar.text = ""
        productSearchBar.resignFirstResponder()
        filteredProducts = products
        tableView.reloadData()
    }
}
