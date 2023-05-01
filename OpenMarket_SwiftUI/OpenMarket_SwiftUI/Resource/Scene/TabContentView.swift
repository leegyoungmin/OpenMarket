//
//  ContentView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI

struct TabContentView: View {
  @State private var addNewProduct: Bool = false
  @State private var selectedScene: SceneType = .home
  
  var body: some View {
    NavigationStack {
      CustomTabBarView(
        tabs: SceneType.allCases,
        selection: $selectedScene,
        addNewProduct: $addNewProduct
      ) {
        switch selectedScene {
        case .home:
          HomeScene()
          
        case .search:
          SearchView()
          
        case .add:
          EmptyView()
          
        case .list:
          ProductListView(viewModel: ProductListViewModel())
          
        case .setting:
          SettingScene()
        }
      }
      .scrollIndicators(.hidden)
      .fullScreenCover(isPresented: $addNewProduct) {
        UploadProductView(viewModel: UploadProductViewModel())
      }
    }
  }
}

enum SceneType: Hashable, CaseIterable {
  case home
  case search
  case add
  case list
  case setting
  
  var iconName: String {
    switch self {
    case .home:
      return "house.fill"
    case .search:
      return "magnifyingglass"
    case .add:
      return "plus.app.fill"
    case .list:
      return "list.bullet"
    case .setting:
      return "gear"
    }
  }
  
  var title: String {
    switch self {
    case .home:
      return "홈"
    case .search:
      return "검색"
    case .add:
      return ""
    case .list:
      return "상품 목록"
    case .setting:
      return "설정"
    }
  }
}

struct CustomTabBarView<Scene: View>: View {
  let tabs: [SceneType]
  @Binding var selection: SceneType
  @Binding var addNewProduct: Bool
  @ViewBuilder var content: () -> Scene
  
  var body: some View {
    VStack(spacing: .zero) {
      content()
      
      ZStack(alignment: .bottom) {
        Rectangle()
          .fill(.white)
          .shadow(radius: 2)
          .edgesIgnoringSafeArea(.bottom)
        
        HStack(alignment: .bottom) {
          ForEach(tabs, id: \.iconName) { tab in
            HStack {
              Spacer()
              
              VStack(alignment: .center, spacing: 5) {
                Image(systemName: tab.iconName)
                  .font(tab == .add ? .largeTitle : .subheadline)
                
                if tab != .add {
                  Text(tab.title)
                    .font(.caption)
                }
              }
              .foregroundColor(tab == .add ? .accentColor : tab == selection ? .accentColor : .secondary)
              
              Spacer()
            }
            .onTapGesture {
              withAnimation {
                if tab == .add {
                  addNewProduct.toggle()
                } else {
                  selection = tab
                }
              }
            }
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
    TabContentView()
  }
}
