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
}

struct ImageInformation: Codable {
  let id: Int
  let url: String
  let thumbnailURL: String
  let issuedDate: String
  
  enum Vendor: String, CodingKey {
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
