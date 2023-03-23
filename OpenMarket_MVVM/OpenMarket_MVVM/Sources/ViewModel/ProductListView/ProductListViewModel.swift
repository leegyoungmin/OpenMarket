//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel {
    private var pageNumber: Int = 1
    private var elementCount: Int = 30
    
    @Published private(set) var products: [Product] = []
    
    private let apiService: ProductListServicing
    private var subscribers = Set<AnyCancellable>()
    
    init(apiService: ProductListServicing = ProductListService(productsListRepository: ProductListRepository())) {
        self.apiService = apiService
        fetchProducts()
    }
    
    func fetchProducts() {
        apiService.loadProducts(pageNumber: pageNumber, count: elementCount)
            .sink { completion in
                switch completion {
                case .finished:
                    self.pageNumber += 1
                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { products in
                self.products += products
            }
            .store(in: &subscribers)
    }
}
