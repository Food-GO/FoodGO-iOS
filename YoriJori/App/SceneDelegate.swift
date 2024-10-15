//
//  SceneDelegate.swift
//  YoriJori
//
//  Created by 김강현 on 7/6/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        var rootViewController: UIViewController?
        
        if UserDefaultsManager.shared.isFirstLaunched == true {
            rootViewController = OnboardingContainerViewController()
        } else {
            rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }

    // 아래 메서드들은 필요에 따라 구현하세요.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}

