//
//  APIService.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

protocol ProductListServicing {
    var productsListRepository: ProductListLoadable { get }
    func loadProducts(pageNumber: Int, count: Int) -> AnyPublisher<[Product], Error>
}

final class ProductListService: ProductListServicing {
    private(set) var productsListRepository: ProductListLoadable
    
    init(productsListRepository: ProductListLoadable) {
        self.productsListRepository = productsListRepository
    }
    
    func loadProducts(pageNumber: Int, count: Int) -> AnyPublisher<[Product], Error> {
        return productsListRepository
            .fetchData(pageNumber: pageNumber, count: count, type: ProductsResponse.self)
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
