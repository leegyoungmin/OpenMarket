//
//  MarketProductRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Alamofire
import Combine
import Foundation

protocol MarketProductRepository: WebRepository {
  func loadProducts(with page: Int, itemCount: Int) -> AnyPublisher<ProductsResponse, Error>
  func uploadProduct(with product: Data, images: [Data]) -> AnyPublisher<DetailProduct, Error>
}

final class MarketProductConcreteRepository: MarketProductRepository {
  func loadProducts(with page: Int, itemCount: Int) -> AnyPublisher<ProductsResponse, Error> {
    let endPoint = API.loadProducts(page: page, itemCount: itemCount)
    return requestNetwork(endPoint: endPoint, type: ProductsResponse.self)
  }
  
  func uploadProduct(with product: Data, images: [Data]) -> AnyPublisher<DetailProduct, Error> {
    let endPoint = API.uploadProduct(productData: product, images: images)
    
    return requestNetwork(endPoint: endPoint, type: DetailProduct.self)
  }
}

extension MarketProductConcreteRepository {
  enum API {
    case loadProducts(page: Int, itemCount: Int)
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
        HTTPHeader(name: "Content-Type", value: "multipart/form-data"),
        HTTPHeader(name: "identifier", value: "d94a4ffb-6941-11ed-a917-a7e99e3bb892")
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
  
  
  var body: MultipartFormData {
    switch self {
    case .loadProducts:
      return MultipartFormData()
      
    case let .uploadProduct(product, images):
      let formData = MultipartFormData()
      
      formData.append(product, withName: "params")
      
      for (index, image) in images.enumerated() {
        formData.append(image, withName: "images", fileName: "image_\(index)", mimeType: "image/png")
      }
      
      return formData
    }
  }
}
