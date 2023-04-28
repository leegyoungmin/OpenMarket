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
          
        case .search:
          SearchView()
          
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
  case search
  case list
  case favorite
  
  var iconName: String {
    switch self {
    case .home:
      return "house.fill"
    case .search:
      return "magnifyingglass"
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
    case .search:
      return "검색"
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
      ZStack {
        Rectangle()
          .fill(.white)
          .shadow(radius: 2)
          .edgesIgnoringSafeArea(.bottom)
        
        HStack {
          Spacer()
          
          ForEach(tabs, id: \.self) { tab in
            VStack(spacing: 10) {
              Image(systemName: tab.iconName)
              
              Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
            .foregroundColor(tab == selection ? .accentColor : .gray)
            .onTapGesture {
              withAnimation {
                selection = tab
              }
            }
            
            Spacer()
          }
        }
      }
      .frame(maxHeight: 50)
    }
    .ignoresSafeArea(.keyboard, edges: .bottom)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
