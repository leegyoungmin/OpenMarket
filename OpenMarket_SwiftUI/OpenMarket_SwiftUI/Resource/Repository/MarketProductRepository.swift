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
  func loadDetailProduct(to id: String) -> AnyPublisher<DetailProduct, Error>
  func removeProduct(to id: String, with password: String) -> AnyPublisher<String, Error>
}

final class MarketProductConcreteRepository: MarketProductRepository {
  func loadProducts(with page: Int, itemCount: Int) -> AnyPublisher<ProductsResponse, Error> {
    let endPoint = API.loadProducts(page: page, itemCount: itemCount)
    return requestNetworkWithCodable(endPoint: endPoint, type: ProductsResponse.self)
  }
  
  func uploadProduct(with product: Data, images: [Data]) -> AnyPublisher<DetailProduct, Error> {
    let endPoint = API.uploadProduct(productData: product, images: images)
    
    return requestNetworkWithCodable(endPoint: endPoint, type: DetailProduct.self)
  }
  
  func loadDetailProduct(to id: String) -> AnyPublisher<DetailProduct, Error> {
    let endPoint = API.loadDetailProduct(id: id)
    
    return requestNetworkWithCodable(endPoint: endPoint, type: DetailProduct.self)
  }
  
  func removeProduct(to id: String, with password: String) -> AnyPublisher<String, Error> {
    let endPoint = API.requestRemoveURL(id: id, password: password)
    
    return requestNetworkWithString(endPoint: endPoint)
  }
}

extension MarketProductConcreteRepository {
  enum API {
    case loadProducts(page: Int, itemCount: Int)
    case uploadProduct(productData: Data, images: [Data])
    case loadDetailProduct(id: String)
    case requestRemoveURL(id: String, password: String)
  }
  
  enum BodyType {
    case json
    case multipartForm
  }
}

extension MarketProductConcreteRepository.API: EndPointing {
  var method: HTTPMethod {
    switch self {
    case .loadProducts, .loadDetailProduct:
      return .get
    case .uploadProduct, .requestRemoveURL:
      return .post
    }
  }
  
  var headers: HTTPHeaders {
    switch self {
    case .loadProducts, .loadDetailProduct:
      return [
        HTTPHeader(name: "Content-Type", value: "application/json")
      ]
    case .uploadProduct:
      return [
        HTTPHeader(name: "Content-Type", value: "multipart/form-data"),
        HTTPHeader(name: "identifier", value: "d94a4ffb-6941-11ed-a917-a7e99e3bb892")
      ]
      
    case .requestRemoveURL:
      return [
        HTTPHeader(name: "Content-Type", value: "application/json"),
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
      
    case let .loadDetailProduct(id):
      return "/api/products/\(id)"
      
    case let .requestRemoveURL(id, _):
      return "/api/products/\(id)/archived"
    }
  }
  
  var body: Any? {
    switch self {
    case .loadProducts, .loadDetailProduct:
      return nil
      
    case let .uploadProduct(product, images):
      let formData = MultipartFormData()
      
      formData.append(product, withName: "params")
      
      for (index, image) in images.enumerated() {
        formData.append(image, withName: "images", fileName: "images_\(index)", mimeType: "image/png")
      }
      
      return formData
      
    case let .requestRemoveURL(_, password):
      guard let encodedData = try? JSONEncoder().encode(["secret": password]) else {
        return nil
      }
      
      return encodedData
    }
  }
}
