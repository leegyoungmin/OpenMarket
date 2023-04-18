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
    
    func updateImage(with data: Data) {
        if images.count == 5 { return }
        
        images.append(data)
    }
    
    func deleteImage(to index: Int) {
        images.remove(at: index)
    }
}
