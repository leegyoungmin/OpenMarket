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
  @Published var detailProduct: DetailProduct?
  
  // MARK: Routing
  @Published private(set) var isPresentPhotoPicker: Bool = false
  @Published var alertState: AlertState? = nil
  @Published var viewStyle: ViewStyle = .create
  private(set) var successUpload = PassthroughSubject<Bool, Never>()

  // MARK: Properties
  private var marketRepository: MarketProductRepository
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: Initializer
  init(marketRepository: MarketProductRepository = MarketProductConcreteRepository()) {
    self.marketRepository = marketRepository
  }
  
  convenience init(with detailProduct: DetailProduct) {
    self.init()
    self.viewStyle = .modify
    
    self.name = detailProduct.name
    self.selectedCurrency = detailProduct.currency
    self.price = detailProduct.price.description
    if detailProduct.discountedPrice != 0 {
      self.discountedPrice = detailProduct.discountedPrice.description
    }
    self.stock = detailProduct.stock.description
    self.description = detailProduct.description
    self.detailProduct = detailProduct
    
    detailProduct.imagesInformation.forEach { information in
      guard let url = URL(string: information.thumbnailURL) else { return }
      URLSession.shared.dataTaskPublisher(for: url)
        .receive(on: DispatchQueue.main)
        .map(\.data)
        .sink(receiveCompletion: { _ in return }) { data in
          self.images.append(data)
        }
        .store(in: &cancellables)
    }
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
  
  func modifyProduct() {
    if validation() == false { return }
    
    let productRequest = ModifyDetailProductRequest(
      name: self.name,
      description: self.description,
      thumbnailId: self.detailProduct?.imagesInformation.first?.id ?? 0,
      price: Double(self.price) ?? 0.0,
      currency: self.selectedCurrency,
      discountedPrice: Double(self.discountedPrice) ?? 0.0,
      stock: Int(self.stock) ?? 0,
      secret: "mgf4rzxzpe4gkpf5"
    )
    
    marketRepository.modifyProduct(to: self.detailProduct?.id.description ?? "", modifyRequest: productRequest)
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
  enum ViewStyle {
    case create
    case modify
  }
  
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
