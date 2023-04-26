//
//  ProductListCoordinator.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class ProductRegisterCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let registerViewController = ProductRegisterViewController()
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    func popRegisterViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func didFinishRegister() {
        parentCoordinator?.childDidFinish(self)
    }
}
