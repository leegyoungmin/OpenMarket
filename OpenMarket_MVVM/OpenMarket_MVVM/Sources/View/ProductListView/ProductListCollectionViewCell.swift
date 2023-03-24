//
//  ProductListCollectionViewCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

protocol ProductListCollectionViewCell: UICollectionViewCell {
    var thumbnailImage: UIImageView { get }
    var titleLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var remainStockLabel: UILabel { get }
    
    func update(with product: Product)
}

extension ProductListCollectionViewCell {
    func update(with product: Product) {
        self.thumbnailImage.image = UIImage(systemName: "person.circle")
        self.titleLabel.text = product.name
        self.priceLabel.text = product.bargainPrice.description
        self.remainStockLabel.text = product.stock.description
    }
}
