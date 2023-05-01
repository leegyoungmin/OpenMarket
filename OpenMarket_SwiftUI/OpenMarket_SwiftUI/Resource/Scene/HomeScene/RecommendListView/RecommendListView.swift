//
//  RecommendListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct RecommendListView: View {
  @Binding private(set) var recommends: [Product]
  
  var body: some View {
    LazyVGrid(columns: Constants.columns, spacing: 16) {
      ForEach(recommends) { product in
        RecommendGridCell(product)
      }
    }
    .padding(.bottom, 16)
  }
}

private extension RecommendListView {
  @ViewBuilder func RecommendGridCell(_ product: Product) -> some View {
    ZStack {
      AsyncImage(url: URL(string: product.thumbnail), content: { image in
        image
          .resizable()
          .scaledToFill()
      }, placeholder: {
        ProgressView()
          .progressViewStyle(.circular)
      })
      
      favoriteButton
    }
    .frame(width: Constants.cellLength, height: Constants.cellLength)
    .background(Color.white)
    .cornerRadius(16)
    .shadow(radius: 1)

  }
  
  var favoriteButton: some View {
    VStack {
      HStack {
        Spacer()
        
        Button {
          print("Tapped")
        } label: {
          Image(systemName: "heart")
        }
        .padding(5)
        .background {
          Circle()
            .fill(.white)
        }
      }
      .padding()
      
      Spacer()
    }
  }
}

private extension RecommendListView {
  enum Constants {
    static let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    static let cellLength: CGFloat = 180
  }
}
