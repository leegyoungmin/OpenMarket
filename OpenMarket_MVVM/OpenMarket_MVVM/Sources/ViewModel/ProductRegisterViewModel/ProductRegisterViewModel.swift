//
//  ProductRegisterViewModel.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

final class ProductRegisterViewModel {
    private let productListService: ProductListServicing
    private let imageLoadService: ImageLoadServicing
    
    init(
        product: DetailProduct?,
        productListService: ProductListServicing = ProductListService(),
        imageLoadService: ImageLoadServicing = ImageLoadService()
    ) {
        self.productListService = productListService
        self.imageLoadService = imageLoadService
        
        self.name = product?.name
        self.price = product?.price
        self.bargainPrice = product?.bargainPrice
        self.currency = product?.currency ?? .KRW
        self.stock = product?.stock
        self.description = product?.description
        
        product?.images.map(\.url).forEach {
            print($0)
            self.loadProductImageData(with: $0)
        }
    }
    
    private var selectedIndex: Int = 0
    @Published private(set) var imageDatas = CircularQueue<Data>(count: 5)
    @Published private(set) var imageItemDatas: [ImageItem] = [ImageItem()]
    
    @Published var name: String? = ""
    @Published var price: Double?
    @Published var bargainPrice: Double?
    @Published var currency: Currency = .KRW
    @Published var stock: Int?
    @Published var description: String?
    @Published var cancellables = Set<AnyCancellable>()
    
    var uploadState = CurrentValueSubject<ProductRegisterState, Never>(.ready)

    func setImageData(with data: Data) {
        self.imageDatas.enqueue(data, with: selectedIndex)
        var images = imageDatas.flatten().map { ImageItem(data: $0) }
        
        if images.count < 5 {
            images.append(ImageItem())
        }
        self.imageItemDatas = images
        selectedIndex += 1
    }
    
    func updateSelectedIndex(with index: Int) {
        self.selectedIndex = index
    }
    
    func generateParamsData() -> Data? {
        let product = RegisterProduct(
            name: name ?? "",
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
        
        uploadState.send(.loading)
        
        productListService.saveProduct(params: params, images: images, identifier: identifier)
            .sink {
                if $0 {
                    self.uploadState.send(.finish)
                } else {
                    self.uploadState.send(.error)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadProductImageData(with url: String) {
        imageLoadService.loadImageData(path: url)
            .sink { self.setImageData(with: $0) }
            .store(in: &cancellables)
    }
}

extension ProductRegisterViewModel {
    enum ProductRegisterState {
        case ready
        case loading
        case finish
        case error
    }
    
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
        
        enum CodingKeys: String, CodingKey {
            case name, description, price, currency, stock, secret
            case discountedPrice = "discounted_price"
        }
    }
}
