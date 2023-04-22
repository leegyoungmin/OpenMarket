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
  @Published var shouldDismiss = false
  
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
    marketRepository.removeProduct(
      to: detailProduct.id.description,
      with: "mgf4rzxzpe4gkpf5"
    )
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: onRecieveCompletion) { detailProduct in
      self.shouldDismiss = true
    }
    .store(in: &cancellables)
  }
}

private extension DetailProductViewModel {
  func onRecieveCompletion(with completion: Subscribers.Completion<Error>) {
    switch completion {
    case .failure(let error):
      debugPrint(error)
    case .finished:
      return
    }
  }
}
