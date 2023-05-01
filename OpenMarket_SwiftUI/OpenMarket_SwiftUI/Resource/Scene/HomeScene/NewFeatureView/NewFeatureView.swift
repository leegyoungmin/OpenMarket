//
//  NewFeatureView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct NewFeatureView: View {
  @Binding private(set) var newFeatures: [Product]
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(newFeatures, id: \.id) { product in
          newFeatureCell(with: product)
        }
      }
      .padding(.horizontal, 16)
    }
  }
}

extension NewFeatureView {
  @ViewBuilder func newFeatureCell(with product: Product) -> some View {
    VStack(alignment: .leading) {
      AsyncImage(url: URL(string: product.thumbnail)) { imagePhase in
        imagePhase
          .resizable()
          .frame(width: 90, height: 90, alignment: .center)
          .cornerRadius(16)
      } placeholder: {
        ProgressView()
          .progressViewStyle(.circular)
          .frame(width: 90, height: 90, alignment: .center)
      }
      
      Text(product.vendorName)
        .font(.system(.caption2))
      
      Text(product.name)
        .lineLimit(2)
        .font(.system(size: 13, weight: .thin))
      
      Text(product.bargainPriceDescription)
        .minimumScaleFactor(0.5)
        .font(.system(size: 16, weight: .medium))
        .foregroundColor(.accentColor)
    }
    .frame(maxWidth: 90)
  }
}
