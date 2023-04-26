//
//  TitleSection.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct TitleSection<ButtonView: View>: View {
  let title: String
  @ViewBuilder let buttonView: () -> ButtonView
  
  init(title: String, buttonView: @escaping () -> ButtonView) {
    self.title = title
    self.buttonView = buttonView
  }
  
  var body: some View {
    HStack(alignment: .bottom) {
      Text(title)
        .font(.system(size: 20, weight: .semibold))
      
      Spacer()
      
      buttonView()
    }
  }
}
