//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel {
    private var pageNumber = 1
    @Published private(set) var products: [Product] = []
    
    private let apiService: ProductListServicing
    private var subscribers = Set<AnyCancellable>()
    
    init(apiService: ProductListServicing = ProductListService(productsListRepository: ProductListRepository())) {
        self.apiService = apiService
        fetchProducts()
    }
    
    func fetchProducts() {
        apiService.loadProducts()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { self.products = $0 }
            .store(in: &subscribers)

    }
}
