//
//  ProductListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductListDisplayView: View {
  @ObservedObject var viewModel: ProductListViewModel
  @Binding var selectedSection: ListSection
  
  init(_ selectedSection: Binding<ListSection>) {
    self._viewModel = ObservedObject(initialValue: ProductListViewModel())
    self._selectedSection = selectedSection
  }
  
  var body: some View {
    if selectedSection == .list {
      ProductListView(products: $viewModel.products)
    } else {
      ProductGridView(products: $viewModel.products)
    }
  }
}

private extension ProductListDisplayView {
  struct ProductListView: View {
    @Binding var products: [Product]
    
    var body: some View {
      List {
        ForEach(products, id: \.self) { product in
          ProductListCellView(product: product)
        }
        .listRowSeparator(.visible)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
      }
      .listStyle(.grouped)
    }
  }
  
  struct ProductGridView: View {
    @Binding var products: [Product]
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(products, id: \.self) { number in
            ProductGridCellView()
              .padding()
          }
        }
      }
    }
  }
}

struct ProductListView_Previews: PreviewProvider {
  static var previews: some View {
    ProductListDisplayView(.constant(.grid))
    ProductListDisplayView(.constant(.list))
  }
}
