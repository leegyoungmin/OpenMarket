//
//  ProductListViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductListViewModel: ProductListViewModelType {
  private var cancellables = [AnyCancellable]()
  private var pageNumber: Int = 1
  private let elementCount: Int = 10
  private let apiService: ProductListServicing
  
  init(apiService: ProductListServicing) {
    self.apiService = apiService
  }
  
  func transform(input: ProductListViewModelInput) -> ProductListViewModelOutput {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    
    let products = input.onAppear
      .flatMap { [unowned self] _ -> AnyPublisher<[Product], Error> in
        self.apiService.loadProducts(count: self.elementCount)
      }
      .replaceError(with: [])
      .map { result -> ProductListViewModelState in
        if result.isEmpty { return .fail }
        return .success(products: result)
      }
      .eraseToAnyPublisher()
    
    return products
  }
  
  //    private var pageNumber: Int = 1
  //    private var elementCount: Int = 10
  //
  //    @Published private(set) var products: [Product] = []
  //    @Published private(set) var collectionCase: CollectionViewCase = .list
  //
  //    private let apiService: ProductListServicing
  //    private var subscribers = Set<AnyCancellable>()
  //
  //    init(apiService: ProductListServicing = ProductListService()) {
  //        self.apiService = apiService
  //    }
  //
  //    func fetchNextPage() {
  //        apiService.loadProducts(pageNumber: pageNumber, count: elementCount)
  //            .sink { completion in
  //                switch completion {
  //                case .finished:
  //                    self.pageNumber += 1
  //                case .failure(let error):
  //                    debugPrint(error)
  //                }
  //            } receiveValue: { products in
  //                self.products += products
  //            }
  //            .store(in: &subscribers)
  //    }
  //
  //    func reloadData() {
  //        let count = (pageNumber * elementCount)
  //        apiService.loadProducts(pageNumber: 1, count: count)
  //            .replaceError(with: [])
  //            .sink {
  //                self.products = $0
  //            }
  //            .store(in: &subscribers)
  //    }
  //
  //    func toggleCollectionCase() {
  //        switch collectionCase {
  //        case .list:
  //            collectionCase = .gridTwoColumn
  //        case .gridTwoColumn:
  //            collectionCase = .gridThreeColumn
  //        case .gridThreeColumn:
  //            collectionCase = .list
  //        }
  //    }
}

extension ProductListViewModel {
  enum CollectionViewCase {
    case list
    case gridTwoColumn
    case gridThreeColumn
  }
}

extension ProductListViewModel.CollectionViewCase {
  var systemImageName: String {
    switch self {
    case .list:
      return "square.grid.2x2"
      
    case .gridTwoColumn:
      return "square.grid.3x3"
      
    case .gridThreeColumn:
      return "list.bullet"
    }
  }
  
  var numberOfColumns: Int {
    switch self {
    case .list:
      return 1
    case .gridTwoColumn:
      return 2
    case .gridThreeColumn:
      return 3
    }
  }
}
