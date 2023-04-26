//
//  WebRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Alamofire
import Combine
import Foundation

protocol WebRepository: AnyObject {
  func requestNetworkWithCodable<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error>
  
  func requestNetworkWithString(endPoint: EndPointing) -> AnyPublisher<String, Error>
}

enum APIError: Error {
  case http(AFError)
  case unknown
}

extension WebRepository {
  func requestNetworkWithCodable<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error> {
    guard let url = try? endPoint.generateURL() else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    switch endPoint.method {
    case .post:
      guard let data = endPoint.body else {
        return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
      }
      
      if let data = data as? MultipartFormData {
        let request = AF.upload(
          multipartFormData: data,
          to: url,
          method: endPoint.method,
          headers: endPoint.headers
        )
        
        return executeToCodable(with: request)
      }
      
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
      
    case .patch:
      guard let data = endPoint.body else {
        return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
      }
      
      if let data = data as? Data {
        let request = AF.upload(data, to: url, method: endPoint.method, headers: endPoint.headers)
        return executeToCodable(with: request)
      }
      
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()

    default:
      let request = AF.request(
        url,
        method: endPoint.method,
        parameters: endPoint.queries,
        headers: endPoint.headers
      )
      
      return executeToCodable(with: request)
    }
  }
  
  func requestNetworkWithString(endPoint: EndPointing) -> AnyPublisher<String, Error> {
    guard let url = try? endPoint.generateURL(),
          let body = endPoint.body as? Data else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    let request = AF.upload(body, to: url, method: endPoint.method, headers: endPoint.headers)
    
    return executeToString(with: request)
  }
}

private extension WebRepository {
  func executeToCodable<T: Decodable>(with request: DataRequest) -> AnyPublisher<T, Error> {
    request
      .validate(statusCode: 200...300)
      .publishDecodable(type: T.self)
      .tryCompactMap {
        print($0.response)
        return $0.value
      }
      .eraseToAnyPublisher()
  }
  
  func executeToString(with request: DataRequest) -> AnyPublisher<String, Error> {
    request
      .validate(statusCode: 200...300)
      .publishString()
      .tryCompactMap(\.value)
      .eraseToAnyPublisher()
  }
}
