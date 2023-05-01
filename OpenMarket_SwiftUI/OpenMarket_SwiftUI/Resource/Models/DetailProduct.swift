//
//  DetailProduct.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

struct DetailProduct: Codable {
  let id: Int
  let vendorId: Int
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
  let imagesInformation: [ImageInformation]
  let vendor: Vendor
  
  enum CodingKeys: String, CodingKey {
    case id
    case vendorId = "vendor_id"
    case name
    case description
    case thumbnail
    case currency
    case price
    case bargainPrice = "bargain_price"
    case discountedPrice = "discounted_price"
    case stock
    case createdDate = "created_at"
    case issuedDate = "issued_at"
    case imagesInformation = "images"
    case vendor = "vendors"
  }
  
  init(product: Product) {
    self.id = product.itemId
    self.vendorId = product.vendorId
    self.name = product.name
    self.description = product.description
    self.thumbnail = product.thumbnail
    self.currency = product.currency
    self.price = product.price
    self.bargainPrice = product.bargainPrice
    self.discountedPrice = product.discountedPrice
    self.stock = product.stock
    self.createdDate = product.createdDate
    self.issuedDate = product.issuedDate
    self.imagesInformation = []
    self.vendor = Vendor(id: product.vendorId, name: "")
  }
}

struct ImageInformation: Codable, Hashable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let issuedDate: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case url
    case thumbnailURL = "thumbnail_url"
    case issuedDate = "issued_at"
  }
}

struct Vendor: Codable {
  let id: Int
  let name: String
}
