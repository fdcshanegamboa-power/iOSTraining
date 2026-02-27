import UIKit

class SettingsViewController: UIViewController {

    // 1. Define our settings options
    private let settingsOptions = ["Profile", "Notifications", "Privacy", "Help & Support"]
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        self.title = "Settings"
        
        setupTableView()
        setupLogoutButton()
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100) // Leave space for logout
        ])
    }

    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
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
        print("Logout button tapped!")
        // Your existing logout logic here...
    }
}

// MARK: - TableView Logic
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator // Adds that little ">" arrow
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedSetting = settingsOptions[indexPath.row]
        print("User clicked on: \(selectedSetting)")

        // Show a modal for "Profile", or just alert for others
        if selectedSetting == "Profile" {
            showProfileModal()
        } else {
            showAlert(for: selectedSetting)
        }
    }
    
    private func showAlert(for setting: String) {
        let alert = UIAlertController(title: setting, message: "You clicked on the \(setting) section.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cool", style: .default))
        present(alert, animated: true)
    }
    
    private func showProfileModal() {
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .systemBlue
        profileVC.title = "Profile Detail"
        
        // Wrap it in a Nav Controller so we get a "Done" button or header
        let nav = UINavigationController(rootViewController: profileVC)
        present(nav, animated: true)
    }
}
