//
//  NSMutableData + Extension.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension NSMutableData {
    func appendString(with value: String) {
        if let data = value.data(using: .utf8) {
            self.append(data)
        }
    }
}

