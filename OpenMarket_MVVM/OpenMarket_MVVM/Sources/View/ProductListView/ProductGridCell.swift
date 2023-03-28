//
//  ProductGridCell.swift
//  OpenMarket_MVVM
//
//  Copyright (c) 2023 Minii All rights reserved.

import Combine
import UIKit

final class ProductGridCell: UICollectionViewCell, ProductListCollectionViewCell {
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var viewModel: ProductCellViewModel?
    
    var thumbnailImage: ThumbnailImageView = {
        let imageView = ThumbnailImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 12
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.4
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
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func update(with product: Product) {
        self.viewModel = ProductCellViewModel(product: product)
        bind()
    }
}

extension ProductGridCell {
    func configureUI() {
        addChildComponents()
        makeConstraints()
        setContentViewLayer()
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
            thumbnailImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            thumbnailImage.bottomAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: 12),
            thumbnailImage.widthAnchor.constraint(equalTo: thumbnailImage.heightAnchor),
            thumbnailImage.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12),

            priceLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            remainStockLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            remainStockLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            remainStockLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            remainStockLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }
    
    func setContentViewLayer() {
        contentView.layer.cornerRadius = 12
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 1
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
