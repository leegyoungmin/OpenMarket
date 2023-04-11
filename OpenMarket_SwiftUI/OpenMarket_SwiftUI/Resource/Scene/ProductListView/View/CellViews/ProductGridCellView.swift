//
//  ProductGridCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductGridCellView: View {
  var body: some View {
    VStack {
      Image(systemName: "person.circle")
        .font(.largeTitle)
      
      Text("Mac Book Pro")
        .font(.title3)
        .bold()
      
      Text("USD 2,500").strikethrough().foregroundColor(.red)
      + Text("\nUSD 2,000")
      
      Text("잔여 수량 : \(148)")
    }
  }
}

struct ProductGridCellView_Previews: PreviewProvider {
  static var previews: some View {
    ProductGridCellView()
      .previewLayout(.sizeThatFits)
  }
}
