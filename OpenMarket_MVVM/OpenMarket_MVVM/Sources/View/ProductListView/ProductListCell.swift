//
//  ProductListCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductListCell: UICollectionViewCell {
    // MARK: - View Properties
    private let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
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
    
    func updateViewModel(with product: Product) {
        self.thumbnailImage.image = UIImage(systemName: "person.circle")
        self.titleLabel.text = product.name
        self.priceLabel.text = product.bargainPrice.description
        self.remainStockLabel.text = product.stock.description
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
            thumbnailImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            thumbnailImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -5),
            thumbnailImage.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
            
            remainStockLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            remainStockLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: remainStockLabel.leadingAnchor)
        ])
    }
}
