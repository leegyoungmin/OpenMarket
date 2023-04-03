//
//  UITextField + Combine.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .eraseToAnyPublisher()
    }
}

extension UITextView {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: self
        )
        .compactMap { ($0.object as? UITextView)?.text }
        .eraseToAnyPublisher()
    }
}

extension UISegmentedControl {
    var currencyChangedPublisher: AnyPublisher<Currency, Never> {
        controlPublisher(for: .valueChanged)
            .compactMap { $0 as? UISegmentedControl }
            .compactMap { $0?.selectedSegmentIndex }
            .compactMap { Currency(intValue: $0) }
            .eraseToAnyPublisher()
    }
}
