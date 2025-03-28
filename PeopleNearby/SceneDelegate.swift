//
//  SceneDelegate.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = ViewControllerFactory.createController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
