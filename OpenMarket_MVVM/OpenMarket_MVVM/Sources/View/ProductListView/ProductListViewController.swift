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
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        dataSource = configureDataSource()
        setSnapshot(with: Array(1...100))
    }
}

// MARK: Data Method
private extension ProductListViewController {
    func setSnapshot(with datas: [Int]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(datas, toSection: 0)
        dataSource?.apply(snapshot)
    }
}

// MARK: Configure CollectionView Layout
private extension ProductListViewController {
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Int> {
        let registration = configureListCellRegistration()
        return UICollectionViewDiffableDataSource<Int, Int>(collectionView: listCollectionView) { (colletionView, indexPath, item) in
            return colletionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
    
    func configureListCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Int> {
        return UICollectionView.CellRegistration<UICollectionViewListCell, Int> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = indexPath.description
            content.textProperties.font = .preferredFont(forTextStyle: .title1)
            content.secondaryText = "Example"
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
