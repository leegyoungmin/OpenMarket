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
    
    func configureListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Product> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Product> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            content.textProperties.font = .preferredFont(forTextStyle: .title1)
            content.secondaryText = item.vendorName
            content.secondaryTextProperties.font = .preferredFont(forTextStyle: .headline)
            content.image = UIImage(systemName: "person.circle")
            content.imageProperties.reservedLayoutSize = CGSize(width: 50, height: 50)
            content.textProperties.color = .label
            cell.contentConfiguration = content
        }
    }
}

// MARK: Configure UI
private extension ProductListViewController {
    func configureUI() {
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
}
