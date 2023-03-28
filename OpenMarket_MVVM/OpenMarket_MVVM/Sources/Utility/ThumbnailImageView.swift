//
//  ThumbnailImageView.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ThumbnailImageView: UIView {
    private let imageShadowView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(imageShadowView)
        imageShadowView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageShadowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageShadowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageShadowView.widthAnchor.constraint(equalToConstant: 100),
            imageShadowView.heightAnchor.constraint(equalToConstant: 100),
            
            imageView.leadingAnchor.constraint(equalTo: imageShadowView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageShadowView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: imageShadowView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageShadowView.bottomAnchor),
        ])
    }
    
    func setImage(with data: Data) {
        self.imageView.image = UIImage(data: data)
    }
    
    func resetImage() {
        self.imageView.image = nil
    }
}
