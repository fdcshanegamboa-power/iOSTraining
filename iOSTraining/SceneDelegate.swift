//
//  SceneDelegate.swift
//  iOSTraining
//
//  Created by FDC.Eyan-NC-SA-IOS on 2/24/26.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func showLoginScreen(animated: Bool) {
        let loginVC = SigninViewController(nibName: "SigninViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: loginVC)
        nav.setNavigationBarHidden(true, animated: false)

        guard let window = window else { return }
        window.rootViewController = nav

        if animated {
            UIView.transition(with: window,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
    
    func showMainScreen(animated: Bool = false) {
        let tabBarController = makeTabBarController()
        setRootViewController(tabBarController, animated: animated)
    }
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        

        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if isLoggedIn == true {
            let tabBarController = makeTabBarController()
            setRootViewController(tabBarController, animated: true)
        }else {
            showLoginScreen(animated: false)

        }
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
private extension SceneDelegate {
    func makeTabBarController() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            makeProductsTab(),
            makeCartTab(),
            makeProfileTab(),
            makeSettingsTab()
        ]
        
        // Primary color from your design
        let primaryColor = UIColor(red: 0.97, green: 0.74, blue: 0.24, alpha: 1.0) // #f8bc3c
        tabBar.tabBar.tintColor = primaryColor
        tabBar.tabBar.unselectedItemTintColor = primaryColor.withAlphaComponent(0.4)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            // Selected state
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: primaryColor
            ]
            appearance.stackedLayoutAppearance.selected.iconColor = primaryColor
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            // Normal state
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: primaryColor.withAlphaComponent(0.4)
            ]
            appearance.stackedLayoutAppearance.normal.iconColor = primaryColor.withAlphaComponent(0.4)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            tabBar.tabBar.standardAppearance = appearance
            tabBar.tabBar.scrollEdgeAppearance = appearance
        }

        return tabBar
    }

    func makeProductsTab() -> UINavigationController {
        // XIB-based VC — use nibName
        let vc = ProductListViewController(
            nibName: String(describing: ProductListViewController.self),
            bundle: nil
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Products",
            image: UIImage(systemName: "bag"),
            selectedImage: UIImage(systemName: "bag.fill")
        )
        return nav
    }

    func makeCartTab() -> UINavigationController {
        // SwiftUI-based view wrapped in UIHostingController
        let vc = UIHostingController(rootView: CartView())
        vc.title = "My Cart"
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            selectedImage: UIImage(systemName: "cart.fill")
        )
        return nav
    }

    func makeSettingsTab() -> UINavigationController {
        // Code-based VC — init directly, no nibName
        let vc = SettingsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        return nav
    }

    func makeProfileTab() -> UINavigationController {
        // XIB-based VC — use nibName
        let vc = ProfileViewController(
            nibName: String(describing: ProfileViewController.self),
            bundle: nil
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        return nav
    }
}

// MARK: - Root VC Transition
private extension SceneDelegate {
    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window else { return }

        window.rootViewController = viewController
        window.makeKeyAndVisible()

        guard animated else { return }

        UIView.transition(
            with: window,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
