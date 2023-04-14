//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    enum FetchState {
        case success
        case loading
        case endPage
    }
    
    // Properties
    private let marketWebRepository: MarketProductRepository
    private var page: Int = 1
    private var itemCount: Int = 10
    private var cancellables = Set<AnyCancellable>()
    
    @Published var state: FetchState = .success
    @Published var products: [Product] = []
    
    // Initializer
    init(marketWebRepository: MarketProductRepository = MarketProductConcreteRepository()) {
        self.marketWebRepository = marketWebRepository
        fetchProducts()
    }
    
    func fetchProducts() {
        toggleState()
        
        marketWebRepository.loadProducts(with: page, itemCount: itemCount)
            .receive(on: DispatchQueue.main)
            .assertNoFailure()
            .sink {
                self.toggleHasNextPage(with: $0.hasNext)
                self.products.append(contentsOf: $0.items)
                self.toggleState()
            }
            .store(in: &cancellables)
    }
    
    func isLastItem(with item: Product) {
        guard let lastItem = products.last else { return }
        
        let isLast = (lastItem.id == item.id)
        
        if isLast == false {
            return
        }
        
        toggleState()
    }
}

private extension ProductListViewModel {
    func toggleState() {
        switch state {
        case .loading:
            state = .success
        case .success:
            state = .loading
            
        case .endPage:
            break
        }
    }
    
    func toggleHasNextPage(with hasNext: Bool) {
        if hasNext == true {
            self.page += 1
        }
        
        if hasNext == false {
            self.state = .endPage
        }
    }
}
