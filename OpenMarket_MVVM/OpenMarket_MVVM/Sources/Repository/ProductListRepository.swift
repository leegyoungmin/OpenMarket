//
//  ProductListRepository.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ProductListLoadable: AnyObject {
    func fetchData<T: Decodable>(
        pageNumber: Int,
        count: Int,
        type: T.Type
    ) -> AnyPublisher<T, Error>
}

final class ProductListRepository: ProductListLoadable {
    func fetchData<T: Decodable>(
        pageNumber: Int,
        count: Int,
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        let api = API.loadProducts(pageNumber: pageNumber, count: count)
        guard let url = try? api.configureURL() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension ProductListRepository {
    enum API {
        case loadProducts(pageNumber: Int, count: Int)
//        case saveProduct(Product)
    }
}

extension ProductListRepository.API {
    enum APIError: Error {
        case invalidURL
    }
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var path: String {
        switch self {
        case .loadProducts:
            return "/api/products"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .loadProducts(let pageNumber, let count):
            return [
                URLQueryItem(name: "page_no", value: pageNumber.description),
                URLQueryItem(name: "items_per_page", value: count.description)
            ]
        }
    }
    
    func configureURL() throws -> URL? {
        var components = URLComponents(string: baseURL)
        
        components?.path = path
        components?.queryItems = queryItems
        
        guard let url = components?.url else { throw APIError.invalidURL }
        return url
    }
}
