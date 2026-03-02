//
//  SigninViewController.swift
//  iOSTraining
//

import UIKit

class SigninViewController: UIViewController {

    // MARK: - Constants
    private enum StaticAccount {
        static let username = "123123123"
        static let password = "123123123"
    }

    private enum UserDefaultsKey {
        static let isLoggedIn    = "isLoggedIn"
        static let loggedInEmail = "loggedInEmail"
        static let lastLoginDate = "lastLoginDate"
    }

    // MARK: - Outlets
    @IBOutlet weak var emailTextfield:    UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextField(emailTextfield)
        styleTextField(passwordTextfield)
    }

    // MARK: - Styling
    private func styleTextField(_ textField: UITextField) {
        textField.layer.cornerRadius  = 12
        textField.layer.borderWidth   = 1.5
        textField.layer.borderColor   = UIColor.systemBlue.cgColor
        textField.layer.masksToBounds = true

        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: textField.frame.height))
        textField.leftView     = padding
        textField.leftViewMode = .always
    }

    // MARK: - Actions
    @IBAction func didTapLoginButton(_ sender: Any) {
        let email    = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextfield.text ?? ""

        guard validateCredentials(email: email, password: password) else {
            showAlert(title: "Login Failed",
                      message: "Invalid username or password. Please try again.")
            return
        }

        saveSession(email: email)
        navigateToMain()
    }

    // MARK: - Validation
    private func validateCredentials(email: String, password: String) -> Bool {
        return email == StaticAccount.username && password == StaticAccount.password
    }

    // MARK: - UserDefaults
    private func saveSession(email: String) {
        let defaults = UserDefaults.standard
        defaults.set(true,          forKey: UserDefaultsKey.isLoggedIn)
        defaults.set(email,         forKey: UserDefaultsKey.loggedInEmail)
        defaults.set(Date(),        forKey: UserDefaultsKey.lastLoginDate)
    }

    static func clearSession() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UserDefaultsKey.isLoggedIn)
        defaults.removeObject(forKey: UserDefaultsKey.loggedInEmail)
        defaults.removeObject(forKey: UserDefaultsKey.lastLoginDate)
    }

    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.isLoggedIn)
    }

    // MARK: - Navigation
    private func navigateToMain() {
        guard let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        sceneDelegate.showMainScreen(animated: true)
    }

    // MARK: - Helpers
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
