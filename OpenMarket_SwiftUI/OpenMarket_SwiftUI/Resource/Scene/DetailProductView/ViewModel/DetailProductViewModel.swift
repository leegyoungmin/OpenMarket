//
//  DetailProductViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class DetailProductViewModel: ObservableObject {
  private let product: Product
  @Published var detailProduct: DetailProduct {
    didSet {
      print(detailProduct)
    }
  }
  
  private let marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  init(product: Product, marketRepository: MarketProductRepository) {
    self.product = product
    self.detailProduct = DetailProduct(product: product)
    self.marketRepository = marketRepository
    
    fetchDetailProduct(to: product.id.description)
  }
  
  func fetchDetailProduct(to id: String) {
    marketRepository.loadDetailProduct(to: id)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        print(completion)
      } receiveValue: { detailProduct in
        print(detailProduct)
        self.detailProduct = detailProduct
      }
      .store(in: &cancellables)
  }
}
