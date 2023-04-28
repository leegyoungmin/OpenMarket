//
//  ProductListCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

// MARK: Content View
struct ProductListCellView: View {
  let product: Product
  var body: some View {
    HStack {
      thumbnailImage(with: product.thumbnail)
      
      titleSection
      
      Spacer()
    }
    .padding(12)
    .background(.white)
    .cornerRadius(16)
  }
}

// MARK: Child View Components
private extension ProductListCellView {
  @ViewBuilder func thumbnailImage(with path: String) -> some View {
    AsyncImage(url: URL(string: path)) { image in
      image
        .resizable()
        .scaledToFit()
        .frame(height: Constants.imageHeight)
        .cornerRadius(12)
    } placeholder: {
      progressView
    }
  }
  
  var progressView: some View {
    ProgressView()
      .scaledToFit()
      .frame(width: Constants.imageHeight, height: Constants.imageHeight)
      .progressViewStyle(.circular)
      .background(.thickMaterial)
      .cornerRadius(12)
  }
  
  var titleSection: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(product.name)
        .font(.system(size: 16, weight: .semibold, design: .default))
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      if product.isDiscounted {
        Text(product.priceDescription)
          .font(.system(size: 14))
          .strikethrough()
          .foregroundColor(.black.opacity(0.2))
      }
      
      Text(product.bargainPriceDescription)
        .font(.system(size: 14))
        .foregroundColor(.accentColor)
    }
  }
}
// MARK: Name Space
private extension ProductListCellView {
  enum Constants {
    static let cellContentSpacing: CGFloat = 10
    static let imageHeight: CGFloat = 100
    static let stockPlaceholder: String = "잔여 수량 : "
  }
}

// MARK: Previews
struct ProductListCellView_Previews: PreviewProvider {
  static let mockProduct = Product.mockData
  static var previews: some View {
    NavigationStack {
      ProductListView(viewModel: ProductListViewModel())
    }
    //    ProductListCellView(product: mockProduct)
    //      .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 100))
  }
}
