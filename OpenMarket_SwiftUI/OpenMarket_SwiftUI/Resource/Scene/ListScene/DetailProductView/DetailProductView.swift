//
//  DetailProductView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct DetailProductView: View {
  @StateObject var viewModel: DetailProductViewModel
  
  @State private var isPresentTextFieldAlert: Bool = false
  
  var body: some View {
    ZStack {
      DetailProductInfoScrollView()
        .environmentObject(viewModel)
      
      AddCartButton()
    }
  }
}

private extension DetailProductView {
  struct AddCartButton: View {
    var body: some View {
      GeometryReader { proxy in
        VStack(alignment: .center) {
          Spacer()
          
          Button {
            // TODO: - Add Cart Method
            print("Tapped")
          } label: {
            HStack {
              Spacer()
              
              Text("장바구니 담기")
                .font(.system(size: 18, weight: .heavy, design: .rounded))
              
              Spacer()
            }
          }
          .frame(height: proxy.frame(in: .global).width * 0.15)
          .foregroundColor(.white)
          .background(Color.accentColor)
          .cornerRadius(16)
        }
        .padding(.horizontal, 16)
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
