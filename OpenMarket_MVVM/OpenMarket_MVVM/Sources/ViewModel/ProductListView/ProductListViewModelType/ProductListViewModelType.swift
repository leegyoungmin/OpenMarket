//
//  ProductListViewModelType.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

struct ProductListViewModelInput {
  let onAppear: AnyPublisher<Void, Never>
}

enum ProductListViewModelState {
  case idle
  case loading
  case success(products: [Product])
  case fail
}

extension ProductListViewModelState: Equatable {
  static func == (lhs: ProductListViewModelState, rhs: ProductListViewModelState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle): return true
    case (.loading, .loading): return true
    case let (.success(lhsProducts), .success(rhsProducts)): return lhsProducts == rhsProducts
    case (.fail, .fail): return false
    default: return false
    }
  }
}

typealias ProductListViewModelOutput = AnyPublisher<ProductListViewModelState, Never>

protocol ProductListViewModelType {
  func transform(input: ProductListViewModelInput) -> ProductListViewModelOutput
}
