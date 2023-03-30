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
    private let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "상품명"
        nameTextField.borderStyle = .roundedRect
        return nameTextField
    }()
    private let priceTextField: UITextField = {
        let priceTextField = UITextField()
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.placeholder = "상품 가격"
        priceTextField.keyboardType = .numberPad
        priceTextField.borderStyle = .roundedRect
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return priceTextField
    }()
    private let currencySegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.selectedSegmentIndex = 0
        control.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return control
    }()
    private let bargainPriceTextField: UITextField = {
        let bargainTextField = UITextField()
        bargainTextField.translatesAutoresizingMaskIntoConstraints = false
        bargainTextField.placeholder = "할인 금액"
        bargainTextField.keyboardType = .numberPad
        bargainTextField.borderStyle = .roundedRect
        return bargainTextField
    }()
    private let stockTextField: UITextField = {
        let stockTextField = UITextField()
        stockTextField.translatesAutoresizingMaskIntoConstraints = false
        stockTextField.placeholder = "재고 수량"
        stockTextField.keyboardType = .numberPad
        stockTextField.borderStyle = .roundedRect
        return stockTextField
    }()
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // Properties
    private let viewModel = ProductRegisterViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>?
    private var cancellables = Set<AnyCancellable>()
    
    // LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        bind()
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
    func bind() {
        viewModel.$imageItemDatas
            .sink { [weak self] items in
                self?.setSnapshot(with: items)
            }
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
        [priceTextField, currencySegmentControl].forEach(priceStackView.addArrangedSubview)
        [nameTextField, priceStackView, bargainPriceTextField, stockTextField].forEach(totalStackView.addArrangedSubview)
        [imageRegisterCollectionView, totalStackView, descriptionTextView].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageRegisterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageRegisterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageRegisterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageRegisterCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            totalStackView.leadingAnchor.constraint(equalTo: imageRegisterCollectionView.leadingAnchor, constant: 12),
            totalStackView.topAnchor.constraint(equalTo: imageRegisterCollectionView.bottomAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: imageRegisterCollectionView.trailingAnchor, constant: -12),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNavigationBar() {
        navigationItem.title = "상품 등록"
    }
}
