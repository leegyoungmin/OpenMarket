//
//  HomeScene.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct HomeScene: View {
  @StateObject private var viewModel = HomeSceneViewModel(
    marketRepository: MarketProductConcreteRepository()
  )
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        NavigationTitleView(title: "홈")
        
        TitleSection(title: "최신 상품") {
          EmptyView()
        }
        
        NewFeatureView(newFeatures: $viewModel.newFeatures)
          .padding(.horizontal, -16)
        
        TitleSection(title: "종류별로 보기") {
          EmptyView()
        }
        
        CategoryView()
          .padding(.horizontal, -16)
        
        TitleSection(title: "추천 상품") {
          Button("모두 보기") {
            print("Tapped")
          }
          .tint(.secondary)
        }
        
        RecommendListView(recommends: $viewModel.recommends)
      }
      .padding(.horizontal, 16)
    }
    .background(Color(uiColor: .secondarySystemBackground))
    .navigationBarHidden(true)
    .refreshable {
      viewModel.fetchNewFeatures()
      viewModel.fetchRecommendProducts()
    }
  }
}

struct HomeScene_Previews: PreviewProvider {
  static var previews: some View {
    HomeScene()
  }
}
