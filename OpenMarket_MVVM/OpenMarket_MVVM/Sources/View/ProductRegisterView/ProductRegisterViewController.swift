//
//  ProductRegisterViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit
import PhotosUI

final class ProductRegisterViewController: UIViewController, UIPickerViewDelegate {
    struct ImageItem: Hashable {
        let id = UUID()
        var data: Data? = nil
    }
    
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
        return priceTextField
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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>?
    private var targetIndex: Int = 0
    private var imageQueue = CircularQueue<Data>(count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        setSnapshot(with: [ImageItem()])
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.targetIndex = indexPath.row
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
    func setImageData(with data: Data) {
        imageQueue.enqueue(data, with: self.targetIndex)
        var images = imageQueue.flatten().map(ImageItem.init)
        if images.count < 5 {
            images.append(ImageItem())
        }
        
        setSnapshot(with: images)
    }
    
    func setSnapshot(with items: [ImageItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func addSnapshot(with items: [ImageItem], to section: Int) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.reloadItems(items)
        dataSource?.apply(snapshot)
    }
    
    func addSnapshot(with item: ImageItem, to section: Int) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems([item], toSection: section)
        dataSource?.apply(snapshot)
    }
}

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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
    
    func configureGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalWidth(0.4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    func configureSection(with group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return section
    }
    
    func configureLayout() -> UICollectionViewLayout {
        let item = configureItem()
        let group = configureGroup(with: item)
        let section = configureSection(with: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

private extension ProductRegisterViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        addChildComponents()
        makeConstraints()
    }
    
    func addChildComponents() {
        [imageRegisterCollectionView, nameTextField, priceTextField, bargainPriceTextField, stockTextField, descriptionTextView].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageRegisterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageRegisterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageRegisterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageRegisterCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            nameTextField.leadingAnchor.constraint(equalTo: imageRegisterCollectionView.leadingAnchor, constant: 12),
            nameTextField.topAnchor.constraint(equalTo: imageRegisterCollectionView.bottomAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: imageRegisterCollectionView.trailingAnchor, constant: -12),
            
            priceTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            priceTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            priceTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            bargainPriceTextField.leadingAnchor.constraint(equalTo: priceTextField.leadingAnchor),
            bargainPriceTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 12),
            bargainPriceTextField.trailingAnchor.constraint(equalTo: priceTextField.trailingAnchor),
            
            stockTextField.leadingAnchor.constraint(equalTo: bargainPriceTextField.leadingAnchor),
            stockTextField.topAnchor.constraint(equalTo: bargainPriceTextField.bottomAnchor, constant: 12),
            stockTextField.trailingAnchor.constraint(equalTo: bargainPriceTextField.trailingAnchor),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: stockTextField.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: stockTextField.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

private struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController: UIViewController
    
    init(controller: UIViewController) {
        self.viewController = controller
    }
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) { }
}

struct ProductRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable(
            controller: ProductRegisterViewController()
        )
    }
}
#endif
