//
//  ContentView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.


import SwiftUI

enum ListSection: String, CaseIterable {
  case list = "LIST"
  case grid = "GRID"
}

struct ContentView: View {
  @State var selectedSection: ListSection = .list
  
  var body: some View {
    NavigationView {
      ProductListDisplayView($selectedSection)
        .toolbar {
          ToolbarItem(placement: .principal) {
            Picker("", selection: $selectedSection) {
              ForEach(ListSection.allCases, id: \.self) { section in
                Text(section.rawValue)
              }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
          }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
