//
//  EndPoint.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol EndPointing {
  var baseURL: String { get }
  var path: String { get }
  var method: String { get }
  var headers: [String: String] { get }
  var queries: [String: String] { get }
  var body: Data? { get }
}

extension Dictionary where Key == String, Value == String {
  var queryItems: [URLQueryItem] {
    return self.map { URLQueryItem(name: $0.key, value: $0.value) }
  }
}

extension EndPointing {
  func configureRequest() -> URLRequest? {
    var components = URLComponents(string: baseURL)
    
    components?.path = path
    components?.queryItems = queries.queryItems
    
    guard let url = components?.url else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = method
    headers.forEach {
      request.setValue($0.value, forHTTPHeaderField: $0.key)
    }
    request.httpBody = body
    
    return request
  }
}
