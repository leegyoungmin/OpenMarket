//
//  RequestProduct.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct RequestProduct: Encodable {
    let name: String
    let description: String
    let price: String
    let currency: String
    let discountedPrice: String
    let stock: String
    let secret: String = "mgf4rzxzpe4gkpf5"
    
    enum CodingKeys: String, CodingKey {
        case name, description, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
    
    func encodingData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
