//
//  ProductListCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

extension UIConfigurationStateCustomKey {
    static let product = UIConfigurationStateCustomKey("Product")
}

extension UIConfigurationState {
    var productData: Product? {
        get { return self[.product] as? Product }
        set { self[.product] = newValue }
    }
}

final class ProductListCell: UICollectionViewListCell {
    private var productData: Product?
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.productData = self.productData
        return state
    }
    private func defaultProductConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    private lazy var listContentView = UIListContentView(configuration: defaultProductConfiguration())
    
    func update(with newProduct: Product) {
        guard productData?.id != newProduct.id else { return }
        
        productData = newProduct
        setNeedsUpdateConfiguration()
    }
}

extension ProductListCell {
    func setUpViewsIfNeeded() {
        [listContentView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setUpViewsIfNeeded()
        
        var content = defaultProductConfiguration().updated(for: state)
        
        content.image = UIImage(systemName: "person.circle")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        
        content.text = state.productData?.name
        content.textProperties.font = .preferredFont(forTextStyle: .title2)
        
        content.secondaryText = state.productData?.vendorName
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .headline)
        
        listContentView.configuration = content
    }
}
