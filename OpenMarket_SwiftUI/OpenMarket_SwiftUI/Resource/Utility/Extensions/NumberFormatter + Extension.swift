//
//  NumberFormatter + Extension.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation

extension NumberFormatter {
    static let defaultFormatter = NumberFormatter()
}

extension Double {
    func convertCurrencyValue(with currencySymbol: String) -> String {
        let formatter = NumberFormatter.defaultFormatter
        formatter.numberStyle = .currency
        formatter.currencySymbol = currencySymbol
        
        return formatter.string(for: self) ?? ""
    }
}
