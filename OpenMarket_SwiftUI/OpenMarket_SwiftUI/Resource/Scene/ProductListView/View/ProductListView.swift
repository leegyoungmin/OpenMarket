//
//  ProductListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

// MARK: Content View
struct ProductListDisplayView: View {
    @ObservedObject var viewModel: ProductListViewModel
    @Binding var selectedSection: ListSection
    
    init(_ selectedSection: Binding<ListSection>) {
        self._viewModel = ObservedObject(initialValue: ProductListViewModel())
        self._selectedSection = selectedSection
    }
    
    var body: some View {
        if selectedSection == .list {
            ProductListView(viewModel: viewModel, products: $viewModel.products)
        } else {
            ProductGridView(products: $viewModel.products)
        }
    }
}

// MARK: Child View Components
private extension ProductListDisplayView {
    struct ProductListView: View {
        private var viewModel: ProductListViewModel
        @Binding var products: [Product]
        
        init(viewModel: ProductListViewModel, products: Binding<[Product]>) {
            self.viewModel = viewModel
            self._products = .init(projectedValue: products)
        }
        
        var body: some View {
            List {
                ForEach(products, id: \.self) { product in
                    ProductListCellView(product: product)
                        .listRowInsets(Constants.rowEdge)
                        .task { viewModel.isLastItem(with: product) }
                }
                .listRowSeparator(.hidden)
                
                if viewModel.state == .loading {
                    ProductListDisplayView.loadingProgressView
                        .task {
                            viewModel.fetchProducts()
                        }
                }
            }
            .listStyle(.plain)
        }
    }
    
    struct ProductGridView: View {
        // TODO: - GRID 뷰 로딩 및 item 설정하기
        @Binding var products: [Product]
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: Constants.columns) {
                    ForEach(products, id: \.self) { number in
                        ProductGridCellView()
                            .padding()
                    }
                }
            }
        }
    }
}

extension ProductListDisplayView {
    static var loadingProgressView: some View {
        HStack {
            Spacer()
            
            ProgressView()
                .progressViewStyle(.circular)
            
            Spacer()
        }
    }
}

// MARK: Name Space
private extension ProductListDisplayView.ProductListView {
    enum Constants {
        static let rowEdge = EdgeInsets(top: 5, leading: 5, bottom: .zero, trailing: 5)
    }
}

private extension ProductListDisplayView.ProductGridView {
    enum Constants {
        static let columns = Array(repeating: GridItem(.flexible()), count: 2)
    }
}

// MARK: Previews
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListDisplayView(.constant(.grid))
        ProductListDisplayView(.constant(.list))
    }
}
