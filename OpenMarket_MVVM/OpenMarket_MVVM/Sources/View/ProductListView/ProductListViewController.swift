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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
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
            .sink { [weak self] in
                self?.setNavigationLeadingImage(with: $0.systemImageName)
                switch $0 {
                case .list:
                    self?.setListCollectionView()
                    
                case .gridTwoColumn:
                    self?.setGridCollectionView(width: 2)
                    
                case .gridThreeColumn:
                    self?.setGridCollectionView(width: 3)
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

// MARK: Configure List CollectionView
private extension ProductListViewController {
    func setListCollectionView() {
        listCollectionView.collectionViewLayout = configureListLayout()
        dataSource = configureListDataSource()
    }
    
    func configureListLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfigure = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfigure)
        
        return layout
    }
    
    func configureListCellRegistration() -> UICollectionView.CellRegistration<ProductListCell, Product> {
        return UICollectionView.CellRegistration<ProductListCell, Product> { cell, indexPath, item in
            cell.update(with: item)
        }
    }
    
    func configureListDataSource() -> UICollectionViewDiffableDataSource<Int, Product> {
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
}

// MARK: Configure Grid CollectionView
private extension ProductListViewController {
    func setGridCollectionView(width: Int) {
        listCollectionView.collectionViewLayout = configureGridLayout(widthCount: width)
        dataSource = configureGridDataSource()
    }
    
    func configureGridLayout(widthCount: Int) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(10 / widthCount) / 10),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        if widthCount >= 3 {
            group.interItemSpacing = .flexible(10)
        }
        let spacing = CGFloat(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureGridCellRegistration() -> UICollectionView.CellRegistration<ProductGridCell, Product> {
        return UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, item in
            cell.update(with: item)
        }
    }
    
    func configureGridDataSource() -> UICollectionViewDiffableDataSource<Int, Product> {
        let registration = configureGridCellRegistration()
        return UICollectionViewDiffableDataSource(
            collectionView: listCollectionView
        ) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: item
            )
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
        viewModel.toggleCollectionCase()
    }
    
    func setNavigationLeadingImage(with imageName: String) {
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: imageName)
    }
}
