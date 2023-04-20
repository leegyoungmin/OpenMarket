//
//  DetailProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct DetailProductView: View {
  let product: Product
  let list = ["a", "b", "c", "d", "e"]
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        TabView {
          ForEach(list, id: \.self) { _ in
            Image(systemName: "person.circle")
              .resizable()
              .scaledToFit()
              .frame(width: 300, height: 300, alignment: .center)
          }
        }
        .frame(height: 300)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
        HStack(alignment: .bottom) {
          Text(product.name)
            .font(.system(size: 25, weight: .bold, design: .default))
          
          Spacer()
          
          Text("남은 수량 : \(product.stock)")
            .foregroundColor(.secondary)
        }
        .padding(10)
        
        HStack {
          Spacer()
          
          VStack(alignment: .leading) {
            Text(product.priceDescription)
              .foregroundColor(.red)
              .strikethrough()
            
            Text(product.bargainPriceDescription)
          }
        }
        .padding(10)
        
        Text(product.description)
          .multilineTextAlignment(.leading)
          .padding(10)
      }
    }
  }
}

struct DetailProductView_Previews: PreviewProvider {
  static let mockData = Product.mockData
  static var previews: some View {
    DetailProductView(product: mockData)
  }
}
