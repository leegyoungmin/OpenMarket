//
//  ProductDetailViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine

final class ProductDetailViewModel {
    private let id: Int
    private let detailItemService: ProductListServicing
    private var cancellables = Set<AnyCancellable>()
    
    @Published var product: DetailProduct?
    
    init(id: Int, detailItemService: ProductListServicing = ProductListService()) {
        self.id = id
        self.detailItemService = detailItemService
        
        fetchDetailProduct()
    }
    
    func fetchDetailProduct() {
        detailItemService.loadProduct(id: self.id)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    return
                }
            } receiveValue: {
                print($0)
                self.product = $0
            }
            .store(in: &cancellables)

    }
}
