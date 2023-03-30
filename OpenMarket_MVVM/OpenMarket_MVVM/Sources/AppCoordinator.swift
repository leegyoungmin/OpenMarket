//
//  AppCoordinator.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let productsListViewController = ProductListViewController()
        productsListViewController.coordinator = self
        navigationController.pushViewController(productsListViewController, animated: false)
    }
    
    func presentRegisterController() {
        let registerController = ProductRegisterViewController()
        navigationController.pushViewController(registerController, animated: true)
    }
}
