//
//  RecommendListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class HomeSceneViewModel: ObservableObject {
  private let marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  @Published var newFeatures = [Product]()
  @Published var recommends = [Product]()
  
  init(marketRepository: MarketProductRepository) {
    self.marketRepository = marketRepository
    
    fetchNewFeatures()
    fetchRecommendProducts()
  }
  
  func fetchNewFeatures() {
    marketRepository.loadProducts(with: 1, itemCount: 10)
      .map(\.items)
      .replaceError(with: [])
      .assign(to: &_newFeatures.projectedValue)
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
}
