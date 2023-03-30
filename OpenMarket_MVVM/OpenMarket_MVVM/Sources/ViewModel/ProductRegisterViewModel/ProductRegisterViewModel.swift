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
}
