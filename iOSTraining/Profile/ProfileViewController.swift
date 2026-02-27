//
//  ProfileViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
//

import UIKit

class ProfileViewController: UIViewController {

    // 1. Data for our profile rows
    private let profileActions = ["Edit Profile", "Change Password", "Privacy Settings", "My Posts"]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "profileCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupHeader()
        setupTableView()
    }

    private func setupHeader() {
        // Create a simple header view programmatically
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        
        // Profile Image Circle
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .systemGray5
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .systemGray2
        profileImageView.layer.cornerRadius = 50
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Name Label
        let nameLabel = UILabel()
        nameLabel.text = "Shane Gamboa"
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(profileImageView)
        headerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12)
        ])
        
        tableView.tableHeaderView = headerView
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TableView Logic
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileActions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
        
        let action = profileActions[indexPath.row]
        cell.textLabel?.text = action
        cell.accessoryType = .disclosureIndicator
        
        // Add icons using SF Symbols
        if action == "Edit Profile" {
            cell.imageView?.image = UIImage(systemName: "pencil")
        } else if action == "Change Password" {
            cell.imageView?.image = UIImage(systemName: "lock.fill")
        } else if action == "Privacy Settings" {
            cell.imageView?.image = UIImage(systemName: "shield.lefthalf.filled")
        } else {
            cell.imageView?.image = UIImage(systemName: "square.and.pencil")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedAction = profileActions[indexPath.row]
        print("Profile Action: \(selectedAction) clicked!")
        
        // Custom logic for each click
        switch selectedAction {
        case "Edit Profile":
            showEditModal()
        case "Change Password":
            showSimpleAlert(title: "Security", message: "Password reset link sent to email.")
        default:
            showSimpleAlert(title: selectedAction, message: "This feature is coming soon!")
        }
    }
    
    // Helper for quick alerts
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showEditModal() {
        let editVC = UIViewController()
        editVC.view.backgroundColor = .systemBackground
        editVC.title = "Edit Profile"
        
        let nav = UINavigationController(rootViewController: editVC)
        // This adds a "Close" button to the modal
        editVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))
        
        present(nav, animated: true)
    }

    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}
