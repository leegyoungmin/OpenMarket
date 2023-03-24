//
//  ProductListCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductListCell: UICollectionViewCell, ProductListCollectionViewCell {
    // MARK: - View Properties
    let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let remainStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension ProductListCell {
    func configureUI() {
        addChildComponents()
        makeConstraints()
    }
    
    func addChildComponents() {
        [
            thumbnailImage,
            titleLabel,
            priceLabel,
            remainStockLabel
        ].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            thumbnailImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            thumbnailImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            thumbnailImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 80),
            
            priceLabel.topAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: remainStockLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
            
            remainStockLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            remainStockLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            remainStockLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: remainStockLabel.leadingAnchor, constant: -5)
        ])
    }
}
