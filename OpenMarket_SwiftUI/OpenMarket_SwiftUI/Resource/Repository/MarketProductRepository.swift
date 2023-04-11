//
//  MarketProductRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol MarketProductRepository: WebRepository {
  func loadProducts(with page: Int, itemCount: Int) -> AnyPublisher<[Product], Never>
}

final class MarketProductConcreteRepository: MarketProductRepository {
  func loadProducts(with page: Int, itemCount: Int) -> AnyPublisher<[Product], Never> {
    let endPoint = API.loadProducts(page: page, itemCount: itemCount)
    return requestNetwork(endPoint: endPoint, type: ProductsResponse.self)
      .map(\.items)
      .replaceError(with: [])
      .eraseToAnyPublisher()
  }
}

extension MarketProductConcreteRepository {
  enum API {
    case loadProducts(page: Int, itemCount: Int)
  }
}

extension MarketProductConcreteRepository.API: EndPointing {
  var baseURL: String {
    return "https://openmarket.yagom-academy.kr"
  }
  
  var path: String {
    switch self {
    case .loadProducts:
      return "/api/products"
    }
  }
  
  var method: String {
    switch self {
    case .loadProducts:
      return "GET"
    }
  }
  var headers: [String : String] {
    switch self {
    case .loadProducts:
      return [
        "Content-Type": "application/json"
      ]
    }
  }
  
  var queries: [String : String] {
    switch self {
    case .loadProducts(let page, let itemCount):
      return [
        "page_no": page.description,
        "items_per_page": itemCount.description
      ]
    }
  }
  
  var body: Data? {
    switch self {
    case .loadProducts:
      return nil
    }
  }
}
