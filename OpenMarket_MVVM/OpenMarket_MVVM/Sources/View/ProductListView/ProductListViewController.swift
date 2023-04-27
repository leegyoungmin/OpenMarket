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
  private var cancellables = Set<AnyCancellable>()
  private let viewModel: ProductListViewModelType
  
  private var onAppear = PassthroughSubject<Void, Never>()
  
  init(viewModel: ProductListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.viewModel = ProductListViewModel(apiService: ProductListService())
    super.init(coder: coder)
  }
  
  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setCollectionView(viewType: .list)
    listCollectionView.delegate = self
    configureUI()
    bind(to: viewModel)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    onAppear.send(())
  }
}

// MARK: - CollectionView Delegate
extension ProductListViewController: UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if let itemCount = dataSource?.snapshot().numberOfItems(inSection: 0),
       (itemCount - 1) == indexPath.row {
      onAppear.send(())
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        let id = viewModel.products[indexPath.row].id
    //        coordinator?.detailSubscription(id: id)
  }
}

// MARK: Binding Method
private extension ProductListViewController {
  func bind(to viewModel: ProductListViewModelType) {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let input = ProductListViewModelInput(
      onAppear: onAppear.eraseToAnyPublisher())
    
    viewModel.transform(input: input)
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] state in render(state) }
      .store(in: &cancellables)
  }
}

// MARK: Data Method
private extension ProductListViewController {
  func render(_ state: ProductListViewModelState) {
    switch state {
    case .success(let products):
      setSnapshot(with: products)
    case .fail:
      setSnapshot(with: [])
      
    default:
      return
    }
  }
  
  func setSnapshot(with datas: [Product]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Product>()
    snapshot.appendSections([0])
    snapshot.appendItems(datas, toSection: 0)
    guard let dataSource = dataSource else { return }
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func reloadData(snapshot: NSDiffableDataSourceSnapshot<Int, Product>) {
    dataSource?.apply(snapshot)
  }
}

// MARK: Configure CollectionView Common
private extension ProductListViewController {
  func setCollectionView(viewType: ProductListViewModel.CollectionViewCase) {
    listCollectionView.collectionViewLayout = configureLayout(width: viewType.numberOfColumns)
    
    if let snapshot = dataSource?.snapshot() {
      dataSource = configureDataSource(viewType: viewType)
      reloadData(snapshot: snapshot)
      return
    }
    
    dataSource = configureDataSource(viewType: viewType)
  }
  
  func configureDataSource(
    viewType: ProductListViewModel.CollectionViewCase
  ) -> UICollectionViewDiffableDataSource<Int, Product> {
    if viewType == .list {
      return configureListDataSource()
    }
    
    return configureGridDataSource(viewType: viewType)
  }
  
  // NSCollection Item 구성 함수
  func configureItem(width: Int) -> NSCollectionLayoutItem {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(CGFloat(10 / width) / 10),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    if width == 2 {
      item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12)
      return item
    }
    
    if width == 3 {
      item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .flexible(5), top: .flexible(0), trailing: .flexible(5), bottom: .flexible(0))
      return item
    }
    
    return item
  }
  
  // NSCollection Group 구성 함수
  func configureGroup(with item: NSCollectionLayoutItem, width: Int) -> NSCollectionLayoutGroup {
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: width == 1 ? .estimated(110) : width == 2 ? .fractionalHeight(0.3) : .fractionalHeight(0.2)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    if width >= 3 {
      group.interItemSpacing = .flexible(5)
      return group
    }
    
    return group
  }
  
  // NSCollection Section 구성 함수
  func configureSection(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
    let spacing = CGFloat(10)
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = spacing
    
    return section
  }
  
  // Layout 구성 함수
  func configureLayout(width: Int) -> UICollectionViewCompositionalLayout {
    let item = configureItem(width: width)
    let group = configureGroup(with: item, width: width)
    let section = configureSection(with: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: Configure List CollectionView
private extension ProductListViewController {
  func configureListCellRegistration() -> UICollectionView.CellRegistration<ProductListCell, Product> {
    return UICollectionView.CellRegistration<ProductListCell, Product> { cell, indexPath, item in
      cell.update(viewType: .list, with: item)
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
  func configureGridCellRegistration(
    viewType: ProductListViewModel.CollectionViewCase = .list
  ) -> UICollectionView.CellRegistration<ProductGridCell, Product> {
    return UICollectionView.CellRegistration<ProductGridCell, Product> { cell, indexPath, item in
      cell.update(viewType: viewType, with: item)
    }
  }
  
  func configureGridDataSource(
    viewType: ProductListViewModel.CollectionViewCase
  ) -> UICollectionViewDiffableDataSource<Int, Product> {
    let registration = configureGridCellRegistration(viewType: viewType)
    
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
    
    let presentAction = UIAction { _ in
      self.coordinator?.registerSubscription()
    }
    let presentButton = UIBarButtonItem(
      image: UIImage(systemName: "plus.circle"),
      primaryAction: presentAction
    )
    
    navigationItem.setLeftBarButton(viewShapeChangeButton, animated: true)
    navigationItem.setRightBarButton(presentButton, animated: true)
  }
  
  func handleViewStyle(_ action: UIAction) {
//    viewModel.toggleCollectionCase()
  }
  
  func setNavigationLeadingImage(with imageName: String) {
    navigationItem.leftBarButtonItem?.image = UIImage(systemName: imageName)
  }
}
