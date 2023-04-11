//
//  ProductListCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductListCellView: View {
  let product: Product
  var body: some View {
    VStack {
      HStack {
        thumbnailImage(with: product.thumbnail)

        VStack {
          HStack {
            Text(product.name)
              .font(.title3)
            
            Spacer()
            
            Text("잔여 수량 : \(product.stock)")
          }
          
          HStack {
            Text("\(product.currency.rawValue) \(Int(product.price))").strikethrough().foregroundColor(.red)
            + Text(" \(product.currency.rawValue) \(Int(product.bargainPrice))")
            
            Spacer()
          }
        }
      }
      
      Divider()
    }
    .padding(5)
  }
}

private extension ProductListCellView {
  @ViewBuilder
  func thumbnailImage(with path: String) -> some View {
    AsyncImage(url: URL(string: path)) { image in
      image
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80, alignment: .center)
        .cornerRadius(12)
    } placeholder: {
      progressView
    }
  }
  
  var progressView: some View {
    ProgressView()
      .frame(width: 80, height: 80, alignment: .center)
      .progressViewStyle(.circular)
      .background(.thickMaterial)
      .cornerRadius(12)
  }
}

struct ProductListCellView_Previews: PreviewProvider {
  static let mockProduct = Product.mockData
  static var previews: some View {
    ProductListCellView(product: mockProduct)
      .previewLayout(.sizeThatFits)
  }
}
