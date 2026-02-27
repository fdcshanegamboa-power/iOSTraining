//
//  CartViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
//
import UIKit

class CartViewController: UIViewController {
    
    private let tableView = UITableView()
    
    // 1. Create a container for the checkout section
    private let checkoutContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Proceed to Checkout", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupCheckoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        updateTotal()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self // Added delegate for row selection
        tableView.register(
            CartTableViewCell.self,
            forCellReuseIdentifier: CartTableViewCell.reuseIdentifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Pin table to top and sides, but stop above the checkout button
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupCheckoutUI() {
        view.addSubview(checkoutContainerView)
        checkoutContainerView.addSubview(checkoutButton)
        
        checkoutButton.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Container constraints
            checkoutContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            checkoutContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Button constraints
            checkoutButton.topAnchor.constraint(equalTo: checkoutContainerView.topAnchor, constant: 16),
            checkoutButton.leadingAnchor.constraint(equalTo: checkoutContainerView.leadingAnchor, constant: 20),
            checkoutButton.trailingAnchor.constraint(equalTo: checkoutContainerView.trailingAnchor, constant: -20),
            checkoutButton.heightAnchor.constraint(equalToConstant: 56),
            // Ensure button respects safe area at the bottom (for iPhone notch/home bar)
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateTotal() {
        // You could calculate CartManager.shared.items.reduce(0) { $0 + $1.price } here
        print("Total updated: Calculating prices...")
    }

    @objc private func didTapCheckout() {
        print("💰 Checkout button tapped! Time to take their money.")
        
        let alert = UIAlertController(
            title: "Checkout",
            message: "Ready to purchase these items?",
            preferredStyle: .actionSheet // Shows a nice slide-up menu from the bottom
        )
        
        alert.addAction(UIAlertAction(title: "Confirm Purchase", style: .default, handler: { _ in
            print("Purchase Confirmed!")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - TableView Extensions
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CartTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CartTableViewCell else {
            return UITableViewCell()
        }

        let item = CartManager.shared.items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    // Swipe to delete! Every good cart needs this.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleting item at index: \(indexPath.row)")
            // CartManager.shared.items.remove(at: indexPath.row)
            // tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
