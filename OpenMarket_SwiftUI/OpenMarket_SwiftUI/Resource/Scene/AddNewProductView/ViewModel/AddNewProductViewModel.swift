//
//  AddNewProductViewModel.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class AddNewProductViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var selectedCurrency: Currency = .KRW
    @Published var discountedPrice: String = ""
    @Published var stock: String = ""
    @Published var description: String = ""
    @Published var isPresentPhotoPicker: Bool = false
    @Published var images: [Data] = []
    private var cancellables = Set<AnyCancellable>()
    
    private var marketRepository: MarketProductRepository
    
    init(marketRepository: MarketProductRepository = MarketProductConcreteRepository()) {
        self.marketRepository = marketRepository
    }
    
    func uploadProduct() {
        let product = RequestProduct(
            name: name,
            description: description,
            price: price,
            currency: selectedCurrency.rawValue,
            discountedPrice: discountedPrice,
            stock: stock
        )
        guard let encodeData = product.encodingData() else { return }
        marketRepository.uploadProduct(with: encodeData, images: images)
            .sink { completion in
                print(completion)
            } receiveValue: { _ in
                print("success")
            }
            .store(in: &cancellables)

    }
    
    func updateImage(with data: Data) {
        if images.count == 5 { return }
        
        images.append(data)
    }
    
    func deleteImage(to index: Int) {
        images.remove(at: index)
    }
}
