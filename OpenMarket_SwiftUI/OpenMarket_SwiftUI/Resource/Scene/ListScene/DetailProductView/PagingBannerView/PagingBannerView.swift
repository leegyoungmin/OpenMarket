//
//  PagingBannerView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct PagingBannerView: View {
  private let items: [ImageInformation]
  @State var selectedItem: Int = 0
  
  init(items: [ImageInformation]) {
    self.items = items
  }
  
  @ViewBuilder func URLImageView(path: String) -> some View {
    AsyncImage(url: URL(string: path)) { image in
      image
        .resizable()
        .scaledToFill()
        .frame(width: UIScreen.main.bounds.width, height: 300)
    } placeholder: {
      ProgressView()
        .progressViewStyle(.circular)
        .frame(width: UIScreen.main.bounds.width)
    }
  }
  
  var pagingView: some View {
    TabView(selection: $selectedItem) {
      ForEach(0..<items.count, id: \.self) { index in
        let url = items[index].url
        URLImageView(path: url).tag(index)
      }
    }
    .frame(height: 300)
    .tabViewStyle(.page(indexDisplayMode: .never))
    .cornerRadius(16)
  }
  
  var pageControl: some View {
    HStack {
      ForEach(0..<items.count, id: \.self) { index in
        Rectangle()
          .fill(index == selectedItem ? Color.accentColor : .black)
          .frame(width: 15, height: 2)
      }
    }
    .padding(12)
  }
  
  var body: some View {
    VStack {
      pagingView
      
      pageControl
    }
  }
}
