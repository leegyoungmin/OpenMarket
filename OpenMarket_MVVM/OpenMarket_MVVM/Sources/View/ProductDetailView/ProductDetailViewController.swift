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
    
    private let pageCollectionView: ProductThumbnailCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = ProductThumbnailCollectionView(layout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            ProductDetailImageCell.self,
            forCellWithReuseIdentifier: ProductDetailImageCell.identifier
        )
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
    
    private let informationView: ProductDetailInformationView = {
        let view = ProductDetailInformationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
        
        [pageCollectionView, pageControl, informationView].forEach {
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
            
            informationView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            informationView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            informationView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            informationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
