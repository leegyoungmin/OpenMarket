//
//  SettingScene.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct SettingScene: View {
  @State var isOn: Bool = false
  let id = String.createRandomStr(length: 8)
  var body: some View {
    NavigationStack {
      VStack(spacing: .zero) {
        HStack(alignment: .top, spacing: 16) {
          Image(systemName: "person.circle")
            .resizable()
            .frame(width: 60, height: 60)
          
          VStack(alignment: .leading) {
            Text("User - \(id)")
              .font(.system(size: 24, weight: .heavy))
            
            Text("쿠폰 : \(Int.zero)")
          }
          
          Spacer()
        }
        .padding(16)
        .background(Color.accentColor)
        
        Form {
          Section("알림 설정") {
            NavigationLink("알림 설정") {
              Form {
                Toggle("알림", isOn: $isOn)
              }
            }
          }
        }
      }
    }
  }
}

private extension String {
  static func createRandomStr(length: Int) -> String {
    let values = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let str = (0 ..< length).map{ _ in values.randomElement()! }
    return String(str)
  }
}

struct Previews_SettingScene_Previews: PreviewProvider {
  static var previews: some View {
    SettingScene()
  }
}
