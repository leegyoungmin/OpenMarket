//
//  ProductRegisterViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class ProductRegisterViewModel {
    struct ImageItem: Hashable {
        let id = UUID()
        var data: Data? = nil
    }
    
    struct RegisterProduct: Codable {
        let name: String
        let description: String
        let price: String
        let currency: String
        let discountedPrice: String
        let stock: String
        var secret: String = "mgf4rzxzpe4gkpf5"
    }
    
    private let productListService: ProductListServicing
    
    init(productListService: ProductListServicing = ProductListService(productsListRepository: ProductListRepository())) {
        self.productListService = productListService
    }
    
    private var selectedIndex: Int = 0
    @Published private(set) var imageDatas = CircularQueue<Data>(count: 5)
    @Published private(set) var imageItemDatas: [ImageItem] = [ImageItem()]
    
    @Published var name: String = ""
    @Published var price: Double?
    @Published var bargainPrice: Double?
    @Published var currency: Currency = .KRW
    @Published var stock: Int?
    @Published var description: String?
    @Published var cancellables = Set<AnyCancellable>()

    func setImageData(with data: Data) {
        self.imageDatas.enqueue(data, with: selectedIndex)
        var images = imageDatas.flatten().map { ImageItem(data: $0) }
        if images.count < 5 {
            images.append(ImageItem())
        }
        self.imageItemDatas = images
    }
    
    func updateSelectedIndex(with index: Int) {
        self.selectedIndex = index
    }
    
    func generateParamsData() -> Data? {
        let product = RegisterProduct(
            name: name,
            description: description ?? "",
            price: price?.description ?? "1",
            currency: currency.rawValue,
            discountedPrice: bargainPrice?.description ?? "0",
            stock: stock?.description ?? "0"
        )
        
        let encoder = JSONEncoder()
        
        return try? encoder.encode(product)
    }
    
    func registerProduct() {
        guard let params = generateParamsData() else { return }
        guard let identifier = "d94a4ffb-6941-11ed-a917-a7e99e3bb892".data(using: .utf8) else { return }
        let images = imageItemDatas.compactMap(\.data)
        
        productListService.saveProduct(params: params, images: images, identifier: identifier)
            .sink {
                if $0 {
                    print("Success save")
                }
            }
            .store(in: &cancellables)
    }
}
