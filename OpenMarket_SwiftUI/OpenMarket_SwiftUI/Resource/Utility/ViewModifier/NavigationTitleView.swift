//
//  NavigationTitleView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct NavigationTitleView: View {
  let title: String
  
  var body: some View {
    HStack {
      Spacer()
      
      Text(title)
        .font(.system(size: 18, weight: .semibold))
      
      Spacer()
    }
  }
}
