//
//  RecommendListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class HomeSceneViewModel: ObservableObject {
  private let marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  @Published var recommends = [Product]()
  
  init(marketRepository: MarketProductRepository) {
    self.marketRepository = marketRepository
    
    fetchRecommendProducts()
  }
  
  func fetchRecommendProducts() {
    if recommends.isEmpty == false {
      recommends.removeAll()
    }
    
    (1...10).forEach { index in
      marketRepository.loadProducts(with: index, itemCount: 10)
        .map(\.items)
        .replaceError(with: [])
        .sink { products in
          let randomIndex = Int.random(in: 0..<10)
          self.recommends.append(products[randomIndex])
        }
        .store(in: &cancellables)
    }
  }
  
  func searchList(with query: String) {
    
  }
}
