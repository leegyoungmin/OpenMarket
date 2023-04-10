//
//  NumberFormatter + Extension.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Foundation
import UIKit

extension NumberFormatter {
    static let formatter = NumberFormatter()
}

extension DetailProduct {
    func priceDescription() -> NSMutableAttributedString {
        let bargainPrice = currencyBargainNumber()
        
        if bargainPrice.isEmpty == true {
            return NSMutableAttributedString(string: currencyNumber())
        }
        
        let currencyNumber = currencyNumber()
        let description = currencyNumber + "\n" + bargainPrice
        let attributedDescription = NSMutableAttributedString(string: description)
        
        let bargainAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.secondaryLabel,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        
        attributedDescription.addAttributes(bargainAttribute, range: NSMakeRange(0, currencyNumber.count))
        
        return attributedDescription
    }
    
    private func currencyBargainNumber() -> String {
        if self.discountedPrice == .zero { return "" }
        let totalPrice = bargainPrice + price
        let formatter = NumberFormatter.formatter
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency.rawValue
        
        return formatter.string(for: bargainPrice) ?? ""
    }
    
    private func currencyNumber() -> String {
        let formatter = NumberFormatter.formatter
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency.rawValue
        
        return formatter.string(for: price) ?? "\n"
    }
}
