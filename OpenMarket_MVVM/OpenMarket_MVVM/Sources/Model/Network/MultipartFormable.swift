//
//  MultipartFormable.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

protocol MultipartFormable {
    var headers: [HTTPHeader] { get }
    var id: String { get }
    func generateBodyData() -> Data
}

extension MultipartFormable {
    func generateBodyData() -> Data {
        let boundary = "--\(id)"
        let nextLine = "\r\n"
        
        func generateContentDisposition(name: String) -> String {
            return "Content-Disposition: form-data; name=\"\(name)\""
        }
        
        func generateContentType(mimeType: String) -> String {
            return "Content-Type: \(mimeType)\r\n"
        }
        
        let fileName = "; filename=\"productImage.png\"\r\n"
        
        let data = NSMutableData()
        
        for header in headers {
            data.appendString(with: boundary + nextLine)
            data.appendString(with: generateContentDisposition(name: header.name))
            
            if header.mimeType == .png {
                data.appendString(with: fileName)
                data.appendString(with: generateContentType(mimeType: header.mimeType.description))
            } else {
                data.appendString(with: nextLine)
                data.appendString(with: generateContentType(mimeType: header.mimeType.description))
            }
            
            data.appendString(with: nextLine)
            data.append(header.data)
            data.appendString(with: nextLine)
        }
        
        data.appendString(with: "\(boundary)--\r\n")
        
        return data as Data
    }
}
