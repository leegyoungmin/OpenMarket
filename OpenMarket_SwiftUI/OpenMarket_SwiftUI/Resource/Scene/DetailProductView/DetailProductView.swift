//
//  DetailProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct DetailProductView: View {
  @StateObject var viewModel: DetailProductViewModel
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        TabView {
          ForEach(viewModel.detailProduct.imagesInformation, id: \.id) { item in
            AsyncImage(url: URL(string: item.url)) { image in
              image
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            } placeholder: {
              ProgressView()
                .progressViewStyle(.circular)
                .frame(width: 300, height: 300)
            }
          }
        }
        .frame(height: 300)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        
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
            Text(viewModel.detailProduct.price.description)
              .foregroundColor(.red)
              .strikethrough()
              .opacity(viewModel.detailProduct.bargainPrice.isZero ? 1.0 : .zero)
            
            Text(viewModel.detailProduct.bargainPrice.description)
          }
        }
        .padding(10)
        
        Text(viewModel.detailProduct.description)
          .multilineTextAlignment(.leading)
          .padding(10)
      }
      .navigationBarTitleDisplayMode(.inline)
      .navigationTitle("상세 정보")
    }
  }
}

struct DetailProductView_Previews: PreviewProvider {
  static let viewModel = DetailProductViewModel(product: Product.mockData, marketRepository: MarketProductConcreteRepository())
  static var previews: some View {
    DetailProductView(viewModel: viewModel)
  }
}
