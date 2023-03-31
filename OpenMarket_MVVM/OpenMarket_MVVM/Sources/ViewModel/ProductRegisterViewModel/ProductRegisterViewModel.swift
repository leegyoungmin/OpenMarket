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
    
    private var selectedIndex: Int = 0
    @Published private(set) var imageDatas = CircularQueue<Data>(count: 5)
    @Published private(set) var imageItemDatas: [ImageItem] = [ImageItem()]
    
    private var name: String = ""
    private var price: Double?
    private var bargainPrice: Double?
    private var currency: Currency = .KRW
    private var stock: Int?
    private var description: String?

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
    
    func setName(with name: String) {
        self.name = name
    }
    
    func setPrice(with price: Double) {
        self.price = price
    }
    
    func setBargainPrice(with price: Double) {
        self.bargainPrice = price
    }
    
    func setStock(with stock: Int) {
        self.stock = stock
    }
    
    func setDescription(with description: String) {
        self.description = description
    }
    
    func saveProduct() {
        
    }
}
