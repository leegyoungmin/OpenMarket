//
//  ProductListCellViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

class ProductCellViewModel {
    let product: Product
    private let service: ImageLoadServicing = ImageLoadService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var imageData: Data?
    @Published private(set) var title: String = ""
    @Published private(set) var description: String = ""
    @Published private(set) var price: String = ""
    @Published private(set) var stock: Int = 0
    
    init(product: Product) {
        self.title = product.name
        self.description = product.description
        self.price = product.currency.rawValue + " " + product.price.description
        self.stock = product.stock
        self.product = product
        
        service.loadImageData(path: product.thumbnail)
            .sink { [weak self] in
                self?.imageData = $0
            }
            .store(in: &cancellables)
    }
    
    func cancel() {
        service.cancel()
    }
}
