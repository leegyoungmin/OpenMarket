//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

final class ProductListViewModel: ObservableObject {
  @Published var products: [Int] = []
  
  init() {
    self.products = Array(1...20)
  }
}
