//
//  ProductionListViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.
        

import UIKit

class ProductListViewController: UIViewController {
    // MARK: View Properties
    private var listCollectionView: UICollectionView = {
        let layoutConfigure = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfigure)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: Data Properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        dataSource = configureDataSource()
        setSnapshot(with: Product.mockData())
    }
}

// MARK: Data Method
private extension ProductListViewController {
    func setSnapshot(with datas: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
        snapshot.appendSections([0])
        snapshot.appendItems(datas, toSection: 0)
        dataSource?.apply(snapshot)
    }
}

// MARK: Configure CollectionView Layout
private extension ProductListViewController {
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Product> {
        let registration = configureListCellRegistration()
        return UICollectionViewDiffableDataSource<Int, Product>(collectionView: listCollectionView) { (colletionView, indexPath, item) in
            return colletionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
    
    func configureListCellRegistration() -> UICollectionView.CellRegistration<ProductListCell, Product> {
        return UICollectionView.CellRegistration<ProductListCell, Product> { cell, indexPath, item in
            cell.update(with: item)
        }
    }
}

// MARK: Configure UI
private extension ProductListViewController {
    func configureUI() {
        configureNavigationBar()
        addSubComponents()
        setUpConstraints()
    }
    
    func addSubComponents() {
        [listCollectionView].forEach(view.addSubview)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNavigationBar() {
        let toggleViewStyle = UIAction(handler: handleViewStyle)
        let viewShapeChangeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.grid.2x2"),
            primaryAction: toggleViewStyle
        )
        navigationItem.setLeftBarButton(viewShapeChangeButton, animated: true)
    }
    
    func handleViewStyle(_ action: UIAction) {
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "list.bullet")
    }
}
