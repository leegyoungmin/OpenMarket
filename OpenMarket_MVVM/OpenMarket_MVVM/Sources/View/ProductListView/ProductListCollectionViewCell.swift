//
//  ProductListCollectionViewCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

protocol ProductListCollectionViewCell: UICollectionViewCell {
    var viewModel: ProductCellViewModel? { get }
    var thumbnailImage: ThumbnailImageView { get }
    var titleLabel: UILabel { get }
    var priceLabel: UILabel { get }
    var remainStockLabel: UILabel { get }
    
    var cancellables: Set<AnyCancellable> { get set }
    
    func update(viewType: ProductListViewModel.CollectionViewCase, with product: Product)
    func bind()
}

extension ProductListCollectionViewCell {
    func bind() {
        viewModel?.$title
            .sink { [weak self] in
                self?.titleLabel.text = $0
            }
            .store(in: &cancellables)
        
        viewModel?.$price
            .sink { [weak self] in
                self?.priceLabel.text = $0
            }
            .store(in: &cancellables)
        
        viewModel?.$stock
            .sink { [weak self] in
                self?.remainStockLabel.text = $0.description
            }
            .store(in: &cancellables)
        
        viewModel?.isOutOfStock
            .sink { [weak self] in
                if $0 {
                    self?.remainStockLabel.textColor = .red
                    self?.remainStockLabel.text = "품절"
                } else {
                    self?.remainStockLabel.textColor = .label
                }
            }
            .store(in: &cancellables)
        
        viewModel?.$imageData
            .receive(on: DispatchQueue.main)
            .replaceNil(with: Data())
            .sink {
                self.thumbnailImage.setImage(with: $0)
            }
            .store(in: &cancellables)
    }
}
