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
    let thumbnailImage: ThumbnailImageView = {
        let imageView = ThumbnailImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 12
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.4
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title2).bold()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
    
    func update(viewType: ProductListViewModel.CollectionViewCase, with product: Product) {
        self.viewModel = ProductCellViewModel(product: product)
        
        bind()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel?.cancel()
        thumbnailImage.resetImage()
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
            thumbnailImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            thumbnailImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            thumbnailImage.widthAnchor.constraint(equalTo: thumbnailImage.heightAnchor),
            thumbnailImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            
            priceLabel.topAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: remainStockLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
            
            remainStockLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),
            remainStockLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: thumbnailImage.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: remainStockLabel.leadingAnchor, constant: -5)
        ])
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ProductListCell_Previews: PreviewProvider {
    static let product = Product.mockData().first!
    static var previews: some View {
        UIViewPreview {
            let cell = ProductListCell()
            cell.update(viewType: .list, with: product)
            return cell
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
