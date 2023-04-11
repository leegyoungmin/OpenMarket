//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
  private let marketWebRepository: MarketProductRepository
  private var page: Int = 1
  private var itemCount: Int = 10
  private var cancellables = Set<AnyCancellable>()
  
  @Published var products: [Product] = []
  
  init(marketWebRepository: MarketProductRepository = MarketProductConcreteRepository()) {
    self.marketWebRepository = marketWebRepository
    fetchProducts()
  }
  
  func fetchProducts() {
    marketWebRepository.loadProducts(with: page, itemCount: 10)
      .receive(on: DispatchQueue.main)
      .assign(to: \.products, on: self)
      .store(in: &cancellables)
  }
}
