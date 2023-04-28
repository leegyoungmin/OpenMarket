//
//  SearchTextField.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SearchTextField: View {
  @Binding var searchText: String
  let placeHolder: String
  
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.white)
      
      TextField(placeHolder, text: $searchText)
    }
    .padding(16)
    .background(
      Color(uiColor: .secondarySystemFill)
        .cornerRadius(16)
    )
  }
}
