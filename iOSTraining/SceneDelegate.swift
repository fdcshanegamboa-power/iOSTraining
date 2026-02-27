//
//  SceneDelegate.swift
//  iOSTraining
//
//  Created by FDC.Eyan-NC-SA-IOS on 2/24/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func showLoginScreen(animated: Bool = false) {
        let loginViewController = SigninViewController(
            nibName: String(describing: SigninViewController.self),
            bundle: nil
        )

        setRootViewController(loginViewController, animated: animated)
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
            makeSettingsTab()
        ]
        tabBar.tabBar.tintColor = .systemBlue
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            tabBar.tabBar.standardAppearance = appearance
            tabBar.tabBar.scrollEdgeAppearance = appearance
        }
        return tabBar
    }

    func makeProductsTab() -> UINavigationController {
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

    func makeSettingsTab() -> UINavigationController {
        let vc = SettingsViewController(
            nibName: String(describing: SettingsViewController.self),
            bundle: nil
        )
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        return nav
    }
    
}


private extension SceneDelegate {
    func setRootViewController(_ viewController: UIViewController, animated: Bool) {
        guard let window else { return }

        let applyRoot = {
            let wereAnimationsEnabled = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            UIView.setAnimationsEnabled(wereAnimationsEnabled)
        }

        guard animated else {
            applyRoot()
            return
        }

        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: applyRoot
        )
    }
}
