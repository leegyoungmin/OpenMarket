//
//  ProductListRepository.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ProductListLoadable: AnyObject {
    func fetchData<T: Decodable>(with url: URL, type: T.Type) -> AnyPublisher<T, Error>
}

final class ProductListRepository: ProductListLoadable {
    func fetchData<T: Decodable>(with url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
