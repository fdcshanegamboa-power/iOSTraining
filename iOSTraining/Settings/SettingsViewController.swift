import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Data
    private let settingsOptions = ["Profile", "Notifications", "Privacy", "Help & Support"]

    // MARK: - UI
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Settings"
        setupTableView()
        setupLogoutButton()
    }

    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }

    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
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

    // MARK: - Logout
    @objc private func didTapLogout() {
        let alert = UIAlertController(
            title: "Log Out",
            message: "Are you sure you want to log out?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        present(alert, animated: true)
    }

    private func performLogout() {
        // 1. Clear the stored session
        SigninViewController.clearSession()

        // 2. Tell SceneDelegate to show the login screen
        guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        sceneDelegate.showLoginScreen(animated: true)
    }
}

// MARK: - TableView
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingsOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingsOptions[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selected = settingsOptions[indexPath.row]

        if selected == "Profile" {
            showProfileModal()
        } else {
            showAlert(for: selected)
        }
    }

    private func showAlert(for setting: String) {
        let alert = UIAlertController(
            title: setting,
            message: "You clicked on the \(setting) section.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func showProfileModal() {
        let profileVC = UIViewController()
        profileVC.view.backgroundColor = .systemBlue
        profileVC.title = "Profile Detail"

        let nav = UINavigationController(rootViewController: profileVC)
        present(nav, animated: true)
    }
}
