//
//  ProductRegisterImageCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductRegisterImageCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
    }
    
    func setImage(with data: Data) {
        if data.isEmpty {
            self.imageView.image = UIImage(systemName: "plus.circle")
            return
        }
        self.imageView.image = UIImage(data: data)
    }
}

private extension ProductRegisterImageCell {
    func configureUI() {
        addSubComponents()
        makeConstraints()
    }
    
    func addSubComponents() {
        [imageView].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
}
