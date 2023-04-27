//
//  SearchView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel: SearchViewModel
  
  init() {
    let repository = MarketProductConcreteRepository()
    let viewModel = SearchViewModel(marketRepository: repository)
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  var body: some View {
    VStack {
      SearchTextField(
        searchText: $viewModel.searchQuery,
        placeHolder: "상품명, 판매자를 검색해보세요."
      )
      .onReceive(
        viewModel.$searchQuery.debounce(
          for: 0.5,
          scheduler: RunLoop.main
        )
      ) {
        if $0.isEmpty == false {
          viewModel.search(with: $0)
        } else {
          viewModel.searchedProducts = []
        }
      }
      
      if viewModel.searchedProducts.isEmpty {
        Spacer()
        
        Image(systemName: "tray.2")
          .resizable()
          .frame(width: 50, height: 50)
        
        Text("검색된 상품이 없습니다.")
          .font(.caption)
        
        Spacer()
      } else {
        ForEach(viewModel.searchedProducts, id: \.id) { product in
          HStack {
            Text(product.name)

            Spacer()
          }
          .padding(16)
          .background(Color.secondary)
          .cornerRadius(16)
        }
        
        Spacer()
      }
    }
    .padding(.horizontal, 16)
    .foregroundColor(.accentColor)
  }
}

struct SearchView_Previews: PreviewProvider {
  static let viewModel = HomeSceneViewModel(marketRepository: MarketProductConcreteRepository())
  static var previews: some View {
    SearchView()
      .environmentObject(viewModel)
  }
}
