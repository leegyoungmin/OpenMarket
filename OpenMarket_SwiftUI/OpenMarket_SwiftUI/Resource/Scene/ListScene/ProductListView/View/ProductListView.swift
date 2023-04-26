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
    listSection
      .navigateFloatingButton(color: .blue) {
        AddNewProductView(
          isSuccessUpload: $reloadData,
          viewModel: AddNewProductViewModel()
        )
      } image: {
        Image(systemName: "plus")
          .foregroundColor(.white)
      }
      .navigationTitle("상품 목록")
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
    List {
      ForEach(viewModel.products, id: \.id) { product in
        DetailProductCell(with: product)
          .onAppear {
            viewModel.fetchNextPage(with: product)
          }
      }
    }
    .listStyle(.plain)
  }
  
  @ViewBuilder func DetailProductCell(with product: Product) -> some View {
    ZStack {
      NavigationLink {
        DetailProductView(
          viewModel: DetailProductViewModel(
            product: product,
            marketRepository: viewModel.marketWebRepository
          )
        )
      } label: {
        EmptyView()
      }
      .opacity(.zero)
      
      ProductListCellView(product: product)
    }
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
