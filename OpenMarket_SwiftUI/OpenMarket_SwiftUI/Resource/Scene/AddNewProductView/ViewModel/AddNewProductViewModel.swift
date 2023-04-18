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
  @Published var alertState: AlertState? = nil
  private(set) var successUpload = PassthroughSubject<Bool, Never>()

  // MARK: Properties
  private var marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Initializer
  init(marketRepository: MarketProductRepository = MarketProductConcreteRepository()) {
    self.marketRepository = marketRepository
  }
  
  func uploadProduct() {
    if validation() == false { return }
    
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

// MARK: Alert State
extension AddNewProductViewModel {
  enum AlertState: CustomStringConvertible {
    case emptyImage
    case invalidName
    case invalidPrice
    case invalidStock
    case shortDescription
    
    var description: String {
      switch self {
      case .emptyImage:
        return "적어도 한개의 이미지를 업로드 해야 합니다."
        
      case .invalidName:
        return "상대방에게 보여질 상품명을 입력해주세요."
        
      case .invalidPrice:
        return "상품의 가격 정보가 잘못되었습니다."
        
      case .invalidStock:
        return "상품은 적어도 한개 이상의 상품을 준비해야 합니다."
        
      case .shortDescription:
        return "상대방이 더 자세한 상품의 정보를 얻을 수 있게 상품 설명을 적어주세요."
      }
    }
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
  
  func validation() -> Bool {
    if images.isEmpty {
      alertState = .emptyImage
      return false
    }
    
    if name.isEmpty {
      alertState = .invalidName
      return false
    }
    
    guard let price = Double(price) else {
      alertState = .invalidPrice
      return false
    }
    
    if price <= 0 || price < Double(discountedPrice) ?? 0 {
      alertState = .invalidPrice
      return false
    }
    guard let stock = Int(stock) else {
      alertState = .invalidStock
      return false
    }
    
    if stock <= 0 {
      alertState = .invalidStock
      return false
    }
    
    if description.count < 10 {
      alertState = .shortDescription
      return false
    }
    
    return true
  }
}
