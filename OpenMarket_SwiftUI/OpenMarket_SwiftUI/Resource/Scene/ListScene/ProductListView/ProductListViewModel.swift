//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
  // Properties
  let marketRepository: MarketProductRepository
  private var page: Int = 1
  
  private var cancellables = Set<AnyCancellable>()
  
  var canLoadNextPage: Bool = true
  @Published var products: [Product] = []
  
  // Initializer
  init(marketRepository: MarketProductRepository = MarketProductConcreteRepository()) {
    self.marketRepository = marketRepository
  }
  
  func fetchProducts(isReload: Bool = false) {
    if canLoadNextPage == false {
      return
    }
    let page = (isReload ? 1 : page)
    let itemCount = (isReload ? (10 * page) : 10)
    
    marketRepository.loadProducts(with: page, itemCount: itemCount)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: onReceiveCompletion,
        receiveValue: onReceive
      )
      .store(in: &cancellables)
  }
  
  func reloadProducts() {
    products = []
    fetchProducts(isReload: true)
  }
}

extension ProductListViewModel {
  func fetchNextPage(with lastItem: Product) {
    if lastItem.id == products.last?.id {
      fetchProducts()
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
    if response.hasNext {
      page += 1
    }
    self.canLoadNextPage = (response.items.count == 10)
    self.products += response.items
  }
}
