//
//  CategoryView.swift
//  OpenMarket_SwiftUI
//
//  Copyright (c) 2023 Minii All rights reserved.

import SwiftUI

struct CategoryView: View {
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHGrid(rows: [GridItem(.fixed(100))]) {
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
      HStack(alignment: .bottom, spacing: .zero) {
        VStack {
          Text(category.description)
            .font(.system(size: 24, weight: .semibold))
            .lineLimit(1)
            .foregroundColor(.white)
          
          Spacer()
        }
        .padding()
        
        Spacer()
        
        Image(category.imageName)
          .resizable()
          .scaledToFit()
          .imageScale(.large)
          .padding(.horizontal, 5)
          .frame(width: 80)
      }
      .frame(width: 200, height: 100)
      .background {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.accentColor)
      }
    }
  }
}

struct CategoryView_Previews: PreviewProvider {
  static var previews: some View {
    CategoryView()
  }
}
