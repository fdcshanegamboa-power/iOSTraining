//
//  ProductListViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/25/26.
//

import UIKit

class ProductListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "ProductListTableViewCell"
    var products: [Product] = [
        Product(
            image: "wirelessheadphones",
            name: "Wireless Headphones",
            price: 2499.00,
            description: "Premium noise-cancelling wireless headphones with superior sound quality",
            isFeatured: true,
            category: "Electronics"
        ),
        Product(
            image: "smartwatch",
            name: "Smart Watch",
            price: 8999.00,
            description: "Fitness tracker with heart rate monitor and GPS",
            isFeatured: false,
            category: "Wearable"
        ),
        Product(
            image: "laptopstand",
            name: "Laptop Stand",
            price: 1299.00,
            description: "Ergonomic aluminum laptop stand for better posture",
            isFeatured: true,
            category: "Accessories"
        ),
            Product(
            image: "usbchub",
            name: "USB-C Hub",
            price: 1899.00,
            description: "7-in-1 multiport adapter with HDMI and SD card reader",
            isFeatured: false,
            category: "Electronics"
        ),
        Product(
            image: "mechanicalkeyboard",
            name: "Mechanical Keyboard",
            price: 3499.00,
            description: "RGB backlit gaming keyboard with blue switches",
            isFeatured: true,
            category: "Gaming"
        ),
        Product(
            image: "wirelessmouse",
            name: "Wireless Mouse",
            price: 1199.00,
            description: "Ergonomic wireless mouse with precision tracking",
            isFeatured: false,
            category: "Accessories"
        ),
        Product(
            image: "phonecase",
            name: "Phone Case",
            price: 599.00,
            description: "Shockproof protective case with magnetic ring",
            isFeatured: false,
            category: "Accessories"
        ),
    ]
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
        
    }
    
    @objc func didTapSort() {
        print(#function)
    }
    
}
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ProductListTableViewCell {
                cell.product = products[indexPath.row]
                return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You Tapped product at index \(indexPath.row)")
        
        let selectedProduct = products[indexPath.row]
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = selectedProduct
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
    
    
}
