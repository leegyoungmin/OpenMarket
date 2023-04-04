//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel: ObservableObject {
    private var pageNumber: Int = 1
    private var elementCount: Int = 10
    
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
    }
}

extension ProductListViewModel {
    enum CollectionViewCase {
        case list
        case gridTwoColumn
        case gridThreeColumn
    }
}

extension ProductListViewModel.CollectionViewCase {
    var systemImageName: String {
        switch self {
        case .list:
            return "square.grid.2x2"
            
        case .gridTwoColumn:
            return "square.grid.3x3"
            
        case .gridThreeColumn:
            return "list.bullet"
        }
    }
    
    var numberOfColumns: Int {
        switch self {
        case .list:
            return 1
        case .gridTwoColumn:
            return 2
        case .gridThreeColumn:
            return 3
        }
    }
}
