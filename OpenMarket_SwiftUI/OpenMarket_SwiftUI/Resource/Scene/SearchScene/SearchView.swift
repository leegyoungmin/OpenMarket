//
//  SearchView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel: SearchViewModel
  @State private var isPresent: Bool = false
  
  init() {
    let repository = MarketProductConcreteRepository()
    let viewModel = SearchViewModel(marketRepository: repository)
    self._viewModel = StateObject(wrappedValue: viewModel)
  }
  var body: some View {
    VStack {
      NavigationTitleView(title: "검색")
      
      Text("검색 횟수 : \(viewModel.searchCount.description)")
      
      SearchTextField(
        placeHolder: "상품명, 판매자명을 검색해보세요.",
        isPresentCancel: $isPresent,
        searchText: $viewModel.searchQuery
      )
      .onReceive(
        viewModel.$searchQuery
          .debounce(
            for: 0.5,
            scheduler: RunLoop.main
          )
      ) {
        viewModel.search(with: $0)
      }
      
      if viewModel.searchedProducts.isEmpty {
        emptyResultView
      } else {
        SearchResultListView(products: $viewModel.searchedProducts)
      }
    }
    .padding(.horizontal, 16)
    .background(Color(uiColor: .secondarySystemFill))
  }
}

private extension SearchView {
  var emptyResultView: some View {
    Group {
      Spacer()
      
      Image(systemName: "tray.2")
        .resizable()
        .frame(width: 50, height: 50)
      
      Text("검색된 상품이 없습니다.")
        .font(.caption)
      
      Spacer()
    }
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
