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
        let url = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(count)")!
        
        return productsListRepository
            .fetchData(with: url, type: ProductsResponse.self)
            .map(\.items)
            .eraseToAnyPublisher()
    }
}
