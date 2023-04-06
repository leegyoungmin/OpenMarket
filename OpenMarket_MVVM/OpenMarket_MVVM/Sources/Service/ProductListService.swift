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
    func loadProduct(id: Int) -> AnyPublisher<DetailProduct, Error>
    func saveProduct(params: Data, images: [Data], identifier: Data) -> AnyPublisher<Bool, Never>
}

final class ProductListService: ProductListServicing {
    private(set) var productsListRepository: ProductListLoadable
    
    init(productsListRepository: ProductListLoadable = ProductListRepository()) {
        self.productsListRepository = productsListRepository
    }
    
    func loadProducts(pageNumber: Int, count: Int) -> AnyPublisher<[Product], Error> {
        return productsListRepository
            .fetchData(pageNumber: pageNumber, count: count, type: ProductsResponse.self)
            .map(\.items)
            .eraseToAnyPublisher()
    }
    
    func loadProduct(id: Int) -> AnyPublisher<DetailProduct, Error> {
        return productsListRepository
            .fetchData(id: id, type: DetailProduct.self)
            .eraseToAnyPublisher()
    }
    
    func saveProduct(params: Data, images: [Data], identifier: Data) -> AnyPublisher<Bool, Never> {
        return productsListRepository.saveData(params: params, images: images, identifier: identifier)
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }
}
