//
//  SettingsViewController.swift
//  iOSTraining
//
//  Created by Shane Gamboa - INTERN on 2/27/26.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        setupLogoutButton()
    }

    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        logoutButton.backgroundColor = .systemRed
        logoutButton.layer.cornerRadius = 12
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func didTapLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        sceneDelegate.showLoginScreen(animated: true)
    }
}
