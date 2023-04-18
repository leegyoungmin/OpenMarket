//
//  ProductResponse.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct ProductsResponse: Codable {
  let pageNumber: Int
  let pageItemCount: Int
  let itemCount: Int
  let offset: Int
  let limit: Int
  let lastPage: Int
  let hasNext: Bool
  let hasPrev: Bool
  let items: [Product]
  
  enum CodingKeys: String, CodingKey {
    case pageNumber = "pageNo"
    case pageItemCount = "itemsPerPage"
    case itemCount = "totalCount"
    case items = "pages"
    case offset, limit, lastPage, hasNext, hasPrev
  }
}

enum Currency: String, Codable, CaseIterable {
  case KRW
  case USD
  
  var intValue: Int {
    switch self {
    case .KRW:
      return 0
    case .USD:
      return 1
    }
  }
  
  init?(intValue: Int) {
    switch intValue {
    case 0:
      self = .KRW
    case 1:
      self = .USD
    default:
      return nil
    }
  }
}

struct Product: Codable, Hashable {
  var itemId = UUID()
  let id: Int
  let vendorId: Int
  let vendorName: String
  let name: String
  let description: String
  let thumbnail: String
  let currency: Currency
  let price: Double
  let bargainPrice: Double
  let discountedPrice: Double
  let stock: Int
  let createdDate: String
  let issuedDate: String
  
  var priceDescription: String {
    return price.convertCurrencyValue(with: currency.rawValue)
  }
  
  var bargainPriceDescription: String {
    return bargainPrice.convertCurrencyValue(with: currency.rawValue)
  }
  
  var isDiscounted: Bool {
    return !(discountedPrice == 0)
  }
  
  var isSoldOut: Bool {
    return stock == 0
  }
  
  enum CodingKeys: String, CodingKey {
    case id, vendorName, name, description, thumbnail, currency, price, stock
    case vendorId = "vendor_id"
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case createdDate = "created_at"
    case issuedDate = "issued_at"
  }
  
  static let mockData: Product = Product(id: 1, vendorId: 1, vendorName: "미니", name: "Mac Book Pro", description: "맥북 프로 판매합니다.", thumbnail: "", currency: .KRW, price: 10000, bargainPrice: 5000, discountedPrice: 5000, stock: 10, createdDate: "", issuedDate: "")
}
