//
//  ProductDetailViewController.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductDetailViewController: UIViewController {
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.scrollIndicatorInsets = .zero
        return textView
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
        view = contentScrollView
        contentScrollView.addSubview(contentView)
        
        [pageCollectionView, pageControl, titleLabel, descriptionTextView].forEach {
            contentView.addSubview($0)
        }
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
            
            pageCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            pageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            pageControl.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: pageCollectionView.bottomAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
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
