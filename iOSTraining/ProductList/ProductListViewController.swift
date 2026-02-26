//
//  ProductListViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var productSearchBar: UISearchBar!
    private let cellIdentifier = "ProductListTableViewCell"

    var products: [Product] = [
            Product(
                image: "wirelessheadphones",
                name: "Wireless Headphones",
                price: 2499.00,
                description: "Experience premium audio quality with these noise-cancelling wireless headphones. Featuring advanced Bluetooth 5.0 technology, 30-hour battery life, and ultra-comfortable memory foam ear cushions. Perfect for music lovers, travelers, and professionals who demand superior sound quality and all-day comfort.",
                isFeatured: true,
                category: "Electronics"
            ),
            Product(
                image: "smartwatch",
                name: "Smart Watch",
                price: 8999.00,
                description: "Stay connected and track your fitness goals with this advanced smartwatch. Features include heart rate monitoring, GPS tracking, sleep analysis, water resistance up to 50 meters, and seamless smartphone integration. With a stunning AMOLED display and 7-day battery life, it's the perfect companion for your active lifestyle.",
                isFeatured: false,
                category: "Wearable"
            ),
            Product(
                image: "laptopstand",
                name: "Laptop Stand",
                price: 1299.00,
                description: "Improve your posture and productivity with this ergonomic aluminum laptop stand. Designed with adjustable height settings and a sleek, space-saving design, it elevates your screen to eye level to reduce neck strain. Compatible with all laptop sizes from 10 to 17 inches. The sturdy construction ensures stability while the ventilated design keeps your device cool.",
                isFeatured: true,
                category: "Accessories"
            ),
            Product(
                image: "usbchub",
                name: "USB-C Hub",
                price: 1899.00,
                description: "Expand your connectivity options with this versatile 7-in-1 USB-C multiport adapter. Features HDMI 4K output, USB 3.0 ports, SD/microSD card readers, and USB-C Power Delivery charging. Compact and portable design makes it perfect for travel, while the aluminum construction ensures durability and efficient heat dissipation.",
                isFeatured: false,
                category: "Electronics"
            ),
            Product(
                image: "mechanicalkeyboard",
                name: "Mechanical Keyboard",
                price: 3499.00,
                description: "Elevate your gaming and typing experience with this premium RGB mechanical keyboard. Equipped with tactile blue switches for precise, satisfying keystrokes, customizable per-key RGB lighting, and programmable macro keys. The durable aluminum frame and braided cable ensure long-lasting performance, while anti-ghosting technology guarantees every keystroke is registered during intense gaming sessions.",
                isFeatured: true,
                category: "Gaming"
            ),
            Product(
                image: "wirelessmouse",
                name: "Wireless Mouse",
                price: 1199.00,
                description: "Navigate with precision using this ergonomic wireless mouse. Featuring a high-precision optical sensor with adjustable DPI settings, comfortable contoured design, and silent clicking technology. The rechargeable battery lasts up to 3 months on a single charge, and the 2.4GHz wireless connection ensures lag-free performance up to 10 meters away.",
                isFeatured: false,
                category: "Accessories"
            ),
            Product(
                image: "phonecase",
                name: "Phone Case",
                price: 599.00,
                description: "Protect your device with this military-grade shockproof phone case. Constructed with dual-layer protection combining a flexible TPU inner layer and hard PC outer shell, it guards against drops, scratches, and impacts. The built-in magnetic ring supports wireless charging and car mounts, while raised edges protect your screen and camera. Available in multiple colors with a slim, pocket-friendly profile.",
                isFeatured: false,
                category: "Accessories"
            ),
    ]
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        
//        let sortBarButtonItem = UIBarButtonItem(
//            title: "Sort",
//            style: .plain,
//            target: self,
//            action: #selector(didTapSort)
//        )
        
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        productSearchBar.delegate = self
        filteredProducts = products
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
            },
            UIAction(title: "Featured First", image: UIImage(systemName: "star.fill")) { _ in
                self.sortProducts(by: .featuredFirst)
            }
        ])
        
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    enum SortOption {
        case nameAscending, nameDescending
        case priceLowToHigh, priceHighToLow
        case featuredFirst
    }
    
    private func sortProducts(by option: SortOption) {
        let dataToSort = isSearching ? filteredProducts : products
            
        let sorted = dataToSort.sorted { product1, product2 in
            switch option {
            case .nameAscending:
                return product1.name < product2.name
            case .nameDescending:
                return product1.name > product2.name
            case .priceLowToHigh:
                return product1.price < product2.price
            case .priceHighToLow:
                return product1.price > product2.price
            case .featuredFirst:
                if product1.isFeatured == product2.isFeatured {
                    return product1.name < product2.name // Secondary sort by name
                }
                return product1.isFeatured && !product2.isFeatured
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
    
}
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredProducts.count : products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell {
            let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
            cell.product = product
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You Tapped product at index \(indexPath.row)")
        
        let selectedProduct = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = selectedProduct
        self.navigationController?.pushViewController(productDetailVC, animated: true)
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
                product.name.lowercased().contains(searchText.lowercased()) ||
                (product.description?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (product.category?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            
        }
        tableView.reloadData()
    }
    
    func searchBarButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        productSearchBar.text = ""
        productSearchBar.resignFirstResponder()
        filteredProducts = products
        tableView.reloadData()
    }
}
