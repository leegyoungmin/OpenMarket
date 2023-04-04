//
//  ProductRegisterViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit
import PhotosUI

final class ProductRegisterViewController: UIViewController, UIPickerViewDelegate {
    typealias ImageItem = ProductRegisterViewModel.ImageItem
    
    // View Properties
    private let imageRegisterCollectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let registerInputView = ProductRegisterInputView()
    
    
    // Properties
    weak var coordinator: ProductListCoordinator?
    private let viewModel = ProductRegisterViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>?
    private var cancellables = Set<AnyCancellable>()
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        
        bindToViewModel()
        bindFromViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coordinator?.didFinishRegister()
    }
}

// MARK: - CollectionView Delegate
extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.updateSelectedIndex(with: indexPath.row)
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.allowsEditing = true
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
// MARK: - ImagePickerViewControllerDelegate
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        dismiss(animated: true)
        if let image = info[.editedImage] as? UIImage,
           let data = image.pngData() {
            setImageData(with: data)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

private extension ProductRegisterViewController {
    func bindFromViewModel() {
        let activityView = UIActivityIndicatorView()
        
        viewModel.$imageItemDatas
            .sink { [weak self] items in
                self?.setSnapshot(with: items)
            }
            .store(in: &cancellables)
        
        viewModel.uploadState
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .loading:
                    self.view.addSubview(activityView)
                    
                case .finish:
                    self.coordinator?.didFinishRegister()
                    
                case .error:
                    activityView.removeFromSuperview()
                    
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func bindToViewModel() {
        registerInputView.nameTextField.textPublisher
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)

        registerInputView.priceTextField.textPublisher
            .compactMap { Double($0) }
            .assign(to: \.price, on: viewModel)
            .store(in: &cancellables)
        
        registerInputView.currencySegmentControl
            .currencyChangedPublisher
            .assign(to: \.currency, on: viewModel)
            .store(in: &cancellables)
        
        registerInputView.stockTextField.textPublisher
            .compactMap { Int($0) }
            .assign(to: \.stock, on: viewModel)
            .store(in: &cancellables)

        registerInputView.bargainPriceTextField.textPublisher
            .compactMap { Double($0) }
            .assign(to: \.bargainPrice, on: viewModel)
            .store(in: &cancellables)

        registerInputView.descriptionTextView.textPublisher
            .compactMap { $0 }
            .assign(to: \.description, on: viewModel)
            .store(in: &cancellables)
    }
}

// MARK: - Data Method
private extension ProductRegisterViewController {
    func setImageData(with data: Data) {
        viewModel.setImageData(with: data)
    }
    
    func setSnapshot(with items: [ImageItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - CollectionView Configure Method
private extension ProductRegisterViewController {
    func configureCollectionView() {
        imageRegisterCollectionView.collectionViewLayout = configureLayout()
        imageRegisterCollectionView.delegate = self
        dataSource = configureDataSource()
    }
    
    func configureImageCellRegistration() -> UICollectionView.CellRegistration<ProductRegisterImageCell, ImageItem> {
        return UICollectionView.CellRegistration { cell, indexPath, item in
            cell.setImage(with: item.data)
        }
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Int, ImageItem> {
        let imageCellRegistration = configureImageCellRegistration()
        
        return UICollectionViewDiffableDataSource<Int, ImageItem>(
            collectionView: imageRegisterCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func configureItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    func configureGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalWidth(0.4)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    func configureSection(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let item = configureItem()
        let group = configureGroup(with: item)
        let section = configureSection(with: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Configure UI Method
private extension ProductRegisterViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        addChildComponents()
        makeConstraints()
    }
    
    func addChildComponents() {
        [imageRegisterCollectionView, registerInputView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageRegisterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageRegisterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageRegisterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageRegisterCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            registerInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registerInputView.topAnchor.constraint(equalTo: imageRegisterCollectionView.bottomAnchor),
            registerInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            registerInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureNavigationBar() {
        navigationItem.title = "상품 등록"
        
        let saveAction = UIAction { _ in
            self.viewModel.registerProduct()
        }
        
        let saveButton = UIBarButtonItem(title: "올리기", primaryAction: saveAction)
        navigationItem.rightBarButtonItem = saveButton
    }
}


