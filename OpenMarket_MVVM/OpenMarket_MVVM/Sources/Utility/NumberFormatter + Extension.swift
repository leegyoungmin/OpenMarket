//
//  NumberFormatter + Extension.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension NumberFormatter {
    static let formatter = NumberFormatter()
}

extension DetailProduct {
    func currencyNumber() -> String {
        let formatter = NumberFormatter.formatter
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency.rawValue
        
        return formatter.string(for: price) ?? ""
    }
}
