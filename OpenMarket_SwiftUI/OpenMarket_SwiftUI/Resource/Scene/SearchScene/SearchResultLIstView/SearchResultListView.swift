//
//  SearchResultListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SearchResultListView: View {
  @Binding var products: [Product]
  
  var body: some View {
    List {
      ForEach(products, id: \.id) { product in
        VStack {
          searchResultCellView(to: product)
          
          Divider()
        }
        .listRowSeparator(.hidden)
      }
    }
    .listStyle(.inset)
    .cornerRadius(16)
    .padding(.bottom)
  }
}

private extension SearchResultListView {
  @ViewBuilder func searchResultCellView(to product: Product) -> some View {
    HStack {
      AsyncImage(url: URL(string: product.thumbnail)) { imagePhase in
        imagePhase
          .resizable()
          .frame(width: 50, height: 50)
      } placeholder: {
        RoundedRectangle(cornerRadius: 12)
          .fill(.gray.opacity(0.2))
          .frame(width: 50, height: 50)
      }
      
      VStack(alignment: .leading) {
        Text(product.name)
          .lineLimit(1)
          .font(.subheadline)
          .foregroundColor(.accentColor)
        
        Text(product.vendorName)
          .lineLimit(1)
          .font(.caption)
          .foregroundColor(.secondary)
      }
      
      Spacer()
    }
  }
}

struct SearchResultList_Previews: PreviewProvider {
  static var previews: some View {
    SearchView()
  }
}
