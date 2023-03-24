//
//  ProductListCellViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class ProductListCellViewModel {
    @Published private(set) var product: Product
    
    init(product: Product) {
        self.product = product
    }
}
