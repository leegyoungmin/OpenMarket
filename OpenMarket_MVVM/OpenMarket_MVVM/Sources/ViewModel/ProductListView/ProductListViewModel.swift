//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel {
    @Published var products: [Product] = []
    
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        fetchProducts()
    }
    
    func fetchProducts() {
        let url = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=1&items_per_page=30")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductsResponse.self, decoder: JSONDecoder())
            .map(\.items)
            .replaceError(with: [])
            .assign(to: \.products, on: self)
            .store(in: &subscribers)
    }
}
