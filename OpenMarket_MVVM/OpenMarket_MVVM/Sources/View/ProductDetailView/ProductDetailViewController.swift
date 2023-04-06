//
//  ProductDetailViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductDetailViewController: UIViewController {
    private let pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProductDetailImageCell.self,
            forCellWithReuseIdentifier: ProductDetailImageCell.identifier
        )
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.hidesForSinglePage = false
        control.numberOfPages = 5
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = .black
        control.currentPageIndicatorTintColor = .red
        control.layer.backgroundColor = UIColor.systemGroupedBackground.cgColor
        control.layer.cornerRadius = 10
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageCollectionView.delegate = self
        pageCollectionView.dataSource = self
        configureUI()
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return .zero
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = page
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductDetailImageCell.identifier,
            for: indexPath
        )
        
        guard let cell = cell as? ProductDetailImageCell else {
            return UICollectionViewCell()
        }
        cell.setImage(with: UIImage(systemName: "person.circle") ?? UIImage())
        return cell
    }
}

private extension ProductDetailViewController {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [pageCollectionView, pageControl].forEach {
            view.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            pageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5),
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: pageCollectionView.bottomAnchor, constant: 12),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

class ProductDetailImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    func setImage(with image: UIImage) {
        self.imageView.image = image
    }
}

private extension ProductDetailImageCell {
    static let identifier = String(describing: ProductDetailImageCell.self.self)
    
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [imageView].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
