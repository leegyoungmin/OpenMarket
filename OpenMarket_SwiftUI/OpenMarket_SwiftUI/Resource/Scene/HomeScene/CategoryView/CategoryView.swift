//
//  CategoryView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct CategoryView: View {
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: [GridItem(.fixed(180))]) {
        ForEach(Category.allCases, id: \.self) { category in
          CategoryCell(category: category)
        }
      }
      .padding(.horizontal, 16)
    }
  }
}

private extension CategoryView {
  struct CategoryCell: View {
    let category: Category
    var body: some View {
      HStack(alignment: .top) {
        VStack {
          Text(category.description)
            .font(.system(size: 26, weight: .semibold))
            .foregroundColor(.white)
          
          Spacer()
        }
        
        Spacer()
        
        Image(systemName: "person")
          .resizable()
          .frame(width: 80, height: 80, alignment: .center)
      }
      .padding(30)
      .frame(width: 300)
      .background {
        RoundedRectangle(cornerRadius: 16)
          .fill(Color.blue)
      }
    }
  }
}

extension CategoryView {
  enum Category: Int, CaseIterable, CustomStringConvertible {
    case clothes
    case digital
    case furniture
    case sports
    case game
    case kids
    
    var description: String {
      get {
        switch self {
        case .clothes:
          return "의류"
        case .digital:
          return "디지털 / 가전"
        case .furniture:
          return "가구"
          
        case .sports:
          return "스포츠"
          
        case .game:
          return "게이밍"
          
        case .kids:
          return "아동"
        }
      }
    }
  }
}

struct CategoryView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryView()
  }
}
