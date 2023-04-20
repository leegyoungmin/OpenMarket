//
//  WebRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Alamofire
import Combine
import Foundation

protocol WebRepository: AnyObject {
  func requestNetwork<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error>
}

enum APIError: Error {
  case http(AFError)
  case unknown
}

extension WebRepository {
  func requestNetwork<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error> {
    guard let url = try? endPoint.generateURL() else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    switch endPoint.method {
    case .post:
      let request = AF.upload(
        multipartFormData: endPoint.body,
        to: url,
        method: endPoint.method,
        headers: endPoint.headers
      )
      return execute(with: request, type: type)
    default:
      let request = AF.request(
        url,
        method: endPoint.method,
        parameters: endPoint.queries,
        headers: endPoint.headers
      )
      
      return execute(with: request, type: type)
    }
  }
}

private extension WebRepository {
  func execute<T: Decodable>(with request: DataRequest, type: T.Type) -> AnyPublisher<T, Error> {
    request
      .validate(statusCode: 200...300)
      .publishDecodable(type: type)
      .tryCompactMap(\.value)
      .eraseToAnyPublisher()
  }
}
