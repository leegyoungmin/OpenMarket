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

extension WebRepository {
    func requestNetwork<T: Decodable>(
        endPoint: EndPointing,
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        guard let request = endPoint.configureRequest() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate(statusCode: 200...300)
            .publishDecodable(type: type)
            .tryCompactMap(\.value)
            .eraseToAnyPublisher()
    }
}
