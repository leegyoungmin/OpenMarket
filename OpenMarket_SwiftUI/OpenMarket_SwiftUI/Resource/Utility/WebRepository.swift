//
//  WebRepository.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol WebRepository: AnyObject {
  func requestNetwork<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error>
}

extension WebRepository {
  func requestNetwork<T: Decodable>(
    endPoint: EndPointing,
    type: T.Type
  ) -> AnyPublisher<T, Error> {
    guard let request = endPoint.configureRequest() else {
      return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: request)
      .map(\.data)
      .decode(type: T.self, decoder: JSONDecoder())
      .eraseToAnyPublisher()
  }
}
