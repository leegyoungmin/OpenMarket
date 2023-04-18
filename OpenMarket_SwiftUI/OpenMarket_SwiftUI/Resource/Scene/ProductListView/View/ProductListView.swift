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
        ZStack {
            if selectedSection == .list {
                ProductListView()
                    .environmentObject(viewModel)
            } else {
                ProductGridView()
                    .environmentObject(viewModel)
            }
            
            addProductButton
        }
        .onAppear {
            viewModel.reloadProducts()
        }
    }
}

// MARK: Child View Components
private extension ProductListDisplayView {
    var addProductButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                NavigationLink {
                    AddNewProductView(
                        viewModel: AddNewProductViewModel(
                            marketRepository: viewModel.marketWebRepository
                        )
                    )
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color.accentColor)
                        }
                }
            }
        }
        .padding()
    }
    
    struct ProductListView: View {
        @EnvironmentObject var viewModel: ProductListViewModel
        var body: some View {
            List {
                ForEach(viewModel.products, id: \.itemId) { product in
                    ProductListCellView(product: product)
                        .listRowInsets(Constants.rowEdge)
                        .onAppear {
                            if product == viewModel.products.last {
                                viewModel.fetchProducts()
                            }
                        }
                }
                .listRowSeparator(.hidden)
                
                if viewModel.canLoadNextPage {
                    ProgressView()
                }
            }
            .listStyle(.plain)
        }
    }
    
    struct ProductGridView: View {
        @EnvironmentObject var viewModel: ProductListViewModel
        
        var body: some View {
            List {
                ForEach(viewModel.products, id: \.itemId) { product in
                    HStack {
                        Spacer()
                        
                        ForEach(0..<2, id: \.self) { index in
                            ProductGridCellView(product: product)
                                .onAppear {
                                    if viewModel.products.last == product {
                                        viewModel.fetchProducts()
                                    }
                                }
                        }
                        
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 5, leading: .zero, bottom: 5, trailing: .zero))
                
                if viewModel.canLoadNextPage {
                    ProductListDisplayView.loadingProgressView
                }
            }
            .listStyle(.plain)
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
        static let columns = Array(repeating: GridItem(.flexible(minimum: .zero, maximum: UIScreen.main.bounds.width / 2)), count: 2)
    }
}

// MARK: Previews
struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            NavigationView {
                ProductListDisplayView(.constant(.grid))
            }
            
            NavigationView {
                ProductListDisplayView(.constant(.list))
            }
        }
    }
}
