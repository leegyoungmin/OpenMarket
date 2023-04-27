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
      HStack(alignment: .bottom, spacing: .zero) {
        VStack {
          Text(category.description)
            .font(.system(size: 36, weight: .semibold))
            .lineLimit(1)
            .minimumScaleFactor(0.2)
            .foregroundColor(.white)
          
          Spacer()
        }
        .padding([.top, .leading], 30)
        
        Spacer()
        
        Image(category.imageName)
          .resizable()
          .scaledToFit()
          .imageScale(.large)
          .padding(.horizontal, 5)
      }
      .frame(width: 300, height: 200)
      .background {
        RoundedRectangle(cornerRadius: 16)
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
