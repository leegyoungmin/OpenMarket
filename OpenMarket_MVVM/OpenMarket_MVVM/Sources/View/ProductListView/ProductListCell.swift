//
//  ProductListCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class ProductListCell: UICollectionViewCell, ProductListCollectionViewCell {
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var viewModel: ProductCellViewModel?
    
    // MARK: - View Properties
    let thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
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
    
    func update(with product: Product) {
        self.viewModel = ProductCellViewModel(product: product)
        
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImage.image = nil
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
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            thumbnailImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            thumbnailImage.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            thumbnailImage.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.8),
            
            priceLabel.topAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: remainStockLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            remainStockLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            remainStockLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: remainStockLabel.leadingAnchor, constant: -5)
        ])
    }
}
