//
//  ProductDetailInformationView.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductDetailInformationView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.contentInset = .zero
        textView.scrollIndicatorInsets = .zero
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateData(with product: DetailProduct) {
        self.titleLabel.text = product.name
        self.stockLabel.text = "남은 수량 : \(product.stock.description)"
        self.descriptionTextView.text = product.description
        self.priceLabel.text = product.currencyNumber()
    }
}

private extension ProductDetailInformationView {
    func configureUI() {
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [titleLabel, stockLabel, priceLabel, descriptionTextView].forEach(addSubview)
    }
    
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            
            stockLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            stockLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            stockLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stockLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            priceLabel.trailingAnchor.constraint(equalTo: stockLabel.trailingAnchor),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
