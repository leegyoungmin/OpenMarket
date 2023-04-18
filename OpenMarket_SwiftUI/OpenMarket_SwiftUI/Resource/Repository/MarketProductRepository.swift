//
//  MarketProductRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Alamofire
import Combine
import Foundation

protocol MarketProductRepository: WebRepository {
    func loadProducts(with page: Int) -> AnyPublisher<ProductsResponse, Error>
}

final class MarketProductConcreteRepository: MarketProductRepository {
    func loadProducts(with page: Int) -> AnyPublisher<ProductsResponse, Error> {
        let endPoint = API.loadProducts(page: page)
        return requestNetwork(endPoint: endPoint, type: ProductsResponse.self)
    }
}

extension MarketProductConcreteRepository {
    enum API {
        case loadProducts(page: Int, itemCount: Int = 10)
        case uploadProduct(productData: Data, images: [Data])
    }
}

extension MarketProductConcreteRepository.API: EndPointing {
    var method: HTTPMethod {
        switch self {
        case .loadProducts:
            return .get
        case .uploadProduct:
            return .post
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .loadProducts:
            return HTTPHeaders([
                HTTPHeader(name: "Content-Type", value: "application/json")
            ])
        case .uploadProduct:
            return [
                HTTPHeader(name: "Content-Type", value: "application/json"),
                HTTPHeader(name: "identifier", value: "d94a4ffb-6941-11ed-a917-a7e99e3bb89")
            ]
        }
    }
    
    var queries: Parameters {
        switch self {
        case .loadProducts(let page, let itemCount):
            return [
                "page_no": page.description,
                "items_per_page": itemCount.description
            ]
        default:
            return [:]
        }
    }
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var path: String {
        switch self {
        case .loadProducts, .uploadProduct:
            return "/api/products"
        }
    }
    
    
    var body: MultipartFormData? {
        switch self {
        case .loadProducts:
            return nil
            
        case let .uploadProduct(product, images):
            let formData = MultipartFormData()
            
            formData.append(product, withName: "params")
            
            for (index, image) in images.enumerated() {
                formData.append(image, withName: "images_\(index).png")
            }
            
            return formData
        }
    }
}
