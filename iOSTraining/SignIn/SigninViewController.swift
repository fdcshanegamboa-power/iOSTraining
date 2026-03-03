//
//  SigninViewController.swift
//  iOSTraining
//

import UIKit

class SigninViewController: UIViewController {

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
        let username = emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextfield.text ?? ""
        
        
        guard !username.isEmpty, !password.isEmpty else {
            showAlert(title: "Login Failed", message: "Please enter both username and password.")
            return
        }
        
        let success = UserManager.shared.login(username: username, password: password)
        
        if success {
            navigateToMain()
        } else {
            showAlert(title: "Login Failed", message: "Invalid username or password. Please try again.")
        }
    }
    
    static func logout() {
        UserManager.shared.logout()
    }

    static func isUserLoggedIn() -> Bool {
        return UserManager.shared.isLoggedIn
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
