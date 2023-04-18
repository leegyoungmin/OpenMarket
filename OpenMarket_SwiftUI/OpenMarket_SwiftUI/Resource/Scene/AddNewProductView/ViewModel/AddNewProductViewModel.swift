//
//  AddNewProductViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class AddNewProductViewModel: ObservableObject {
  // MARK: Output
  @Published var name: String = ""
  @Published var price: String = ""
  @Published var selectedCurrency: Currency = .KRW
  @Published var discountedPrice: String = ""
  @Published var stock: String = ""
  @Published var description: String = ""
  @Published var images: [Data] = []
  
  // MARK: Routing
  @Published private(set) var isPresentPhotoPicker: Bool = false
  private(set) var successUpload = PassthroughSubject<Bool, Never>()

  // MARK: Properties
  private var marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Initializer
  init(marketRepository: MarketProductRepository = MarketProductConcreteRepository()) {
    self.marketRepository = marketRepository
  }
  
  func uploadProduct() {
    let product = RequestProduct(
      name: name,
      description: description,
      price: price,
      currency: selectedCurrency.rawValue,
      discountedPrice: discountedPrice,
      stock: stock
    )
    guard let encodeData = product.encodingData() else { return }
    
    marketRepository.uploadProduct(with: encodeData, images: images)
      .sink(receiveCompletion: handleCompletion, receiveValue: { _ in })
      .store(in: &cancellables)
  }
  
  func updateImage(with data: Data) {
    if images.count == 5 { return }
    
    images.append(data)
  }
  
  func deleteImage(to index: Int) {
    images.remove(at: index)
  }
}

private extension AddNewProductViewModel {
  func handleCompletion(to completion: Subscribers.Completion<Error>) {
    switch completion {
    case .failure:
      return
      
    case .finished:
      self.successUpload.send(true)
    }
  }
}
