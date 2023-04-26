//
//  ModifyDetailProductRequest.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

struct ModifyDetailProductRequest: Codable {
  let name: String
  let description: String
  let thumbnailId: Int
  let price: Double
  let currency: Currency
  let discountedPrice: Double
  let stock: Int
  let secret: String
  
  enum CodingKeys: String, CodingKey {
    case name, description, price, currency, stock, secret
    case thumbnailId = "thumbnail_id"
    case discountedPrice = "discounted_price"
  }
}

extension ModifyDetailProductRequest {
  init(detailProduct: DetailProduct, secret: String) {
    self.name = detailProduct.name
    self.description = detailProduct.description
    
    if let thumbnailId = detailProduct.imagesInformation.first?.id {
      self.thumbnailId = thumbnailId
    } else {
      self.thumbnailId = 0
    }
    
    self.price = detailProduct.price
    self.currency = detailProduct.currency
    self.discountedPrice = detailProduct.discountedPrice
    self.stock = detailProduct.stock
    self.secret = secret
  }
}
