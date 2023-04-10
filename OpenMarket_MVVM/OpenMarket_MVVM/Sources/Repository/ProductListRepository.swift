//
//  ProductListRepository.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import Foundation

protocol ProductListLoadable: AnyObject {
    func fetchData<T: Decodable>(
        pageNumber: Int,
        count: Int,
        type: T.Type
    ) -> AnyPublisher<T, Error>
    
    func fetchData<T: Decodable>(
        id: Int,
        type: T.Type
    ) -> AnyPublisher<T, Error>
    
    func saveData(
        params: Data,
        images: [Data],
        identifier: Data
    ) -> AnyPublisher<Bool, Error>
    
    func getURI(with id: String) -> AnyPublisher<String, Error>
    func deleteData(with id: String) -> AnyPublisher<Bool, Error>
}

final class ProductListRepository: ProductListLoadable {
    func fetchData<T: Decodable>(
        pageNumber: Int,
        count: Int,
        type: T.Type
    ) -> AnyPublisher<T, Error> {
        let api = API.loadProducts(pageNumber: pageNumber, count: count)
        guard let url = try? api.configureRequest() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>(id: Int, type: T.Type) -> AnyPublisher<T, Error> {
        let api = API.detailProduct(id: id)
        
        guard let request = try? api.configureRequest() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func saveData(params: Data, images: [Data], identifier: Data) -> AnyPublisher<Bool, Error> {
        let register = ProductRegister(params: params, imageDatas: images, identifier: identifier)
        let api = API.saveProduct(id: NSUUID().uuidString, register)
        
        guard let request = try? api.configureRequest() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (_, response) -> Bool in
                guard let response = response as? HTTPURLResponse,
                      (200...300) ~= response.statusCode else {
                    
                    throw URLError(.badServerResponse)
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func getURI(with id: String) -> AnyPublisher<String, Error> {
        let api = API.deleteURI(id: id)
        
        guard let request = try? api.configureRequest() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      (200..<300) ~= response.statusCode else {
                    throw API.APIError.invalidURL
                }
                
                return String(data: data, encoding: .utf8) ?? ""
            }
            .eraseToAnyPublisher()
    }
    
    func deleteData(with path: String) -> AnyPublisher<Bool, Error> {
        let api = API.deleteProduct(path: path)
        
        guard let request = try? api.configureRequest() else {
            return Fail(error: API.APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse,
                      (200...300) ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                
                return true
            }
            .eraseToAnyPublisher()
    }
}

extension ProductListRepository {
    enum API {
        case loadProducts(pageNumber: Int, count: Int)
        case saveProduct(id: String, ProductRegister)
        case detailProduct(id: Int)
        case deleteURI(id: String)
        case deleteProduct(path: String)
    }
    
    struct ProductRegister {
        let params: Data
        let imageDatas: [Data]
        let identifier: Data
        
        var headers: [HTTPHeader] {
            var headerList = [HTTPHeader]()
            
            imageDatas.forEach {
                let header = HTTPHeader(name: "images", mimeType: .png, data: $0)
                headerList.append(header)
            }
            
            headerList.append(HTTPHeader(name: "params", mimeType: .json, data: params))
            
            headerList.append(HTTPHeader(name: "identifier", mimeType: .text, data: identifier))
            
            return headerList
        }
    }
}

extension ProductListRepository.API {
    enum APIError: Error {
        case invalidURL
    }
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var method: String {
        switch self {
        case .loadProducts, .detailProduct:
            return "GET"
        case .saveProduct, .deleteURI:
            return "POST"
            
        case .deleteProduct:
            return "DELETE"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .loadProducts, .detailProduct:
            return [:]
        case .saveProduct(let id, _):
            return [
                "identifier": "d94a4ffb-6941-11ed-a917-a7e99e3bb892",
                "Content-Type": "multipart/form-data; boundary=\(id)"
            ]
            
        case .deleteURI, .deleteProduct:
            return [
                "identifier": "d94a4ffb-6941-11ed-a917-a7e99e3bb892",
                "Content-Type": "application/json"
            ]
        }
    }
    
    var path: String {
        switch self {
        case .loadProducts, .saveProduct:
            return "/api/products"
            
        case .detailProduct(let id):
            return "/api/products/\(id)"
            
        case .deleteURI(let id):
            return "/api/products/\(id)/archived"
            
        case .deleteProduct(let path):
            return path
        }
    }
    
    var body: Data? {
        switch self {
        case .saveProduct(let id, let productData):
            return RegisterProductMultipartForm(
                id: id,
                headers: productData.headers
            ).generateBodyData()
            
        case .deleteURI:
            let encoder = JSONEncoder()
            
            guard let jsonData = try? encoder.encode(["secret": "mgf4rzxzpe4gkpf5"]) else {
                return nil
            }
            
            return jsonData
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .loadProducts(let pageNumber, let count):
            return [
                URLQueryItem(name: "page_no", value: pageNumber.description),
                URLQueryItem(name: "items_per_page", value: count.description)
            ]
            
        default:
            return []
        }
    }
    
    func configureRequest() throws -> URLRequest? {
        var components = URLComponents(string: baseURL)
        
        components?.path = path
        components?.queryItems = queryItems
        
        guard let url = components?.url else { throw APIError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        header.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = body
        return request
    }
}
