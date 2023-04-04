//
//  HTTPHeader.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct HTTPHeader {
    let name: String
    let mimeType: String
    let data: Data
    
    init(name: String, mimeType: String, data: Data) {
        self.name = name
        self.mimeType = mimeType
        self.data = data
    }
}

struct MultipartFormData {
    let headers: [HTTPHeader]
    let id: String
    
    func boundaryData() -> Data {
        let boundary = "--\(id)"
        let data = NSMutableData()
        
        for header in headers {
            data.appendString(with: boundary + "\r\n")
            data.appendString(with: "Content-Disposition: form-data; name=\"\(header.name)\"")
            
            if header.mimeType == "image/png" {
                data.appendString(with: "; filename=\"productImage.png\"\r\n")
                data.appendString(with: "Content-Type: \(header.mimeType)\r\n")
            } else {
                data.appendString(with: "\r\n")
                data.appendString(with: "Content-Type: \(header.mimeType)\r\n")
            }
            
            data.appendString(with: "\r\n")
            data.append(header.data)
            data.appendString(with: "\r\n")
        }
        
        data.appendString(with: "--\(id)--\r\n")
        return data as Data
    }
}

private extension NSMutableData {
    func appendString(with value: String) {
        if let data = value.data(using: .utf8) {
            self.append(data)
        }
    }
}
