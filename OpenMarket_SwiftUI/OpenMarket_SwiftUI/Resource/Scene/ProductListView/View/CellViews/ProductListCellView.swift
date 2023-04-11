//
//  ProductListCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductListCellView: View {
  let product: Product
  var body: some View {
    HStack {
      AsyncImage(url: URL(string: product.thumbnail)) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 80, height: 80)
          .cornerRadius(12)
      } placeholder: {
        ProgressView()
          .progressViewStyle(.circular)
          .frame(width: 80, height: 80, alignment: .center)
          .background(.thickMaterial)
          .cornerRadius(12)
      }

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
    .padding(5)
  }
}

struct ProductListCellView_Previews: PreviewProvider {
  static let mockProduct = Product.mockData
  static var previews: some View {
    ProductListCellView(product: mockProduct)
      .previewLayout(.sizeThatFits)
  }
}
