//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    // Properties
    let marketWebRepository: MarketProductRepository
    private var page: Int = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    var canLoadNextPage: Bool = true {
        willSet {
            if newValue {
                page += 1
            }
        }
    }
    @Published var products: [Product] = []
    
    // Initializer
    init(marketWebRepository: MarketProductRepository = MarketProductConcreteRepository()) {
        self.marketWebRepository = marketWebRepository
    }
    
    func fetchProducts() {
        if canLoadNextPage == false {
            return
        }
        
        marketWebRepository.loadProducts(with: page)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: onReceiveCompletion,
                receiveValue: onReceive
            )
            .store(in: &cancellables)
    }
    
    func reloadProducts() {
        products = []
        
        for page in 1...page {
            marketWebRepository.loadProducts(with: page)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: onReceiveCompletion, receiveValue: onReloadReceive)
                .store(in: &cancellables)
        }
    }
}

private extension ProductListViewModel {
    func onReceiveCompletion(with completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            debugPrint(error)
            canLoadNextPage = false
            
        case .finished:
            break
        }
    }
    
    func onReceive(with response: ProductsResponse) {
        self.canLoadNextPage = (response.items.count == 10)
        self.products += response.items
    }
    
    func onReloadReceive(with response: ProductsResponse) {
        self.products += response.items
    }
}
