//
//  SceneDelegate.swift
//  Tracker
//
//  Created by mihail on 08.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func transitionWithOnboarding() {
        OnboardingStore.shared.isAuth = true
        let vc = TabBarController()
        window?.rootViewController = vc
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        let vc = TabBarController()
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let onboardingVC = OnboardingPageController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        
        onboardingVC.sceneDelegate = self
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = OnboardingStore.shared.isAuth ? vc : onboardingVC
        
        window?.makeKeyAndVisible()
    }
}
