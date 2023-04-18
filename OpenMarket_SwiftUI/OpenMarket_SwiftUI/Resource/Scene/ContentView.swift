//
//  ContentView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI

enum ListSection: String, CaseIterable {
  case list = "LIST"
  case grid = "GRID"
  
  mutating func toggle() {
    switch self {
    case .list:
      self = .grid
    case .grid:
      self = .list
    }
  }
}

struct ContentView: View {
  @State var selectedSection: ListSection = .list
  
  var body: some View {
    NavigationView {
      ProductListDisplayView($selectedSection)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              withAnimation {
                selectedSection.toggle()
              }
            } label: {
              Image(systemName: selectedSection == .list ? "square.grid.2x2" : "list.bullet")
            }
            
          }
        }
        .navigationTitle("판매 상품")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
