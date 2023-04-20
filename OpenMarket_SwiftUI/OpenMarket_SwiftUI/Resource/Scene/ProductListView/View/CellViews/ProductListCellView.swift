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
      
      VStack(spacing: Constants.cellContentSpacing) {
        titleSection
        
        priceSection
      }
    }
    .padding()
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
    HStack {
      Text(product.name)
        .font(.title3)
      
      Spacer()
      
      Text(product.isSoldOut ? "품절" : "잔여 수량 : \(product.stock)")
        .foregroundColor(product.isSoldOut ? .red : .black)
    }
  }
  
  var priceSection: some View {
    HStack {
      if product.isDiscounted {
        Text(product.priceDescription)
          .strikethrough(color: .red)
          .foregroundColor(.red)
      }
      
      Text(product.bargainPriceDescription)
      
      Spacer()
    }
  }
}

// MARK: Name Space
private extension ProductListCellView {
  enum Constants {
    static let cellContentSpacing: CGFloat = 10
    static let imageHeight: CGFloat = 80
    static let stockPlaceholder: String = "잔여 수량 : "
  }
}

// MARK: Previews
struct ProductListCellView_Previews: PreviewProvider {
  static let mockProduct = Product.mockData
  static var previews: some View {
    ProductListCellView(product: mockProduct)
      .previewLayout(.fixed(width: UIScreen.main.bounds.width, height: 100))
  }
}
