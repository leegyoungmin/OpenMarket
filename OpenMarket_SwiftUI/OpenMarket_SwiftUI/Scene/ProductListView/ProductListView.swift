//
//  ProductListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct ProductListDisplayView: View {
  @Binding var selectedSection: ListSection
  
  init(_ selectedSection: Binding<ListSection>) {
    self._selectedSection = selectedSection
  }
  
  var body: some View {
    if selectedSection == .list {
      ProductListView()
    } else {
      ProductGridView()
    }
  }
}

private extension ProductListDisplayView {
  struct ProductListView: View {
    var body: some View {
      List {
        ForEach(1..<100, id: \.self) { number in
          HStack {
            ProductListCellView()
          }
        }
      }
      .listStyle(.plain)
    }
  }
  
  struct ProductGridView: View {
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(1..<100, id: \.self) { number in
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
