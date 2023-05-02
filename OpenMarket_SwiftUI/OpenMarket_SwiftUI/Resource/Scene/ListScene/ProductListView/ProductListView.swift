//
//  ProductListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

// MARK: Content View
struct ProductListView: View {
  @StateObject var viewModel: ProductListViewModel
  @State private var reloadData: Bool = true
  
  var body: some View {
    VStack {
      NavigationTitleView(title: "상품 목록")
      
      listSection
    }
    .background(Color(uiColor: .secondarySystemFill))
    .onAppear {
      if reloadData {
        viewModel.fetchProducts()
      }
    }
  }
}

// MARK: Child View Components
private extension ProductListView {
  var listSection: some View {
    ScrollView {
      LazyVStack {
        ForEach(viewModel.products, id: \.id) { product in
          DetailProductCell(with: product)
            .cornerRadius(16)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .onAppear {
              viewModel.fetchNextPage(with: product)
            }
            .shadow(color: .black.opacity(0.2), radius: 2)
        }
      }
    }
    .listStyle(.plain)
  }
  
  @ViewBuilder func DetailProductCell(with product: Product) -> some View {
    NavigationLink {
      DetailProductView(
        viewModel: DetailProductViewModel(
          product: product,
          marketRepository: viewModel.marketRepository
        )
      )
      .onDisappear {
        viewModel.reloadProducts()
      }
    } label: {
      ProductListCellView(product: product)
    }
    .tint(.black)
  }
}

// MARK: Name Space
private extension ProductListView {
  enum Constants {
    static let rowEdge = EdgeInsets(top: 5, leading: 5, bottom: .zero, trailing: 5)
  }
}

// MARK: Previews
struct ProductListView_Previews: PreviewProvider {
  static let viewModel = ProductListViewModel()
  
  static var previews: some View {
    NavigationView {
      ProductListView(viewModel: viewModel)
    }
  }
}
