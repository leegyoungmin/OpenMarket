//
//  ProductDetailCoordinator.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

class ProductDetailCoordinator: Coordinator {
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators: [Coordinator] = []
    
    private let productId: Int
    private var navigationController: UINavigationController
    
    init(id: Int, navigationController: UINavigationController) {
        self.productId = id
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ProductDetailViewModel(id: productId)
        let itemViewController = ProductDetailViewController(viewModel: viewModel)
        itemViewController.coordinator = self
        navigationController.pushViewController(itemViewController, animated: true)
    }
    
    func popDetailViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func didFinishDetail() {
        parentCoordinator?.childDidFinish(self)
    }
}
