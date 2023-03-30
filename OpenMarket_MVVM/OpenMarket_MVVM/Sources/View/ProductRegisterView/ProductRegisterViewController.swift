//
//  ProductRegisterViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductRegisterViewController: UIViewController {
    private let imageRegisterCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: .init()
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        imageRegisterCollectionView.collectionViewLayout = configureLayout()
        configureDataSource()
        
        let items = Array(1...100)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        dataSource?.apply(snapshot, animatingDifferences: false)
        
        var itemSnapshot = NSDiffableDataSourceSectionSnapshot<Int>()
        itemSnapshot.append(items)
        dataSource?.apply(itemSnapshot, to: 0)
    }
}

private extension ProductRegisterViewController {
    func configureDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewCell, Int> { cell, indexPath, item in
            
            var content = UIListContentConfiguration.valueCell()
            content.image = UIImage(named: "exampleImage")
            content.imageProperties.cornerRadius = 10
            content.directionalLayoutMargins = .zero
            content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.cornerRadius = 10
            cell.backgroundConfiguration = background
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(
            collectionView: imageRegisterCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
    }
    func configureLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
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
