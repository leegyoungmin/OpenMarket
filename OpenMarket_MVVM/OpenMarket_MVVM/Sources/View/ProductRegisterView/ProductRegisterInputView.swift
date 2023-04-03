//
//  ProductRegisterInputView.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductRegisterInputView: UIView {
    // View Properties
    let nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "상품명"
        nameTextField.borderStyle = .roundedRect
        return nameTextField
    }()
    let priceTextField: UITextField = {
        let priceTextField = UITextField()
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.placeholder = "상품 가격"
        priceTextField.keyboardType = .numberPad
        priceTextField.borderStyle = .roundedRect
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return priceTextField
    }()
    let currencySegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.selectedSegmentIndex = 0
        control.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return control
    }()
    let bargainPriceTextField: UITextField = {
        let bargainTextField = UITextField()
        bargainTextField.translatesAutoresizingMaskIntoConstraints = false
        bargainTextField.placeholder = "할인 금액"
        bargainTextField.keyboardType = .numberPad
        bargainTextField.borderStyle = .roundedRect
        return bargainTextField
    }()
    let stockTextField: UITextField = {
        let stockTextField = UITextField()
        stockTextField.translatesAutoresizingMaskIntoConstraints = false
        stockTextField.placeholder = "재고 수량"
        stockTextField.keyboardType = .numberPad
        stockTextField.borderStyle = .roundedRect
        return stockTextField
    }()
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [priceTextField, currencySegmentControl].forEach(priceStackView.addArrangedSubview)
        [nameTextField, priceStackView, bargainPriceTextField, stockTextField].forEach(totalStackView.addArrangedSubview)
        [totalStackView, descriptionTextView].forEach(addSubview)
        
        configureHirecy()
    }
    
    private func configureHirecy() {
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            totalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            totalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: totalStackView.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: totalStackView.bottomAnchor, constant: 12),
            descriptionTextView.trailingAnchor.constraint(equalTo: totalStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
