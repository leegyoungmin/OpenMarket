//
//  APIService.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import Combine

protocol APIServiceProtocol {
    func loadProducts(pageNumber: Int, count: Int) -> AnyPublisher<ProductsResponse, Error>
}

final class APIService: APIServiceProtocol {
    func loadProducts(pageNumber: Int, count: Int) -> AnyPublisher<ProductsResponse, Error> {
        let url = URL(string: "https://openmarket.yagom-academy.kr/api/products?page_no=\(pageNumber)&items_per_page=\(count)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductsResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
