//
//  SearchTextField.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SearchTextField: View {
  let placeHolder: String
  @Binding var isPresentCancel: Bool
  @Binding var searchText: String
  
  @FocusState private var focusedSearch: Bool
  
  var body: some View {
    HStack {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.white)
        
        TextField(placeHolder, text: $searchText)
          .focused($focusedSearch)
      }
      .padding(16)
      .background(
        Color(uiColor: .secondarySystemFill)
          .cornerRadius(16)
      )
      .onChange(of: focusedSearch) { newValue in
        withAnimation {
          isPresentCancel = newValue
        }
      }
      
      if isPresentCancel {
        Button("취소") {
          withAnimation {
            keyBoardHide()
            focusedSearch.toggle()
          }
        }
      }
    }
  }
}

private extension View {
  func keyBoardHide() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil
    )
  }
}
