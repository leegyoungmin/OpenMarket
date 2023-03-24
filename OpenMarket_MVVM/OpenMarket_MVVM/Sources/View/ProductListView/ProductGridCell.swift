//
//  ProductGridCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

final class ProductGridCell: UICollectionViewCell, ProductListCollectionViewCell {
    var thumbnailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2).bold()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    var remainStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ProductGridCell {
    func configureUI() {
        addChildComponents()
        makeConstraints()
    }
    
    func addChildComponents() {
        [
            thumbnailImage,
            titleLabel,
            priceLabel,
            remainStockLabel
        ].forEach(contentView.addSubview)
    }
    
    func makeConstraints() {
        let safeArea = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            thumbnailImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            thumbnailImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImage.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImage.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            remainStockLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            remainStockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            remainStockLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: - UIViewRepresentable
    
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

struct ProductGirdCell_Previews: PreviewProvider {
    static let product = Product.mockData().first!
    static var previews: some View {
        UIViewPreview {
            let cell = ProductGridCell()
            cell.update(with: product)
            return cell
        }
        .previewLayout(.fixed(width: 200, height: 300))
    }
}
#endif
