//
//  HomeScene.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct HomeScene: View {
  @State private var searchText: String = ""
  
  var body: some View {
    ScrollView {
      VStack(spacing: 16) {
        NavigationTitleView(title: "홈")
        
        SearchTextField(
          searchText: $searchText,
          placeHolder: "검색어를 입력해보세요."
        )
        .padding(.horizontal, 16)
        
        CategoryView()
        
        TitleSection(title: "추천 상품") {
          Button("모두 보기") {
            print("Tapped")
          }
          .tint(.secondary)
        }
        .padding(.horizontal, 16)
        
        RecommendListView()
      }
    }
    .background(Color(uiColor: .secondarySystemBackground))
    .navigationBarHidden(true)
  }
}
