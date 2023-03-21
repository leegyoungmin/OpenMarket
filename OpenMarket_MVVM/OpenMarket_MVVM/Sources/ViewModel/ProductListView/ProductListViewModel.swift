//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel {
    private var pageNumber = 1
    @Published var products: [Product] = []
    
    private let apiService: APIServiceProtocol
    private var subscribers = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        fetchProducts()
    }
    
    func fetchProducts() {
        apiService.loadProducts(pageNumber: pageNumber, count: 10)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { response in
                if response.hasNext {
                    self.pageNumber = (response.pageNumber + 1)
                }
                
                self.products = response.items
            }
            .store(in: &subscribers)

    }
}
