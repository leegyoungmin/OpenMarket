//
//  RecommendListView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct RecommendListView: View {
  var body: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), alignment: .center) {
      ForEach([Product.mockData]) { product in
        ZStack {
          AsyncImage(url: URL(string: product.thumbnail), content: { image in
            image
              .resizable()
              .scaledToFill()
              .frame(width: 180, height: 180)
          }, placeholder: {
            ProgressView()
              .progressViewStyle(.circular)
          })
          
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
        .frame(width: 180, height: 180)
        .background(.blue)
        .cornerRadius(16)
      }
    }
    .padding(.horizontal, 16)
  }
}
