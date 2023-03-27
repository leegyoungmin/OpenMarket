//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel: ObservableObject {
    enum CollectionViewCase {
        case list
        case gridTwoColumn
        case gridThreeColumn
    }
    
    private var pageNumber: Int = 1
    private var elementCount: Int = 30
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var collectionCase: CollectionViewCase = .list
    
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
    
    func toggleCollectionCase() {
        switch collectionCase {
        case .list:
            collectionCase = .gridTwoColumn
        case .gridTwoColumn:
            collectionCase = .gridThreeColumn
        case .gridThreeColumn:
            collectionCase = .list
        }
        
        self.products = products
    }
}
