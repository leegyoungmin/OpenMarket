//
//  DetailProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct DetailProductView: View {
  @StateObject var viewModel: DetailProductViewModel
  @State private var imageScale = 1.0
  @State private var offset: Int = 0
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        PagingBannerView(items: viewModel.detailProduct.imagesInformation)
        
        HStack(alignment: .bottom) {
          Text(viewModel.detailProduct.name)
            .font(.system(size: 25, weight: .bold, design: .default))
          
          Spacer()
          
          Text("남은 수량 : \(viewModel.detailProduct.stock.description)")
            .foregroundColor(.secondary)
        }
        .padding(10)
        
        HStack {
          Spacer()
          
          VStack(alignment: .leading) {
            Text(viewModel.detailProduct.price.convertCurrencyValue(with: viewModel.detailProduct.currency.rawValue))
              .foregroundColor(.red)
              .strikethrough()
              .opacity(viewModel.detailProduct.bargainPrice.isZero ? 1.0 : .zero)
            
            Text(viewModel.detailProduct.bargainPrice.convertCurrencyValue(with: viewModel.detailProduct.currency.rawValue))
          }
        }
        .padding(10)
        
        Text(viewModel.detailProduct.description)
          .multilineTextAlignment(.leading)
          .padding(10)
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("상품 상세")
    }
  }
}

private extension DetailProductView {
  struct PagingBannerView: View {
    private let items: [ImageInformation]
    @State var selectedItem: Int = 0
    
    init(items: [ImageInformation]) {
      self.items = items
    }
    
    var body: some View {
      ZStack {
        TabView(selection: $selectedItem) {
          ForEach(0..<items.count, id: \.self) { index in
            let url = items[index].url
            
            AsyncImage(url: URL(string: url)) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width, height: 300)
            } placeholder: {
              ProgressView()
                .progressViewStyle(.circular)
                .frame(width: UIScreen.main.bounds.width)
            }
            .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: 300)
        
        VStack {
          Spacer()
          
          HStack {
            ForEach(0..<items.count, id: \.self) { index in
              Rectangle()
                .fill(index == selectedItem ? .blue : .black)
                .frame(width: 15, height: 2)
            }
          }
        }
        .padding()
        .opacity(items.count == 1 ? 0 : 1)
      }
    }
  }
}

struct DetailProductView_Previews: PreviewProvider {
  static let viewModel = DetailProductViewModel(product: Product.mockData, marketRepository: MarketProductConcreteRepository())
  static var previews: some View {
    NavigationView {
      DetailProductView(viewModel: viewModel)
    }
  }
}
