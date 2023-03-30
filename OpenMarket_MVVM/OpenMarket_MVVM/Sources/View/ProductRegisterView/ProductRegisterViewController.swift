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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ImageItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        setInitSnapshot()
        addSnapshot(with: ImageItem(), to: 0)
    }
}

extension ProductRegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        var configure = PHPickerConfiguration()
        configure.filter = .images
        configure.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configure)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ProductRegisterViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let item = results.first?.itemProvider
        
        picker.dismiss(animated: true)
        
        if let item = item, item.canLoadObject(ofClass: UIImage.self) {
            item.loadObject(ofClass: UIImage.self) { image, error in
                guard let image = image as? UIImage,
                      let data = image.pngData() else { return }
                DispatchQueue.main.async {
                    self.insertItem(with: ImageItem(data: data))
                }
            }
        }
    }
}

private extension ProductRegisterViewController {
    func setInitSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageItem>()
        snapshot.appendSections([0])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func addSnapshot(with items: [ImageItem], to section: Int) {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot)
    }
    
    func insertItem(with item: ImageItem) {
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        
        guard var snapshot = dataSource?.snapshot(),
              let firstItem = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        if selectedIndex >= 4 {
            selectedIndex = 4
            snapshot.reloadItems(<#T##identifiers: [ImageItem]##[ImageItem]#>)
        }
        
        
        snapshot.insertItems([item], beforeItem: firstItem)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
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
        addChildComponents()
        makeConstraints()
    }
    
    func addChildComponents() {
        [imageRegisterCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageRegisterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageRegisterCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageRegisterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageRegisterCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
