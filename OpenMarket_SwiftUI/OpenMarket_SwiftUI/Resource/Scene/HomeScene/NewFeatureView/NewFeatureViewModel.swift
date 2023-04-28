//
//  NewFeatureViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class NewFeatureViewModel: ObservableObject {
  @Published var recentProducts = [Product]()
  
  private let marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  init(marketRepository: MarketProductRepository) {
    self.marketRepository = marketRepository
    fetchRecent()
  }
  
  func fetchRecent() {
    marketRepository.loadProducts(with: 1, itemCount: 10)
      .receive(on: DispatchQueue.main)
      .map(\.items)
      .replaceError(with: [])
      .assign(to: \.recentProducts, on: self)
      .store(in: &cancellables)
  }
}
