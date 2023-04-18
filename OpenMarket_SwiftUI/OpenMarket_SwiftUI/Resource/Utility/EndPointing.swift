//
//  EndPoint.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Alamofire
import Foundation

protocol EndPointing {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var queries: Parameters { get }
    var body: MultipartFormData { get }
    
    func generateURL() throws -> URL
}

extension EndPointing {
    func generateURL() throws -> URL {
        var component = URLComponents(string: baseURL)
        component?.path = path
        
        guard let url = try? component?.asURL() else {
            throw APIError.unknown
        }
        
        return url
    }
}
