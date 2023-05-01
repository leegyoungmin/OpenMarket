//
//  SearchViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class SearchViewModel: ObservableObject {
  @Published var searchQuery: String = ""
  @Published var searchedProducts: [Product] = []
  
  private let marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  init(marketRepository: MarketProductRepository) {
    self.marketRepository = marketRepository
  }
  
  func search(with query: String) {
    guard query.isEmpty == false else { return }
    
    marketRepository.searchProducts(with: query)
      .receive(on: DispatchQueue.main)
      .map(\.items)
      .replaceError(with: [])
      .assign(to: \.searchedProducts, on: self)
      .store(in: &cancellables)
  }
}
