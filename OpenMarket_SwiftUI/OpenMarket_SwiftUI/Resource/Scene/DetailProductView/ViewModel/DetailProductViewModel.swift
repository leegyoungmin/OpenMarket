//
//  DetailProductViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class DetailProductViewModel: ObservableObject {
  private let product: Product
  @Published var detailProduct: DetailProduct
  
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
      .assertNoFailure()
      .assign(to: \.detailProduct, on: self)
      .store(in: &cancellables)
  }
  
  // TODO: - 수정/삭제 메서드 구현
  func modifyItem() {
    print("modify Item")
  }
  
  func removeItem() {
    print("Remove item")
  }
}