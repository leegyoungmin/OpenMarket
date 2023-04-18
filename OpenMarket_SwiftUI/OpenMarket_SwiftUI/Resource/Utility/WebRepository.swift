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
    
    func uploadRequestNetwork<T: Decodable>(
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
        
        return AF.request(
            url,
            method: endPoint.method,
            parameters: endPoint.queries,
            headers: endPoint.headers
        )
        .validate()
        .publishDecodable(type: type)
        .tryCompactMap(\.value)
        .eraseToAnyPublisher()
    }
    
    func uploadRequestNetwork<T: Decodable>(
        endPoint: EndPointing,
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        guard let url = try? endPoint.generateURL() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        guard let body = endPoint.body else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.upload(
            multipartFormData: body,
            to: url,
            method: endPoint.method,
            headers: endPoint.headers
        )
        .validate(statusCode: 200...300)
        .publishDecodable(type: type)
        .tryCompactMap(\.value)
        .eraseToAnyPublisher()
    }
}
