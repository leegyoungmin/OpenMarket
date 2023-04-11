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
    @Published var isDeleteProduct: Bool = false
    
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
                self.product = $0
            }
            .store(in: &cancellables)
    }
    
    func deleteProduct(password: String) {
        detailItemService.deleteProduct(with: id.description, password: password)
            .sink { [weak self] in
                guard let self = self else { return }
                self.isDeleteProduct = $0
            }
            .store(in: &cancellables)

    }
}
