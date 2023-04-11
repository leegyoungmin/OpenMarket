//
//  ProductListCellView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductListCellView: View {
  var body: some View {
    HStack {
      Image(systemName: "person.circle")
        .font(.largeTitle)
      
      VStack {
        HStack {
          Text("Mac Mini")
          
          Spacer()
          
          Text("잔여 수량 : \(148)")
        }
        
        HStack {
          Text("USD 1,500").strikethrough().foregroundColor(.red)
          + Text(" USD 800")
          
          Spacer()
        }
      }
    }
  }
}

struct ProductListCellView_Previews: PreviewProvider {
  static var previews: some View {
    ProductListCellView()
      .previewLayout(.sizeThatFits)
  }
}
