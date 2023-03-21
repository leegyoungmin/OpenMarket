//
//  SceneDelegate.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let productListViewController = ProductListViewController()
        window?.rootViewController = UINavigationController(rootViewController: productListViewController)
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }
}

