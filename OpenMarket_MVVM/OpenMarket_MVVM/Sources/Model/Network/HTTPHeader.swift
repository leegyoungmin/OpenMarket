//
//  HTTPHeader.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

struct HTTPHeader {
    let name: String
    let mimeType: MimeType
    let data: Data
    
    init(name: String, mimeType: MimeType, data: Data) {
        self.name = name
        self.mimeType = mimeType
        self.data = data
    }
}

extension HTTPHeader {
    enum MimeType: CustomStringConvertible {
        case png
        case text
        case json
        
        var description: String {
            switch self {
            case .png:
                return "image/png"
            case .text:
                return "text/plain"
            case .json:
                return "application/json"
            }
        }
    }
}

