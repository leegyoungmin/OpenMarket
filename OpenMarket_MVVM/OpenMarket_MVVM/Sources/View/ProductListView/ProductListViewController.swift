//
//  ProductionListViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
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
    
    weak var coordinator: AppCoordinator?
    
    // MARK: Data Properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
    private var subscribers = Set<AnyCancellable>()
    private let viewModel = ProductListViewModel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCollectionView.delegate = self
        configureUI()
        dataSource = configureDataSource()
        bind()
    }
}

// MARK: - CollectionView Delegate
extension ProductListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let itemCount = dataSource?.snapshot().numberOfItems(inSection: 0),
           (itemCount - 1) == indexPath.row {
            viewModel.fetchProducts()
        }
    }
}

// MARK: Binding Method
private extension ProductListViewController {
    func bind() {
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink {
                self.setSnapshot(with: $0)
            }
            .store(in: &subscribers)
        
        viewModel.$collectionCase
            .sink {
                if $0 == .grid {
                    self.changeCollectionViewLayout()
                } else {
                    self.dataSource = self.configureDataSource()
                }
            }
            .store(in: &subscribers)
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
        return UICollectionViewDiffableDataSource<Int, Product>(
            collectionView: listCollectionView
        ) { (colletionView, indexPath, item) in
            return colletionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
        }
    }
    
    func configureListCellRegistration() -> UICollectionView.CellRegistration<ProductListCell, Product> {
        return UICollectionView.CellRegistration<ProductListCell, Product> { cell, indexPath, item in
            cell.update(with: item)
        }
    }
    
    func changeCollectionViewLayout() {
        listCollectionView.collectionViewLayout = configureGridLayout()
        
        let registration = UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, item in
            cell.update(with: item)
        }
        
        self.dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: listCollectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        })
    }
    
    func configureGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let spacing = CGFloat(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
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
        guard let image = navigationItem.leftBarButtonItem?.image else { return }
        viewModel.toggleCollectionCase()
        if image == UIImage(systemName: "list.bullet") {
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "square.grid.2x2")
        } else {
            navigationItem.leftBarButtonItem?.image = UIImage(systemName: "list.bullet")
        }
    }
}
