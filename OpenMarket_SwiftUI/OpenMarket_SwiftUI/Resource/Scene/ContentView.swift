//
//  ContentView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI

struct ContentView: View {
  @State private var selectedScene: SceneType = .home

  var body: some View {
    NavigationView {
      CustomTabBarView(tabs: SceneType.allCases, selection: $selectedScene) {
        switch selectedScene {
        case .home:
          HomeScene()
          
        case .list:
          ProductListView(viewModel: ProductListViewModel())
        default:
          VStack {
            Spacer()
            Text("Example")
            Spacer()
          }
        }
      }
    }
  }
}

enum SceneType: Hashable, CaseIterable {
  case home
  case list
  case favorite
  
  var iconName: String {
    switch self {
    case .home:
      return "house.fill"
    case .list:
      return "list.bullet"
    case .favorite:
      return "heart"
    }
  }
  
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .list:
      return "상품 목록"
    case .favorite:
      return "찜목록"
    }
  }
}

struct CustomTabBarView<Scene: View>: View {
  let tabs: [SceneType]
  @Binding var selection: SceneType
  @ViewBuilder var content: () -> Scene
  
  var body: some View {
    VStack(spacing: .zero) {
      
      content()
      
      HStack {
        ForEach(tabs, id: \.self) { tab in
          VStack(spacing: 10) {
            Image(systemName: tab.iconName)
              .font(.subheadline)
            
            Text(tab.title)
              .font(.system(size: 10, weight: .semibold, design: .rounded))
          }
          .onTapGesture {
            withAnimation {
              selection = tab
            }
          }
          .foregroundColor(tab == selection ? .red : .blue)
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
          .cornerRadius(10)
        }
      }
      .background(.white)
      .shadow(radius: 2)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
