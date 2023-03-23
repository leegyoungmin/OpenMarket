//
//  APIService.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

protocol ProductListServicing {
    var productsListRepository: ProductListLoadable { get }
    func loadProducts() -> AnyPublisher<[Product], Error>
}

final class ProductListService: ProductListServicing {
    private var pageNumber: Int = 1
    private var elementCount: Int = 10
    
    private(set) var productsListRepository: ProductListLoadable
    
    init(productsListRepository: ProductListLoadable) {
        self.productsListRepository = productsListRepository
    }
    
    func loadProducts() -> AnyPublisher<[Product], Error> {
        return productsListRepository
            .fetchData(pageNumber: pageNumber, count: elementCount, type: ProductsResponse.self)
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
