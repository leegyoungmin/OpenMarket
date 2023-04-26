//
//  ProductRegisterImageCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductRegisterImageCell: UICollectionViewCell {
    private let defaultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureUI()
        layer.cornerRadius = 12
    }
    
    func setImage(with data: Data?) {
        if let data = data {
            self.imageView.image = UIImage(data: data)
            self.defaultImageView.image = nil
            return
        }
        
        if data == nil {
            self.backgroundColor = .secondarySystemBackground
            self.imageView.image = nil
            self.defaultImageView.image = UIImage(systemName: "plus.circle")
            return
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .clear
        self.imageView.image = nil
        self.defaultImageView.image = UIImage(systemName: "plus.circle")
    }
}

private extension ProductRegisterImageCell {
    func configureUI() {
        addSubComponents()
        makeConstraints()
    }
    
    func addSubComponents() {
        [imageView, defaultImageView].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            defaultImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            defaultImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            defaultImageView.widthAnchor.constraint(equalToConstant: 30),
            defaultImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
