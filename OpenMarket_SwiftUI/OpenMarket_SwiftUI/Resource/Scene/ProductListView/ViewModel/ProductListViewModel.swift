//
//  ProductListViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
  private var page: Int = 1
  private var itemCount: Int = 10
  private var cancellables = Set<AnyCancellable>()
  
  @Published var products: [Product] = []
  
  init() {
    self.fetchProducts()
  }
  
  func fetchProducts() {
    var components = URLComponents(string: "https://openmarket.yagom-academy.kr")
    
    components?.path = "/api/products"
    components?.queryItems = [
      .init(name: "page_no", value: page.description),
      .init(name: "items_per_page", value: itemCount.description)
    ]
    
    guard let request = components?.url else { return }
    
    URLSession.shared.dataTaskPublisher(for: request)
      .receive(on: DispatchQueue.main)
      .map(\.data)
      .decode(type: ProductsResponse.self, decoder: JSONDecoder())
      .sink { completion in
        print(completion)
      } receiveValue: { response in
        self.products = response.items
      }
      .store(in: &cancellables)
  }
}
